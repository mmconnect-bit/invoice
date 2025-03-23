import 'package:admin/constants/constants.dart';
import 'package:admin/models/Invoice.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TopMonthlyCustomersWidget extends StatelessWidget {
  final List<Invoice> invoices;

  TopMonthlyCustomersWidget({required this.invoices});

  // Parse "dd-MM-yyyy"
  DateTime? parseDate(String dateStr) {
    try {
      return DateFormat('dd-MM-yyyy').parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final DateTime now = DateTime.now();
    final int currentMonth = now.month;
    final int currentYear = now.year;

    // Filter invoices for this month
    final filteredInvoices = invoices.where((invoice) {
      final parsedDate = parseDate(invoice.date);
      return parsedDate != null &&
          parsedDate.month == currentMonth &&
          parsedDate.year == currentYear;
    }).toList();

    // Calculate total spent per customer
    Map<String, double> customerTotals = {};

    for (var invoice in filteredInvoices) {
      final key = '${invoice.customer.name}-${invoice.customer.phone}';
      final total = invoice.product.fold(0.0, (sum, product) {
        return sum + (double.tryParse(product.price) ?? 0.0);
      });

      customerTotals[key] = (customerTotals[key] ?? 0.0) + total;
    }

    // Sort and take top 5
    final topCustomers = customerTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final top5 = topCustomers.take(5).toList();

    return Card(
      margin: EdgeInsets.all(16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top 5 Customers - ${DateFormat('MMMM yyyy').format(now)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Divider(
              color: primaryColor,
            ),
            ...top5.map((entry) {
              final parts = entry.key.split('-');
              final name = parts[0];
              final phone = parts[1];

              return Column(
                children: [
                  ListTile(
                    leading: CircleAvatar(child: Text(name[0])),
                    title: Text(name),
                    subtitle: Text(phone),
                    trailing: Text(
                      NumberFormat.currency(locale: 'en', symbol: 'TZS ')
                          .format(entry.value),
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Divider(
                    color: primaryColor,
                  ),
                ],
              );
            }).toList(),
          ],
        ),
      ),
    );
  }
}
