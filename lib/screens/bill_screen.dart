import 'package:billing_app/models/bill_item.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BillScreen extends StatefulWidget {
  const BillScreen({super.key});

  @override
  State<BillScreen> createState() => _BillScreenState();
}

class _BillScreenState extends State<BillScreen> {
  final PageController _pageController = PageController();
  int _currentStep = 0;
  final int _totalSteps = 3;
  final List<GlobalKey<FormState>> _formKeys = List.generate(2, (_) => GlobalKey<FormState>());

  // Start aur End date ek saath select karne ke liye (Date RANGE)
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  final partyNameController = TextEditingController(); // ab isi me Weft Name + Party Name dono aayenge
  final weftNameController = TextEditingController();
  final setNoController = TextEditingController();
  final warpRateController = TextEditingController();
  final rateController = TextEditingController();
  final rateGSTController = TextEditingController();
  final kgController = TextEditingController();
  final totalConsumptionController = TextEditingController();
  final perCutController = TextEditingController();
  final pagarController = TextEditingController();
  final totalDoriController = TextEditingController();
  final zyadaBachaController = TextEditingController();
  final finalAmountController = TextEditingController();
  final doriController = TextEditingController();
  final totalCutController = TextEditingController();
  final totalController = TextEditingController();
  final warpTotalController = TextEditingController();
  final billDateController = TextEditingController(); // "start - end" range dikhayega

  Color _lessZyadaColor = const Color(0xFF1E293B);

  double gstAmount(double rate, double kg) => rate / 105 * 100 / 5 * kg;

  double totalAmount(double rate, double totalConsumption) => rate * totalConsumption;

  // double warpAmount(double totalConsumption, ) => warpRate() * totalConsumption / 5 / 105 * 100;

  double warpRate(double rate) => rate / 105 * 100 / 5 + 19;

  double perCutAmount(double total, double totalCut) => total / totalCut;

  String formatAmount(double value) => value.toStringAsFixed(0);

  @override
  void dispose() {
    _pageController.dispose();
    partyNameController.dispose();
    weftNameController.dispose();
    setNoController.dispose();
    rateController.dispose();
    rateGSTController.dispose();
    totalConsumptionController.dispose();
    perCutController.dispose();
    pagarController.dispose();
    totalDoriController.dispose();
    zyadaBachaController.dispose();
    finalAmountController.dispose();
    doriController.dispose();
    totalCutController.dispose();
    totalController.dispose();
    kgController.dispose();
    billDateController.dispose();
    super.dispose();
  }

  void clear() {
    partyNameController.clear();
    weftNameController.clear();
    setNoController.clear();
    rateController.clear();
    totalConsumptionController.clear();
    perCutController.clear();
    pagarController.clear();
    totalDoriController.clear();
    zyadaBachaController.clear();
    finalAmountController.clear();
    doriController.clear();
    totalCutController.clear();
    totalController.clear();
    rateGSTController.clear();
    kgController.clear();
  }

  void fillFrom(BillItem item) {
    partyNameController.text = item.partyName;
    weftNameController.text = item.weftName;
    setNoController.text = item.setNo;
    rateController.text = item.rate.toString();
    totalConsumptionController.text = item.totalConsumption.toString();
    perCutController.text = item.perCut.toString();
    pagarController.text = item.pagar.toString();
    totalDoriController.text = item.totalDori.toString();
    zyadaBachaController.text = item.zyadaBacha.toString();
    finalAmountController.text = item.finalAmount.toString();
    doriController.text = item.dori.toString();
    totalCutController.text = item.totalCut.toString();
    totalController.text = item.total.toString();
    kgController.text = item.kg.toString();
    billDateController.text = _formatRange(item.startDate, item.endDate);

    rateGSTController.text = gstAmount(item.rate, item.kg).toStringAsFixed(2);
  }

  BillItem toBillItem() => BillItem(
        partyName: partyNameController.text,
        weftName: weftNameController.text,
        setNo: setNoController.text,
        rate: double.tryParse(rateController.text) ?? 0,
        totalConsumption: double.tryParse(totalConsumptionController.text) ?? 0,
        perCut: double.tryParse(perCutController.text) ?? 0,
        pagar: double.tryParse(pagarController.text) ?? 0,
        totalDori: double.tryParse(totalDoriController.text) ?? 0,
        zyadaBacha: double.tryParse(zyadaBachaController.text) ?? 0,
        finalAmount: double.tryParse(finalAmountController.text) ?? 0,
        dori: double.tryParse(doriController.text) ?? 0,
        totalCut: double.tryParse(totalCutController.text) ?? 0,
        startDate: _startDate,
        endDate: _endDate,
        kg: double.tryParse(kgController.text) ?? 0,
        rateGST: gstAmount(double.tryParse(rateController.text) ?? 0, double.tryParse(kgController.text) ?? 0),
        total: totalAmount(
          double.tryParse(rateGSTController.text) ?? 0,
          double.tryParse(totalConsumptionController.text) ?? 0,
        ),
      );

  String _formatRange(DateTime start, DateTime end) {
    final df = DateFormat('dd/MM/yyyy');
    if (start.year == end.year && start.month == end.month && start.day == end.day) {
      return df.format(start);
    }
    return '${df.format(start)}  -  ${df.format(end)}';
  }

  // Start + End date ek saath select karne wala Range Picker
  Future<void> _pickDateRange() async {
    final pickedRange = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.indigo,
              onPrimary: Colors.white,
              onSurface: Color(0xFF1E293B),
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedRange != null) {
      setState(() {
        _startDate = pickedRange.start;
        _endDate = pickedRange.end;
        billDateController.text = _formatRange(_startDate, _endDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    billDateController.text = _formatRange(_startDate, _endDate);
    rateController.addListener(_updateGST);
    warpRateController.addListener(updateWarpTotal);
    totalCutController.addListener(updateWarpTotal);
    kgController.addListener(_updateGST);
  }

  void _updateGST() {
    final rate = double.tryParse(rateController.text) ?? 0;
    final kg = double.tryParse(kgController.text) ?? 0;
    rateGSTController.text = gstAmount(rate, kg).toStringAsFixed(0);
    totalController.text = totalAmount(rate, double.tryParse(totalConsumptionController.text) ?? 0).toStringAsFixed(0);
  }

  void updateWarpTotal() {
    final warpRateValue = double.tryParse(warpRateController.text) ?? 0;
    final totalConsumption = double.tryParse(totalConsumptionController.text) ?? 0;
    warpTotalController.text = (warpRate(warpRateValue) * totalConsumption).toStringAsFixed(0);

    perCutController.text = perCutAmount(
      double.tryParse(warpTotalController.text) ?? 0,
      double.tryParse(totalCutController.text) ?? 1, // Avoid division by zero
    ).toStringAsFixed(0);
  }

  void _goNext() {
    final isValid = _formKeys[_currentStep].currentState!.validate();
    if (!isValid) return;

    if (_currentStep < _totalSteps - 1) {
      setState(() => _currentStep++);
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      // Step 2 validated -> bill ready hai, seedha preview pe bhejo
      final billItem = toBillItem();
      Navigator.pushNamed(context, '/preview_screen', arguments: billItem);
    }
  }

  // Ab Back button hamesha dikhega:
  // - Step 2+ pe: pichhle step pe le jaata hai
  // - Step 1 pe: form hi band kar deta hai (screen se bahar/pop)
  void _goBack() {
    if (_currentStep > 0) {
      setState(() => _currentStep--);
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
    } else {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // final isLastStep = _currentStep == _totalSteps - 1;
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7FA),
      body: SafeArea(
        child: Column(
          children: [
            // ---------- Form name + step counter (top) ----------
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF1E3A8A), Color(0xFF1D4ED8)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Weekly Outstanding Bill',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  // Text(
                  //   'Step ${_currentStep + 1}/$_totalSteps',
                  //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.grey[600]),
                  // ),
                ],
              ),
            ),
            // ---------- Progress bar ----------

            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildStep1(),
                ],
              ),
            ),
            // ---------- Back / Next buttons (Back hamesha visible) ----------
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _goBack,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        side: const BorderSide(color: Colors.indigo),
                      ),
                      child: const Text('Save', style: TextStyle(color: Colors.indigo)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: PremiumButton(
                      onPressed: _goNext,
                      label: 'Preview & Generate PDF',
                      icon: Icons.picture_as_pdf,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------- STEP 1: Bill Period + Party details ----------------
  Widget _buildStep1() {
    return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKeys[0],
          child: Column(
            children: [
              // Start Date - End Date ek saath yahan se select hoga
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFD1D5DB)),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E293B).withOpacity(0.06),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: const Icon(Icons.date_range, color: Color(0xFF1D4ED8)),
                  title: const Text(
                    'Bill Period',
                    style: TextStyle(fontSize: 12, color: Color(0xFF64748B), fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    _formatRange(_startDate, _endDate),
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                  ),
                  trailing: const Icon(Icons.calendar_month, color: Color(0xFF1D4ED8)),
                  onTap: _pickDateRange,
                ),
              ),
              const SizedBox(height: 8),
              PremiumTextField(
                controller: setNoController,
                validator: (v) => (v == null || v.isEmpty) ? 'Market Debit required' : null,
                label: 'Market Debit',
              ),
              const SizedBox(height: 8),

              // ---- Ek row me: Weft+Party Name (bada) + KG (chota) + Rate (chota) ----
              TwoFieldRow(
                left: PremiumTextField(
                  controller: partyNameController,
                  validator: (v) => (v == null || v.isEmpty) ? 'Name required' : null,
                  label: 'Weft Name + Party Name',
                ),
                right: PremiumTextField(
                  controller: kgController,
                  keyboardType: TextInputType.number,
                  validator: (v) => (v == null || v.isEmpty) ? 'KG required' : null,
                  label: 'KG',
                ),
              ),

              TwoFieldRow(
                left: PremiumTextField(
                  controller: rateController,
                  keyboardType: TextInputType.number,
                  validator: (v) => (v == null || v.isEmpty) ? 'Rate required' : null,
                  label: 'Rate',
                ),
                right: PremiumTextField(
                  controller: rateGSTController,
                  keyboardType: TextInputType.none,
                  label: 'Total',
                ),
              ),
              const PremiumDivider(),

              TwoFieldRow(
                left: PremiumTextField(
                  controller: weftNameController,
                  validator: (v) => (v == null || v.isEmpty) ? 'Name required' : null,
                  label: 'Warp Name + Party Name',
                ),
                right: PremiumTextField(
                  controller: totalConsumptionController,
                  keyboardType: TextInputType.number,
                  validator: (v) => (v == null || v.isEmpty) ? 'Consumption required' : null,
                  label: 'Consumption',
                ),
              ),

              TwoFieldRow(
                left: PremiumTextField(
                  controller: warpRateController,
                  keyboardType: TextInputType.number,
                  validator: (v) => (v == null || v.isEmpty) ? 'Rate required' : null,
                  label: 'Rate',
                ),
                right: PremiumTextField(
                  controller: totalCutController,
                  keyboardType: TextInputType.number,
                  validator: (v) => (v == null || v.isEmpty) ? 'Rate required' : null,
                  label: 'Total Cut',
                ),
              ),

              TwoFieldRow(
                left: PremiumTextField(
                  controller: perCutController,
                  keyboardType: TextInputType.none,
                  label: 'Per Cut',
                ),
                right: PremiumTextField(
                  controller: warpTotalController,
                  keyboardType: TextInputType.none,
                  label: 'Total',
                ),
              ),

              const PremiumDivider(),

              TwoFieldRow(
                left: PremiumTextField(
                  controller: totalDoriController,
                  validator: (v) => (v == null || v.isEmpty) ? 'Dori required' : null,
                  label: 'Total Dori',
                ),
                right: PremiumTextField(
                  controller: finalAmountController,
                  keyboardType: TextInputType.number,
                  validator: (v) => (v == null || v.isEmpty) ? 'Total required' : null,
                  label: 'Total',
                ),
              ),
              const SizedBox(height: 4),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                  child: PremiumTextField(
                    controller: zyadaBachaController,
                    keyboardType: TextInputType.none,
                    textColor: _lessZyadaColor,
                    onChanged: (val) {
                      final parsed = double.tryParse(val.trim());
                      setState(() {
                        _lessZyadaColor = parsed == null ? const Color(0xFF1E293B) : (parsed < 0 ? Colors.redAccent : Colors.green.shade700);
                      });
                    },
                    validator: (v) => (v == null || v.isEmpty) ? 'Consumption required' : null,
                    label: 'Less / Excess',
                  ),
                ),
              ]),
            ],
          ),
        ));
  }

  // ---------------- STEP 2: GST + future fields ----------------
  Widget _buildStep2() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKeys[1],
        child: const Column(
          children: [
            SizedBox(height: 24),
            // PremiumTextField(
            //   controller: totalCutController,
            //   keyboardType: TextInputType.none,
            //   label: 'Total Cut',
            // ),
            // const SizedBox(height: 24),
            // PremiumTextField(
            //   controller: totalConsumptionController,
            //   keyboardType: TextInputType.number,
            //   validator: (v) => (v == null || v.isEmpty) ? 'Total consumption required' : null,
            //   label: 'Total Consumption',
            // ),
            // const SizedBox(height: 24),
            // PremiumTextField(
            //   controller: totalController,
            //   keyboardType: TextInputType.none,
            //   validator: (v) => (v == null || v.isEmpty) ? 'Total required' : null,
            //   label: 'Total Amount',
            // ),
            // const SizedBox(height: 24),
            // PremiumTextField(
            //   controller: perCutController,
            //   keyboardType: TextInputType.none,
            //   label: 'Per Cut',
            // ),
            // const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

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
    this.spacing = 10,
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
    this.radius = 10,
    this.margin = const EdgeInsets.symmetric(vertical: 12),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin!,
      child: Divider(
        color: color ?? Colors.green.shade400,
        thickness: thickness,
        radius: BorderRadius.circular(radius),
      ),
    );
  }
}
