import 'dart:convert';
import 'dart:io';

import 'package:billing_app/models/bill_item.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Saves bills to a dedicated folder on the device (mobile) or to browser
/// storage (web, since real folders aren't accessible there).
///
/// RULE: only ONE bill per date-range is kept — saving a bill for a range
/// that already has one automatically replaces the old one.
class BillStorageService {
  static const _draftKey = 'bill_draft';
  static const _billsKey = 'saved_bills'; // used for web + as draft storage

  static const String folderName = 'BheemBillData';

  // ---------- DRAFT (step-by-step, in-progress) — same on both platforms ----------

  static Future<void> saveDraftStep(Map<String, dynamic> stepData) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getDraft();
    final merged = {...existing, ...stepData};
    await prefs.setString(_draftKey, jsonEncode(_sanitize(merged))); // <-- _sanitize() add kiya
  }

  static Future<Map<String, dynamic>> getDraft() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_draftKey);
    if (raw == null) return {};
    return jsonDecode(raw) as Map<String, dynamic>;
  }

  static Future<void> clearDraft() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_draftKey);
  }

  // ---------- Helpers ----------

  /// Unique key per date-range, e.g. "2026-07-21_to_2026-07-30".
  /// Two bills with the exact same start+end date will always collide
  /// on this key — that's what enforces "one bill per date range".
  static String _rangeKey(DateTime start, DateTime end) {
    String fmt(DateTime d) => '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
    return '${fmt(start)}_to_${fmt(end)}';
  }

  /// Mobile only — app-private folder (no permissions needed, not visible
  /// to the phone's Files app, but safe and always writable).
  static Future<Directory> _getBillsFolder() async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final billsDir = Directory('${appDocDir.path}/$folderName');
    if (!await billsDir.exists()) {
      await billsDir.create(recursive: true);
    }
    return billsDir;
  }

  /// Finds the next invoice number — reuses gaps left by deleted bills
  /// instead of skipping them, so numbering always stays 1,2,3,4... without
  /// permanent holes. If no bills exist yet, returns 1.
  static Future<int> getNextInvoiceNumber() async {
    final all = await getAllBillMaps();

    final usedNumbers = all
        .map((b) => b['invoiceNumber'] is int ? b['invoiceNumber'] as int : int.tryParse(b['invoiceNumber']?.toString() ?? '') ?? 0)
        .where((n) => n > 0)
        .toSet();

    int candidate = 1;
    while (usedNumbers.contains(candidate)) {
      candidate++;
    }
    return candidate;
  }

  /// Fetches a single bill by its invoice number.
  static Future<BillItem?> getBillByInvoiceNumber(int invoiceNumber) async {
    final all = await getAllBillMaps();

    for (final map in all) {
      final num = map['invoiceNumber'] is int ? map['invoiceNumber'] as int : int.tryParse(map['invoiceNumber']?.toString() ?? '') ?? 0;
      if (num == invoiceNumber) {
        return BillItem.fromMap(map);
      }
    }
    return null;
  }
  // ---------- SAVE / READ finalized bills ----------

  static Future<void> saveFinalBill(BillItem item) async {
    final key = _rangeKey(item.startDate, item.endDate);
    final map = _sanitize(item.toMap()); // <-- _sanitize() add kiya
    map['savedAt'] = DateTime.now().toIso8601String();

    if (kIsWeb) {
      // Web: no real filesystem — store as a list in browser storage,
      // removing any existing entry for the same date-range first.
      final prefs = await SharedPreferences.getInstance();
      final bills = await getAllBillMaps();
      bills.removeWhere((b) {
        final s = DateTime.tryParse(b['startDate'] ?? '');
        final e = DateTime.tryParse(b['endDate'] ?? '');
        if (s == null || e == null) return false;
        return _rangeKey(s, e) == key;
      });
      bills.add(map);
      await prefs.setString(_billsKey, jsonEncode(bills));
    } else {
      // Mobile: one JSON file per date-range inside the dedicated folder.
      // Writing to the same filename automatically replaces the old bill.
      final folder = await _getBillsFolder();
      final file = File('${folder.path}/$key.json');
      if (await file.exists()) {
        await file.delete(); // explicit delete of the old bill for this range
      }
      await file.writeAsString(jsonEncode(map));
    }

    await clearDraft();
  }

  static Future<List<Map<String, dynamic>>> getAllBillMaps() async {
    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_billsKey);
      if (raw == null) return [];
      final list = jsonDecode(raw) as List;
      return list.cast<Map<String, dynamic>>();
    } else {
      final folder = await _getBillsFolder();
      final files = folder.listSync().whereType<File>().where((f) => f.path.endsWith('.json'));

      final bills = <Map<String, dynamic>>[];
      for (final file in files) {
        try {
          final content = await file.readAsString();
          bills.add(jsonDecode(content) as Map<String, dynamic>);
        } catch (_) {
          // skip a corrupted/unreadable file instead of crashing
        }
      }
      return bills;
    }
  }

  static Future<List<BillItem>> getBillsByDateRange(
    DateTime rangeStart,
    DateTime rangeEnd,
  ) async {
    final all = await getAllBillMaps();
    final searchStart = DateTime(rangeStart.year, rangeStart.month, rangeStart.day);
    final searchEnd = DateTime(rangeEnd.year, rangeEnd.month, rangeEnd.day);

    final matches = all.where((b) {
      final billStart = DateTime.tryParse(b['startDate'] ?? '');
      final billEnd = DateTime.tryParse(b['endDate'] ?? '');
      if (billStart == null || billEnd == null) return false;

      final s = DateTime(billStart.year, billStart.month, billStart.day);
      final e = DateTime(billEnd.year, billEnd.month, billEnd.day);

      return !e.isBefore(searchStart) && !s.isAfter(searchEnd);
    });

    return matches.map((b) => BillItem.fromMap(b)).toList();
  }

  /// Deletes a single bill given its date range (e.g. for a manual delete button).
  static Future<void> deleteBillByRange(DateTime start, DateTime end) async {
    final key = _rangeKey(start, end);

    if (kIsWeb) {
      final prefs = await SharedPreferences.getInstance();
      final bills = await getAllBillMaps();
      bills.removeWhere((b) {
        final s = DateTime.tryParse(b['startDate'] ?? '');
        final e = DateTime.tryParse(b['endDate'] ?? '');
        if (s == null || e == null) return false;
        return _rangeKey(s, e) == key;
      });
      await prefs.setString(_billsKey, jsonEncode(bills));
    } else {
      final folder = await _getBillsFolder();
      final file = File('${folder.path}/$key.json');
      if (await file.exists()) {
        await file.delete();
      }
    }
  }
}

/// Recursively replaces any NaN/Infinity numeric values with 0 —
/// JSON doesn't support NaN/Infinity, so jsonEncode crashes without this.
Map<String, dynamic> _sanitize(Map<String, dynamic> map) {
  final clean = <String, dynamic>{};
  map.forEach((key, value) {
    if (value is double && (value.isNaN || value.isInfinite)) {
      clean[key] = 0;
    } else {
      clean[key] = value;
    }
  });
  return clean;
}

/// Carry-forward values pulled from the immediately previous bill —
/// used to pre-fill or display last period's outstanding numbers.
class PreviousBillCarryForward {
  final String previousWeft; // last bill ka "Weft Name + Party Name"
  final double previousCutTotal; // last bill ka Total Cut
  final double previousMarketDebit; // last bill ka Market Debit (setNo field)
  final double previousMarketCredit; // last bill ka Market Credit

  PreviousBillCarryForward({
    required this.previousWeft,
    required this.previousCutTotal,
    required this.previousMarketDebit,
    required this.previousMarketCredit,
  });
}
