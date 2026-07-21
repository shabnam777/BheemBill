import 'dart:convert';

/// Represents ONE complete bill — combines fields from BOTH form steps:
/// Step 1 (weft/warp/cut details) + Step 2 (market credit/debit details).
class BillItem {
  // ---------- STEP 1 fields ----------
  String partyName;
  String weftName;
  String setNo;
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

  // ---------- STEP 2 fields ----------
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
    this.partyName = '',
    this.weftName = '',
    this.setNo = '',
    this.rate = 0,
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

  /// Safely parses a date value that might be a String (from JSON),
  /// a DateTime already, or missing/null entirely.
  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    if (value is String) {
      return DateTime.tryParse(value) ?? DateTime.now();
    }
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
        partyName: _parseString(map['partyName']),
        weftName: _parseString(map['weftName']),
        setNo: _parseString(map['setNo']),
        rate: _parseDouble(map['rate']),
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
        'otherExpense': otherExpense,
        'warpRate': warpRate,
        'warpTotal': warpTotal,
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

  BillItem copyWith({
    String? partyName,
    String? weftName,
    String? setNo,
    double? rate,
    double? totalConsumption,
    double? perCut,
    double? pagar,
    double? totalDori,
    double? zyadaBacha,
    double? finalAmount,
    double? dori,
    double? totalCut,
    double? total,
    DateTime? startDate,
    DateTime? endDate,
    double? otherExpense,
    double? warpRate,
    double? warpTotal,
    double? marketCredit,
    String? creditDate,
    String? creditParty,
    String? baleNo,
    double? totalTakha,
    double? totalMtr,
    double? creditRate,
    double? creditAmount,
    double? mtrAvg,
    double? creditFinalAmount,
    double? debitFinalAmount,
  }) {
    return BillItem(
      partyName: partyName ?? this.partyName,
      weftName: weftName ?? this.weftName,
      setNo: setNo ?? this.setNo,
      rate: rate ?? this.rate,
      totalConsumption: totalConsumption ?? this.totalConsumption,
      perCut: perCut ?? this.perCut,
      pagar: pagar ?? this.pagar,
      totalDori: totalDori ?? this.totalDori,
      zyadaBacha: zyadaBacha ?? this.zyadaBacha,
      finalAmount: finalAmount ?? this.finalAmount,
      dori: dori ?? this.dori,
      totalCut: totalCut ?? this.totalCut,
      total: total ?? this.total,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      rateGST: rateGST,
      kg: kg,
      otherExpense: otherExpense ?? this.otherExpense,
      warpRate: warpRate ?? this.warpRate,
      warpTotal: warpTotal ?? this.warpTotal,
      marketCredit: marketCredit ?? this.marketCredit,
      creditDate: creditDate ?? this.creditDate,
      creditParty: creditParty ?? this.creditParty,
      baleNo: baleNo ?? this.baleNo,
      totalTakha: totalTakha ?? this.totalTakha,
      totalMtr: totalMtr ?? this.totalMtr,
      creditRate: creditRate ?? this.creditRate,
      creditAmount: creditAmount ?? this.creditAmount,
      mtrAvg: mtrAvg ?? this.mtrAvg,
      creditFinalAmount: creditFinalAmount ?? this.creditFinalAmount,
      debitFinalAmount: debitFinalAmount ?? this.debitFinalAmount,
    );
  }
}
