import 'package:admin/constants/constants.dart';
import 'package:admin/screens/dashboard/components/dashoardComponents.dart';
import 'package:flutter/material.dart';

class Dashbordscreeen extends StatefulWidget {
  const Dashbordscreeen({super.key});

  @override
  State<Dashbordscreeen> createState() => _DashbordscreeenState();
}

class _DashbordscreeenState extends State<Dashbordscreeen> {
  AppConstants constants = AppConstants.instance;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // MyFiles(),

        SizedBox(
          width: constants.screenWidth(context) * 0.6,
          height: constants.screenHeight(context) * 1.8,
          child: InvoiceCards(),
        ),
      ],
    );
  }
}
