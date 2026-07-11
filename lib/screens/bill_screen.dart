import 'package:billing_app/models/bill_item.dart';
import 'package:billing_app/models/constants.dart';
import 'package:billing_app/widgets/widgets.dart';
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
  double bales = 0;
  double finalAmount = 0;
  final int _totalSteps = 3;
  final List<GlobalKey<FormState>> _formKeys = List.generate(2, (_) => GlobalKey<FormState>());

  // Start aur End date ek saath select karne ke liye (Date RANGE)
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();

  final partyNameController = TextEditingController(); // ab isi me Weft Name + Party Name dono aayenge
  final weftNameController = TextEditingController();
  final marketDebtControler = TextEditingController();
  final warpRateController = TextEditingController();
  final rateController = TextEditingController();
  final weftTotalController = TextEditingController();
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
  final otherExpenseController = TextEditingController(); // "Other Expense" field added
  final billDateController = TextEditingController();
  final creditAmount = TextEditingController();

  final marketCredit = TextEditingController();

  // "start - end" range dikhayega

  // step 2

  final creditDate = TextEditingController();
  final creditParty = TextEditingController();
  final baleNo = TextEditingController();

  final totalTakha = TextEditingController();
  final totalMtr = TextEditingController();
  final creditRate = TextEditingController();
  final creditFinalAmount = TextEditingController();
  final debitFinalAmount = TextEditingController();
  final mtrAvg = TextEditingController();

  Color _lessZyadaColor = const Color(0xFF1E293B);

  double gstAmount(double rate, double kg) => rate / gst5 * kg;

  double totalAmount(double rate, double totalConsumption) => rate * totalConsumption;

  // double warpAmount(double totalConsumption, ) => warpRate() * totalConsumption / gst5;

  double warpRate(double rate) => rate / gst5 + sizingCharge;

  double perCutAmount(double total, double totalCut) => total / totalCut;

  String formatAmount(double value) => value.toStringAsFixed(0);

  @override
  void dispose() {
    _pageController.dispose();
    partyNameController.dispose();
    weftNameController.dispose();
    marketDebtControler.dispose();
    rateController.dispose();
    weftTotalController.dispose();
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
    marketDebtControler.clear();
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
    weftTotalController.clear();
    kgController.clear();
  }

  void _calculateDifference() {
    final text = baleNo.text.trim().toLowerCase();
    // Matches patterns like "65 to 75", "65-75", "65 - 75"
    final regex = RegExp(r'(\d+(\.\d+)?)\s*(?:to|-)\s*(\d+(\.\d+)?)');
    final match = regex.firstMatch(text);

    if (match != null) {
      final from = double.tryParse(match.group(1)!) ?? 0;
      final to = double.tryParse(match.group(3)!) ?? 0;
      setState(() {
        bales = to - from; // 75 - 65 = 10
      });
    } else {
      setState(() {
        bales = 0.0; // invalid format
      });
    }

    totalTakha.text = (bales * takhaInOneBl).toStringAsFixed(0);
  }

  void mtrAverage() {
    var takha = double.tryParse(totalTakha.text);
    var totalMeter = double.tryParse(totalMtr.text);
    mtrAvg.text = (totalMeter! / takha!).toStringAsFixed(0);
  }

  void fillFrom(BillItem item) {
    partyNameController.text = item.partyName;
    weftNameController.text = item.weftName;
    marketDebtControler.text = item.setNo;
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

    weftTotalController.text = gstAmount(item.rate, item.kg).toStringAsFixed(2);
  }

  BillItem toBillItem() => BillItem(
        partyName: partyNameController.text,
        weftName: weftNameController.text,
        setNo: marketDebtControler.text,
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
          double.tryParse(weftTotalController.text) ?? 0,
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
    totalDoriController.addListener(lessZyadaAmount);
    pagarController.addListener(lessZyadaAmount);
    baleNo.addListener(_calculateDifference);
    totalMtr.addListener(mtrAverage);
  }

  void _updateGST() {
    final rate = double.tryParse(rateController.text) ?? 0;
    final kg = double.tryParse(kgController.text) ?? 0;
    weftTotalController.text = gstAmount(rate, kg).toStringAsFixed(0);
    totalController.text = totalAmount(rate, double.tryParse(totalConsumptionController.text) ?? 0).toStringAsFixed(0);
  }

  void setFinalAmounts() {
    final debt = double.tryParse(marketDebtControler.text) ?? 0;
    final expense = double.tryParse(otherExpenseController.text) ?? 0;
    final weftTotal = double.tryParse(weftTotalController.text) ?? 0;
    final warpTotal = double.tryParse(warpTotalController.text) ?? 0;
    final pagar = double.tryParse(pagarController.text) ?? 0;

    final creditFinal = double.tryParse(creditAmount.text) ?? 0;
    final credit = double.tryParse(marketCredit.text) ?? 0;
    debitFinalAmount.text = (debt + expense + weftTotal + warpTotal + pagar).toStringAsFixed(0);
    creditFinalAmount.text = (creditFinal + credit).toStringAsFixed(0);
    finalAmount = (double.tryParse(creditFinalAmount.text) ?? 0) - (double.tryParse(debitFinalAmount.text) ?? 0);
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

  void lessZyadaAmount() {
    final totalDori = double.tryParse(totalDoriController.text) ?? 0;
    final pagarAmount = double.tryParse(pagarController.text) ?? 0;
    zyadaBachaController.text = (totalDori * pagar - pagarAmount).toStringAsFixed(0);
    setState(() {
      _lessZyadaColor = double.tryParse(zyadaBachaController.text)! < 0 ? Colors.red : Colors.green;
    });
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
    final isLastStep = _currentStep == _totalSteps - 1;
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Weekly Outstanding Bill',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                  Text(
                    'Step ${_currentStep + 1}/$_totalSteps',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                  ),
                ],
              ),
            ),
            // ---------- Progress bar ----------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: List.generate(_totalSteps, (index) {
                  final isActive = index <= _currentStep;
                  return Expanded(
                    child: Container(
                      margin: EdgeInsets.only(right: index == _totalSteps - 1 ? 0 : 6),
                      height: 6,
                      decoration: BoxDecoration(
                        color: isActive ? Colors.indigo : Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                children: [_buildStep1(), _buildStep2()],
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
                      child: const Text('Prev', style: TextStyle(color: Colors.indigo)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 3,
                    child: PremiumButton(
                      onPressed: _goNext,
                      label: isLastStep ? 'Preview & Generate PDF' : 'Next',
                      icon: isLastStep ? Icons.picture_as_pdf : Icons.arrow_forward,
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
                  dense: true,
                  visualDensity: const VisualDensity(horizontal: 0, vertical: -4), // negative = zyada compact
                  contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 0),

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
              TwoFieldRow(
                left: PremiumTextField(
                  controller: marketDebtControler,
                  label: 'Market Debit',
                ),
                right: PremiumTextField(
                  controller: otherExpenseController,
                  keyboardType: TextInputType.number,
                  label: 'Other Expense',
                ),
              ),
              const SizedBox(height: 8),

              // ---- Ek row me: Weft+Party Name (bada) + KG (chota) + Rate (chota) ----
              TwoFieldRow(
                left: PremiumTextField(
                  controller: partyNameController,
                  label: 'Weft Name + Party Name',
                ),
                right: PremiumTextField(
                  controller: kgController,
                  keyboardType: TextInputType.number,
                  label: 'KG',
                ),
              ),

              TwoFieldRow(
                left: PremiumTextField(
                  controller: rateController,
                  keyboardType: TextInputType.number,
                  label: 'Rate',
                ),
                right: PremiumTextField(
                  controller: weftTotalController,
                  keyboardType: TextInputType.none,
                  label: 'Total',
                ),
              ),
              const PremiumDivider(),

              TwoFieldRow(
                left: PremiumTextField(
                  controller: weftNameController,
                  label: 'Warp Name + Party Name',
                ),
                right: PremiumTextField(
                  controller: totalConsumptionController,
                  keyboardType: TextInputType.number,
                  label: 'Consumption',
                ),
              ),

              TwoFieldRow(
                left: PremiumTextField(
                  controller: warpRateController,
                  keyboardType: TextInputType.number,
                  label: 'Rate',
                ),
                right: PremiumTextField(
                  controller: totalCutController,
                  keyboardType: TextInputType.number,
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
                  label: 'Total Dori',
                ),
                right: PremiumTextField(
                  controller: pagarController,
                  keyboardType: TextInputType.number,
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
        child: Column(
          children: [
            const SizedBox(height: 8),
            PremiumTextField(
              controller: marketCredit,
              keyboardType: TextInputType.number,
              label: 'Market Credit',
            ),
            TwoFieldRow(
                left: PremiumTextField(
                  controller: creditDate,
                  keyboardType: TextInputType.text,
                  label: 'Date',
                ),
                right: PremiumTextField(
                  controller: creditParty,
                  keyboardType: TextInputType.text,
                  label: 'Party',
                )),
            TwoFieldRow(
                left: PremiumTextField(
                  controller: baleNo,
                  keyboardType: TextInputType.number,
                  label: 'Bale No',
                ),
                right: PremiumTextField(
                  controller: totalTakha,
                  keyboardType: TextInputType.number,
                  label: 'Total Takha',
                )),
            TwoFieldRow(
                left: PremiumTextField(
                  controller: totalMtr,
                  keyboardType: TextInputType.text,
                  label: 'Total Meter',
                ),
                right: PremiumTextField(
                  controller: creditRate,
                  keyboardType: TextInputType.text,
                  label: 'Rate',
                )),
            TwoFieldRow(
                left: PremiumTextField(
                  controller: creditAmount,
                  keyboardType: TextInputType.text,
                  label: 'Final Amount',
                ),
                right: PremiumTextField(
                  controller: mtrAvg,
                  keyboardType: TextInputType.text,
                  label: 'Meter Avg',
                )),
            const PremiumDivider(),
            TwoFieldRow(
                left: PremiumTextField(
                  textColor: Colors.green.shade700,
                  controller: creditFinalAmount,
                  keyboardType: TextInputType.number,
                  label: 'Credit',
                ),
                right: PremiumTextField(
                  textColor: Colors.red.shade700,
                  controller: debitFinalAmount,
                  keyboardType: TextInputType.number,
                  label: 'Debit',
                )),
            PremiumAmountTile(finalAmount)
          ],
        ),
      ),
    );
  }
}
