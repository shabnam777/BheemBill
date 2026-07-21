import 'dart:convert';

import 'package:billing_app/models/bill_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Saves bill data to the phone's local storage (SharedPreferences).
class BillStorageService {
  static const _draftKey = 'bill_draft';
  static const _billsKey = 'saved_bills';

  static Future<void> saveDraftStep(Map<String, dynamic> stepData) async {
    final prefs = await SharedPreferences.getInstance();
    final existing = await getDraft();
    final merged = {...existing, ...stepData};
    await prefs.setString(_draftKey, jsonEncode(merged));
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

  static Future<void> saveFinalBill(BillItem item) async {
    final prefs = await SharedPreferences.getInstance();
    final bills = await getAllBillMaps();
    final map = item.toMap();
    map['savedAt'] = DateTime.now().toIso8601String();
    bills.add(map);
    await prefs.setString(_billsKey, jsonEncode(bills));
    await clearDraft();
  }

  static Future<List<Map<String, dynamic>>> getAllBillMaps() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_billsKey);
    if (raw == null) return [];
    final list = jsonDecode(raw) as List;
    return list.cast<Map<String, dynamic>>();
  }



  /// Returns all bills whose bill period (startDate–endDate) overlaps with
  /// the given search range [rangeStart, rangeEnd].
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

      // Overlap check: bill period aur search range kahin bhi cross karte hain
      return !e.isBefore(searchStart) && !s.isAfter(searchEnd);
    });

    return matches.map((b) => BillItem.fromMap(b)).toList();
  }
}
