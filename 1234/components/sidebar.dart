import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Row(
              children: const [
                Icon(Icons.inventory, size: 32),
                SizedBox(width: 10),
                Text('InvoiceX',
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: const [
                ListTile(
                    leading: Icon(Icons.dashboard), title: Text('Dashboard')),
                ListTile(
                    leading: Icon(Icons.admin_panel_settings),
                    title: Text('Administrator')),
                ListTile(
                    leading: Icon(Icons.inventory), title: Text('Products')),
                ListTile(leading: Icon(Icons.people), title: Text('Customers')),
                ListTile(
                    leading: Icon(Icons.receipt), title: Text('Quotations')),
                ListTile(
                    leading: Icon(Icons.attach_money), title: Text('Invoices')),
                ListTile(
                    leading: Icon(Icons.payment), title: Text('Transactions')),
                ListTile(
                    leading: Icon(Icons.settings), title: Text('Settings')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
