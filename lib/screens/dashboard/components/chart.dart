import 'package:admin/models/Invoice.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:admin/models/product_list.dart';

class PieCharts extends StatelessWidget {
  final List<Invoice> invoices;

  PieCharts({required this.invoices});

  // Helper to parse "dd-mm-yyyy" to DateTime
  DateTime? parseDate(String dateStr) {
    try {
      return DateFormat('dd-MM-yyyy').parse(dateStr);
    } catch (e) {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the current month and year
    final DateTime now = DateTime.now();
    final int currentMonth = now.month;
    final int currentYear = now.year;

    // Filter invoices for current month and year
    final List<Invoice> filteredInvoices = invoices.where((invoice) {
      final invoiceDate =
          parseDate(invoice.date); // assume `invoice.date` is a String
      return invoiceDate != null &&
          invoiceDate.month == currentMonth &&
          invoiceDate.year == currentYear;
    }).toList();

    // Flatten products
    List<Product> allProducts =
        filteredInvoices.expand((invoice) => invoice.product).toList();

    // Calculate product sales
    final Map<String, double> productSales = {};
    for (var product in allProducts) {
      final name = product.name;
      final price = double.tryParse(product.price) ?? 0.0;
      productSales[name] = (productSales[name] ?? 0.0) + price;
    }

    final top5 = productSales.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topProducts = top5.take(5).toList();
    final total =
        topProducts.fold<double>(0.0, (sum, item) => sum + item.value);

    // Pie chart colors
    final List<Color> colors = [
      Colors.green,
      Colors.blue,
      Colors.orange,
      Colors.purple,
      Colors.red,
    ];

    return Container(
      width: 1200,
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
      child: Padding(
        padding: EdgeInsets.only(left: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Text(
              'Top Products - ${DateFormat('MMMM yyyy').format(now)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  height: 300,
                  width: 300,
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 0,
                      sections: List.generate(topProducts.length, (i) {
                        final product = topProducts[i];
                        final percent = total > 0
                            ? ((product.value / total) * 100).toStringAsFixed(1)
                            : '0.0';
                        return PieChartSectionData(
                          color: colors[i % colors.length],
                          value: product.value,
                          title: '$percent%',
                          radius: 200,
                          titleStyle: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                SizedBox(
                  width: 200,
                ),
                Column(
                  spacing: 16,
                  // runSpacing: 8,
                  // alignment: WrapAlignment.center,
                  children: List.generate(topProducts.length, (i) {
                    final product = topProducts[i];
                    return LegendItem(
                      color: colors[i % colors.length],
                      label1: '${product.key}',
                      label2:
                          '${(product.value / 1000000).toStringAsFixed(3)}M TZS',
                    );
                  }),
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class LegendItem extends StatelessWidget {
  final Color color;
  final String label1;
  final String label2;

  const LegendItem(
      {required this.color, required this.label1, required this.label2});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color,
      width: 200,
      child: ListTile(
        title: Text(
          label1,
          style: TextStyle(color: Colors.white),
        ),
        subtitle: Text(
          label2,
          style: TextStyle(color: Colors.white),
        ),
        tileColor: color,
        focusColor: color,
      ),
    );
  }
}
