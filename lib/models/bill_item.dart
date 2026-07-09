import 'dart:convert';

import 'package:flutter/material.dart';

class BillItem extends ChangeNotifier {
  String partyName; // Cut No. / Party Name
  String weftName; // Qty
  String setNo;
  double rate;
  double rateGST;
  double totalConsumption;
  double perCut;
  double pagar;
  double totalDori;
  double zyadaBacha;
  double finalAmount; // Rate per unit
  double dori;
  double kg; // Dori charge
  double totalCut; // Cut Total
  double total;
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();

  BillItem({
    required this.partyName,
    required this.weftName,
    required this.setNo,
    required this.rate,
    required this.totalConsumption,
    required this.perCut,
    required this.pagar,
    required this.totalDori,
    required this.zyadaBacha,
    required this.finalAmount,
    required this.dori,
    required this.totalCut,
    required this.total,
    required this.startDate,
    required this.endDate,
    required this.rateGST,
    required this.kg,
  });

  factory BillItem.empty() => BillItem(
      partyName: '',
      weftName: '',
      setNo: '',
      rate: 0,
      totalConsumption: 0,
      perCut: 0,
      pagar: 0,
      totalDori: 0,
      zyadaBacha: 0,
      finalAmount: 0,
      dori: 0,
      totalCut: 0,
      total: 0,
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      rateGST: 0,
      kg: 0);

  factory BillItem.fromMap(Map<String, dynamic> map) => BillItem(
      partyName: map['partyName'] ?? '',
      weftName: map['weftName'] ?? '',
      setNo: map['setNo'] ?? '',
      rate: (map['rate'] ?? 0).toDouble(),
      totalConsumption: (map['totalConsumption'] ?? 0).toDouble(),
      perCut: (map['perCut'] ?? 0).toDouble(),
      pagar: (map['pagar'] ?? 0).toDouble(),
      totalDori: (map['totalDori'] ?? 0).toDouble(),
      zyadaBacha: (map['zyadaBacha'] ?? 0).toDouble(),
      finalAmount: (map['finalAmount'] ?? 0).toDouble(),
      dori: (map['dori'] ?? 0).toDouble(),
      totalCut: (map['totalCut'] ?? 0).toDouble(),
      total: (map['total'] ?? 0).toDouble(),
      startDate: DateTime.now(),
      endDate: DateTime.now(),
      rateGST: (map['rateGST'] ?? 0).toDouble(),
      kg: (map['kg'] ?? 0).toDouble());

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
        startDate: startDate,
        endDate: endDate,
        rateGST: rateGST,
        kg: kg);
  }

  void setBillDetails({
    required String partyName,
    required String weftName,
    required String setNo,
    required double rate,
    required double totalConsumption,
    required double perCut,
    required double pagar,
    required double totalDori,
    required double zyadaBacha,
    required double finalAmount,
    required double dori,
    required double totalCut,
    required double total,
    required DateTime startDate,
    required DateTime endDate,
    required double rateGST,
    required double kg,
  }) {
    this.partyName = partyName;
    this.weftName = weftName;
    this.setNo = setNo;
    this.rate = rate;
    this.totalConsumption = totalConsumption;
    this.perCut = perCut;
    this.pagar = pagar;
    this.totalDori = totalDori;
    this.zyadaBacha = zyadaBacha;
    this.finalAmount = finalAmount;
    this.dori = dori;
    this.totalCut = totalCut;
    this.total = total;
    this.startDate = startDate;
    this.endDate = endDate;
    this.rateGST = rateGST;
    this.kg = kg;
  }

  notifyListeners();
}
