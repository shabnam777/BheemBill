import 'package:billing_app/models/bill_item.dart';
import 'package:flutter/material.dart';

class PremiumTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool readOnly;
  final IconData? icon;
  final String? prefixText;
  final ValueChanged<String>? onChanged;
  final Color? textColor;

  const PremiumTextField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
    this.icon,
    this.prefixText,
    this.onChanged,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1E293B).withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: const Color(0xFFD1D5DB),
          width: 1,
        ),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor ?? const Color(0xFF1E293B), // 👈 sirf yahan change
          letterSpacing: 0.2,
        ),
        cursorColor: const Color(0xFF1D4ED8),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF64748B),
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
          floatingLabelStyle: const TextStyle(
            color: Color(0xFF1D4ED8),
            fontWeight: FontWeight.w700,
          ),
          prefixText: prefixText,
          prefixStyle: const TextStyle(
            color: Color(0xFF1D4ED8),
            fontWeight: FontWeight.w700,
          ),
          prefixIcon: icon != null ? Icon(icon, color: const Color(0xFF1D4ED8), size: 20) : null,
          filled: true,
          fillColor: Colors.transparent,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color(0xFF1D4ED8), width: 1.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}

class PremiumButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;
  final bool isLoading;
  final List<Color>? gradientColors;

  const PremiumButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final colors = gradientColors ?? const [Color(0xFF1E3A8A), Color(0xFF1D4ED8)];

    return Container(
      height: 42,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        boxShadow: [
          BoxShadow(
            color: colors.first.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? const SizedBox(
                height: 22,
                width: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.4,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class TwoFieldRow extends StatelessWidget {
  final Widget left;
  final Widget right;
  final double spacing;
  final int leftFlex;
  final int rightFlex;

  const TwoFieldRow({
    super.key,
    required this.left,
    required this.right,
    this.spacing = 8,
    this.leftFlex = 1,
    this.rightFlex = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0, top: 4.0), // Add some vertical spacing between rows
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: leftFlex,
            child: left,
          ),
          SizedBox(width: spacing),
          Expanded(
            flex: rightFlex,
            child: right,
          ),
        ],
      ),
    );
  }
}

class PremiumDivider extends StatelessWidget {
  final Color? color;
  final double thickness;
  final double radius;
  final EdgeInsetsGeometry? margin;

  const PremiumDivider({
    super.key,
    this.color,
    this.thickness = 3,
    this.radius = 20,
    this.margin = const EdgeInsets.symmetric(vertical: 7),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin!,
      child: Divider(
        color: color ?? const Color.fromARGB(255, 15, 64, 147),
        thickness: thickness,
        radius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Returns a premium-looking ListTile card showing just the final amount.
Widget PremiumAmountTile(double amount) {
  return Padding(
    padding: const EdgeInsets.only(top: 8.0),
    child: Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [Colors.indigo.shade50, Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.indigo.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.indigo.shade100, width: 1),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [Colors.indigo.shade400, Colors.indigo.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Icon(Icons.currency_rupee, color: Colors.white, size: 22),
        ),
        title: const Text(
          'Final Amount',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.currency_rupee,
              size: 18,
              color: amount >= 0 ? Colors.green.shade800 : Colors.red.shade700,
            ),
            Text(
              amount.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: amount >= 0 ? Colors.green.shade800 : Colors.red.shade700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// Shows saved bills for a selected date inside a modal dialog.
/// Pass the list of BillItems returned by BillStorageService.getBillsByDate().
void showBillViewModal(BuildContext context, List<BillItem> bills) {
  showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxHeight: 520, maxWidth: 420),
        child: bills.isEmpty
            ? const Padding(
                padding: EdgeInsets.all(24),
                child: Text('Bill Not Found.'),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Saved Bills',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const Divider(),
                    Flexible(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: bills.length,
                        itemBuilder: (context, index) {
                          final item = bills[index];
                          return ExpansionTile(
                            title: Text(
                              item.partyName.isEmpty ? 'Bill ${index + 1}' : item.partyName,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            subtitle: Text('Total: ₹${item.total.toStringAsFixed(0)}'),
                            children: [
                              _modalRow('Weft Name / Qty', item.weftName),
                              _modalRow('Set No.', item.setNo),
                              _modalRow('Rate', item.rate.toStringAsFixed(2)),
                              _modalRow('Total Consumption', item.totalConsumption.toStringAsFixed(2)),
                              _modalRow('Per Cut', item.perCut.toStringAsFixed(2)),
                              _modalRow('Pagar', item.pagar.toStringAsFixed(2)),
                              _modalRow('Total Dori', item.totalDori.toStringAsFixed(2)),
                              _modalRow('Zyada Bacha', item.zyadaBacha.toStringAsFixed(2)),
                              _modalRow('Dori', item.dori.toStringAsFixed(2)),
                              _modalRow('Total Cut', item.totalCut.toStringAsFixed(2)),
                              _modalRow('Grand Total', item.total.toStringAsFixed(0), bold: true),
                              const Divider(),
                              _modalRow('Market Credit', item.marketCredit.toStringAsFixed(2)),
                              _modalRow('Credit Party', item.creditParty),
                              _modalRow('Bale No', item.baleNo),
                              _modalRow('Total Takha', item.totalTakha.toStringAsFixed(2)),
                              _modalRow('Total Meter', item.totalMtr.toStringAsFixed(2)),
                              _modalRow('Credit Total', item.creditFinalAmount.toStringAsFixed(0)),
                              _modalRow('Debit Total', item.debitFinalAmount.toStringAsFixed(0)),
                              _modalRow('Net Final Amount', item.finalAmount.toStringAsFixed(2), bold: true),
                              const SizedBox(height: 8),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
      ),
    ),
  );
}

Widget _modalRow(String label, String value, {bool bold = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF64748B), fontSize: 13)),
        Text(
          value,
          style: TextStyle(
            fontSize: bold ? 16 : 13,
            fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
            color: const Color(0xFF1E293B),
          ),
        ),
      ],
    ),
  );
}
