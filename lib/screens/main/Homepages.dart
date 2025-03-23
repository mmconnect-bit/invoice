import 'package:admin/controllers/home-widget-controller.dart';

import 'package:admin/constants/responsive.dart';
import 'package:admin/screens/Customer/customer.dart';
import 'package:admin/screens/add-invoice/add-new-invoice.dart';
import 'package:admin/screens/invoice/Invoices.dart';
import 'package:admin/screens/dashboard/DashbordScreeen.dart';
import 'package:admin/screens/setting/setting.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../../constants/constants.dart';
import '../dashboard/components/header.dart';
import '../product/product.dart';

class HomepageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GetBuilder<HomeControllerWidget>(
          builder: (controller) => SingleChildScrollView(
                primary: false,
                padding: EdgeInsets.all(defaultPadding),
                child: Column(
                  children: [
                 Header(),
                    SizedBox(height: defaultPadding),
                    if (controller.tabNo == 1)
                      HomeWidget(
                        widget: Dashbordscreeen(),
                      ),
                    if (controller.tabNo == 2)
                      HomeWidget(
                        widget: AddInvoicePage(),
                      ),
                    if (controller.tabNo == 5)
                      HomeWidget(
                        widget: Customers(),
                      ),
                    if (controller.tabNo == 3)
                      HomeWidget(
                        widget: Products(),
                      ),
                    if (controller.tabNo == 4)
                      HomeWidget(
                        widget: Invoices(),
                      ),
                    if (controller.tabNo == 6)
                      HomeWidget(
                        widget: Card(
                            child:
                                Container(
          margin: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3), // shadow color
                spreadRadius: 4, // how far the shadow spreads
                blurRadius: 20, // blur softness
                offset: Offset(0, 0), // equal shadow on all sides
              ),
            ],
          ),width: 800, child: SettingsScreen())),
                      ),
                  ],
                ),
              )),
    );
  }
}

class HomeWidget extends StatelessWidget {
  final widget;
  HomeWidget({super.key, required this.widget});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 5,
          child: Column(
            children: [
              SizedBox(height: defaultPadding),
              widget,
              if (Responsive.isMobile(context))
                SizedBox(height: defaultPadding),
            ],
          ),
        ),
        if (!Responsive.isMobile(context)) SizedBox(width: defaultPadding),
      ],
    );
  }
}
