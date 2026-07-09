import 'package:flutter/material.dart';
import 'bill_item.dart';

/// Holds customer/bill header info + all line items.
/// Acts as app-wide state via Provider (ChangeNotifier).
class Bill extends ChangeNotifier {
  String billNo = '';
  DateTime billDate = DateTime.now();
  String customerName = '';
  String customerPhone = '';
  String customerAddress = '';
  double rate = 0.0;

  final List<BillItem> items = [];

 


  void addItem(BillItem item) {
    items.add(item);
    notifyListeners();
  }

  void updateItem(int index, BillItem item) {
    items[index] = item;
    notifyListeners();
  }

  void removeItem(int index) {
    items.removeAt(index);
    notifyListeners();
  }

  void clearAll() {
    billNo = '';
    customerName = '';
    customerPhone = '';
    customerAddress = '';
    items.clear();
    notifyListeners();
  }
}
