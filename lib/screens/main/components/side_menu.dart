import 'package:admin/controllers/home-widget-controller.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';

import 'package:get/get.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeControllerWidget>(
      builder: (controller) => Container(
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
        ),
        child: Material(
          elevation: 16,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 10,
              ),
              DrawerHeader(
                child: Container(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 150,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              DrawerListTile(
                isTaped: controller.tabNo == 1,
                color: controller.tabNo == 1
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                title: "Dashboard",
                svgSrc: "assets/icons/menu_dashboard.svg",
                press: () => controller.onTab(1),
              ),
              SizedBox(
                height: 10,
              ),
              DrawerListTile(
                isTaped: controller.tabNo == 3,
                color: controller.tabNo == 3
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                title: "Products",
                svgSrc: "assets/icons/menu_store.svg",
                press: () => controller.onTab(3),
              ),
              SizedBox(
                height: 10,
              ),
              DrawerListTile(
                isTaped: controller.tabNo == 5,
                color: controller.tabNo == 5
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                title: "Customer",
                svgSrc: "assets/icons/menu_profile.svg",
                press: () => controller.onTab(5),
              ),
              SizedBox(
                height: 10,
              ),
              DrawerListTile(
                isTaped: controller.tabNo == 2,
                color: controller.tabNo == 2
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                title: "Create Invoice",
                svgSrc: "assets/icons/menu_tran.svg",
                press: () => controller.onTab(2),
              ),
              SizedBox(
                height: 10,
              ),
              DrawerListTile(
                isTaped: controller.tabNo == 4,
                color: controller.tabNo == 4
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                title: "Invoice",
                svgSrc: "assets/icons/menu_doc.svg",
                press: () => controller.onTab(4),
              ),
              SizedBox(
                height: 10,
              ),
              DrawerListTile(
                isTaped: controller.tabNo == 6,
                color: controller.tabNo == 6
                    ? Theme.of(context).primaryColor
                    : Colors.white,
                title: "Settings",
                svgSrc: "assets/icons/menu_setting.svg",
                press: () => controller.onTab(6),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerListTile extends StatelessWidget {
  DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.color,
    required this.isTaped,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  final String title, svgSrc;
  final VoidCallback press;
  final bool isTaped;
  Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: color,
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        colorFilter: ColorFilter.mode(
            isTaped ? Colors.white : Theme.of(context).primaryColor,
            BlendMode.srcIn),
        height: 16,
      ),
      title: Text(
        title,
        style: TextStyle(
            color: isTaped ? Colors.white : Theme.of(context).primaryColor),
      ),
    );
  }
}
