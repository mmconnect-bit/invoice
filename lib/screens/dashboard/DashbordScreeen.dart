import 'package:admin/screens/dashboard/components/dashoardComponents.dart';
import 'package:flutter/material.dart';

class Dashbordscreeen extends StatefulWidget {
  const Dashbordscreeen({super.key});

  @override
  State<Dashbordscreeen> createState() => _DashbordscreeenState();
}

class _DashbordscreeenState extends State<Dashbordscreeen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // MyFiles(),

        SizedBox(
          width: 1200,
          height: 2200,
          child: InvoiceCards(),
        ),
      ],
    );
  }
}
