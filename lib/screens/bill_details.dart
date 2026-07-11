

import 'package:billing_app/models/bill_item.dart';

import 'package:billing_app/services/pdf_service.dart';
import 'package:billing_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class BillDetailPage extends StatelessWidget {
  final BillItem billItem;
  const BillDetailPage({super.key, required this.billItem});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Bill Preview'),
        backgroundColor: const Color(0xFF1E3A8A),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _row('Party Name', billItem.partyName),
            _row('Weft Name / Qty', billItem.weftName),
            _row('Set No.', billItem.setNo),
            _row('Rate', billItem.rate.toStringAsFixed(2)),
            _row('Total Consumption', billItem.totalConsumption.toStringAsFixed(2)),
            _row('Per Cut', billItem.perCut.toStringAsFixed(2)),
            _row('Pagar', billItem.pagar.toStringAsFixed(2)),
            _row('Total Dori', billItem.totalDori.toStringAsFixed(2)),
            _row('Zyada Bacha', billItem.zyadaBacha.toStringAsFixed(2)),
            _row('Dori', billItem.dori.toStringAsFixed(2)),
            _row('Total Cut', billItem.totalCut.toStringAsFixed(2)),
            _row('Final Amount', billItem.finalAmount.toStringAsFixed(2)),
            const Divider(height: 32),
            _row('Grand Total', billItem.total.toStringAsFixed(0), bold: true),
            const SizedBox(height: 24),
            PremiumButton(
              label: 'Download / Share PDF',
              icon: Icons.picture_as_pdf_rounded,
              onPressed: () => BillPdfGenerator.generateAndOpen(billItem: billItem),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 14)),
          Text(
            value,
            style: TextStyle(
              fontSize: bold ? 18 : 14,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }
}