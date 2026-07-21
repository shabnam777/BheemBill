import 'package:billing_app/models/bill_item.dart';
import 'package:billing_app/screens/bill_details.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'models/bill.dart';
import 'screens/bill_screen.dart';

void main() {
  runApp(const BillingApp());
}

class BillingApp extends StatelessWidget {
  const BillingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => Bill(),
      child: MaterialApp(
        title: 'Billing App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          textTheme: GoogleFonts.interTextTheme(),
          fontFamily: GoogleFonts.inter().fontFamily,
        ),
        home: const BillScreen(),
        routes: {
          '/bill_details': (context) {
            final billItem = ModalRoute.of(context)?.settings.arguments as BillItem;
            return BillDetailPage(billItem: billItem);
          },
        },
      ),
    );
  }
}
