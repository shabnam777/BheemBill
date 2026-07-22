import 'dart:convert';

/// Represents ONE complete bill — Step 1 (weft/warp/cut) + Step 2 (credit/debit).
class BillItem {
  // ---------- STEP 1 fields ----------
  int invoiceNumber;
  String partyName; // Weft Name + Party Name (combined)
  String weftName; // Warp Name + Party Name
  String setNo; // Market Debit
  double rate;
  double rateGST;
  double totalConsumption;
  double perCut;
  double pagar;
  double totalDori;
  double zyadaBacha;
  double dori;
  double kg;
  double totalCut;
  double total;
  double otherExpense;
  double warpRate;
  double warpTotal;
  DateTime startDate;
  DateTime endDate;

  // ---------- Weft carry-forward fields ----------
  double previousWeft;
  double newWeft;
  double balanceWeft;
  double count;
  double lagat;
  double usedWeft;

  // ---------- Cut carry-forward fields ----------
  double previousCut;
  double newCut;
  double soldCut;
  double remainingCut;
  double preWeftAvg;
  double preCutAvg;
  double weftAvgAmt;
  double cutAvgAmt;

  // ---------- STEP 2 fields (market credit/debit) ----------
  double marketCredit;
  String creditDate;
  String creditParty;
  String baleNo;
  double totalTakha;
  double totalMtr;
  double creditRate;
  double creditAmount;
  double mtrAvg;
  double creditFinalAmount;
  double debitFinalAmount;
  double finalAmount;

  BillItem({
    this.invoiceNumber = 0,
    this.partyName = '',
    this.weftName = '',
    this.setNo = '',
    this.rate = 0,
    this.preWeftAvg = 0,
    this.preCutAvg = 0,
    this.weftAvgAmt = 0,
    this.cutAvgAmt = 0,
    this.totalConsumption = 0,
    this.perCut = 0,
    this.pagar = 0,
    this.totalDori = 0,
    this.zyadaBacha = 0,
    this.finalAmount = 0,
    this.dori = 0,
    this.totalCut = 0,
    this.total = 0,
    DateTime? startDate,
    DateTime? endDate,
    this.rateGST = 0,
    this.kg = 0,
    this.otherExpense = 0,
    this.warpRate = 0,
    this.warpTotal = 0,
    this.previousWeft = 0,
    this.newWeft = 0,
    this.balanceWeft = 0,
    this.count = 0,
    this.lagat = 0,
    this.usedWeft = 0,
    this.previousCut = 0,
    this.newCut = 0,
    this.soldCut = 0,
    this.remainingCut = 0,
    this.marketCredit = 0,
    this.creditDate = '',
    this.creditParty = '',
    this.baleNo = '',
    this.totalTakha = 0,
    this.totalMtr = 0,
    this.creditRate = 0,
    this.creditAmount = 0,
    this.mtrAvg = 0,
    this.creditFinalAmount = 0,
    this.debitFinalAmount = 0,
  })  : startDate = startDate ?? DateTime.now(),
        endDate = endDate ?? DateTime.now();

  factory BillItem.empty() => BillItem();

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value) ?? DateTime.now();
    return DateTime.now();
  }

  static double _parseDouble(dynamic value) {
    if (value == null) return 0;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static String _parseString(dynamic value) {
    if (value == null) return '';
    return value.toString();
  }

  factory BillItem.fromMap(Map<String, dynamic> map) => BillItem(
        invoiceNumber: map['invoiceNumber'] is int ? map['invoiceNumber'] : int.tryParse(map['invoiceNumber']?.toString() ?? '') ?? 0,
        partyName: _parseString(map['partyName']),
        weftName: _parseString(map['weftName']),
        setNo: _parseString(map['setNo']),
        rate: _parseDouble(map['rate']),
        preWeftAvg: _parseDouble(map['preWeftAvg']),
        preCutAvg: _parseDouble(map['preCutAvg']),
        weftAvgAmt: _parseDouble(map['weftAvgAmt']),
        cutAvgAmt: _parseDouble(map['cutAvgAmt']),
        totalConsumption: _parseDouble(map['totalConsumption']),
        perCut: _parseDouble(map['perCut']),
        pagar: _parseDouble(map['pagar']),
        totalDori: _parseDouble(map['totalDori']),
        zyadaBacha: _parseDouble(map['zyadaBacha']),
        finalAmount: _parseDouble(map['finalAmount']),
        dori: _parseDouble(map['dori']),
        totalCut: _parseDouble(map['totalCut']),
        total: _parseDouble(map['total']),
        startDate: _parseDate(map['startDate']),
        endDate: _parseDate(map['endDate']),
        rateGST: _parseDouble(map['rateGST']),
        kg: _parseDouble(map['kg']),
        otherExpense: _parseDouble(map['otherExpense']),
        warpRate: _parseDouble(map['warpRate']),
        warpTotal: _parseDouble(map['warpTotal']),
        previousWeft: _parseDouble(map['previousWeft']),
        newWeft: _parseDouble(map['newWeft']),
        balanceWeft: _parseDouble(map['balanceWeft']),
        count: _parseDouble(map['count']),
        lagat: _parseDouble(map['lagat']),
        usedWeft: _parseDouble(map['usedWeft']),
        previousCut: _parseDouble(map['previousCut']),
        newCut: _parseDouble(map['newCut']),
        soldCut: _parseDouble(map['soldCut']),
        remainingCut: _parseDouble(map['remainingCut']),
        marketCredit: _parseDouble(map['marketCredit']),
        creditDate: _parseString(map['creditDate']),
        creditParty: _parseString(map['creditParty']),
        baleNo: _parseString(map['baleNo']),
        totalTakha: _parseDouble(map['totalTakha']),
        totalMtr: _parseDouble(map['totalMtr']),
        creditRate: _parseDouble(map['creditRate']),
        creditAmount: _parseDouble(map['creditAmount']),
        mtrAvg: _parseDouble(map['mtrAvg']),
        creditFinalAmount: _parseDouble(map['creditFinalAmount']),
        debitFinalAmount: _parseDouble(map['debitFinalAmount']),
      );

  Map<String, dynamic> toMap() => {
        'invoiceNumber': invoiceNumber,
        'partyName': partyName,
        'weftName': weftName,
        'setNo': setNo,
        'rate': rate,
        'totalConsumption': totalConsumption,
        'perCut': perCut,
        'pagar': pagar,
        'totalDori': totalDori,
        'zyadaBacha': zyadaBacha,
        'finalAmount': finalAmount,
        'dori': dori,
        'totalCut': totalCut,
        'total': total,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String(),
        'rateGST': rateGST,
        'kg': kg,
        'preWeftAvg':preWeftAvg,
        'preCutAvg':preCutAvg,
        'weftAvgAmt':weftAvgAmt,
        'cutAvgAmt':cutAvgAmt,
        'otherExpense': otherExpense,
        'warpRate': warpRate,
        'warpTotal': warpTotal,
        'previousWeft': previousWeft,
        'newWeft': newWeft,
        'balanceWeft': balanceWeft,
        'count': count,
        'lagat': lagat,
        'usedWeft': usedWeft,
        'previousCut': previousCut,
        'newCut': newCut,
        'soldCut': soldCut,
        'remainingCut': remainingCut,
        'marketCredit': marketCredit,
        'creditDate': creditDate,
        'creditParty': creditParty,
        'baleNo': baleNo,
        'totalTakha': totalTakha,
        'totalMtr': totalMtr,
        'creditRate': creditRate,
        'creditAmount': creditAmount,
        'mtrAvg': mtrAvg,
        'creditFinalAmount': creditFinalAmount,
        'debitFinalAmount': debitFinalAmount,
      };

  factory BillItem.fromJson(String source) => BillItem.fromMap(jsonDecode(source));

  String toJson() => jsonEncode(toMap());
}
