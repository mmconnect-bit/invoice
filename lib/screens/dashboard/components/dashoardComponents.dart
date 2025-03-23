import 'package:admin/models/Invoice.dart';
import 'package:admin/repository/invoice-controller.dart';
import 'package:admin/screens/dashboard/components/best-customer.dart';
import 'package:admin/screens/dashboard/components/chart.dart';

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/instance_manager.dart';
import 'package:intl/intl.dart';

class InvoiceCards extends StatelessWidget {
  final InvoiceController invoiceController = Get.put(InvoiceController());

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: FutureBuilder<List<Invoice>>(
          future: invoiceController.fetchInvoices(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text("Error: ${snapshot.error}"));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No invoices found"));
            } else {
              final invoices = snapshot.data!;
              final monthlyAvg = SalesCalculator.getMonthlyAverage(invoices);
              final weeklyAvg = SalesCalculator.getWeeklyAverage(invoices);

              return Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _buildStatBox(
                          title: "Monthly Average Income",
                          value: "TZS ${formatMoney(monthlyAvg)}",
                          icon: Icons.calendar_month,
                          color: Colors.blueAccent,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: _buildStatBox(
                          title: "Weekly Average Income",
                          value: "TZS ${formatMoney(weeklyAvg)}",
                          icon: Icons.calendar_view_week,
                          color: Colors.orangeAccent,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  PieCharts(
                    invoices: invoices,
                  ),
                  SizedBox(height: 10),
                  TopMonthlyCustomersWidget(
                    invoices: invoices,
                  ),
                  Container(
                      margin: EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(0.3), // shadow color
                            spreadRadius: 4, // how far the shadow spreads
                            blurRadius: 20, // blur softness
                            offset: Offset(0, 0), // equal shadow on all sides
                          ),
                        ],
                      ),
                      width: 1200,
                      height: 50,
                      child: Center(
                          child: Text(
                        " Total Sales Chart",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ))),
                  Expanded(
                    child: MonthlySalesChart(invoices: invoices),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  /// ✅ Format all values in Millions (M) only
  String formatMoney(double amount) {
    return '${(amount / 1000000).toStringAsFixed(2)}M';
  }

  Widget _buildStatBox({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
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
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color, width: 1.5),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color,
              child: Icon(icon, color: Colors.white),
            ),
            SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style:
                        TextStyle(fontWeight: FontWeight.bold, color: color)),
                SizedBox(height: 4),
                Text(value,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: color)),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class MonthlySalesChart extends StatelessWidget {
  final List<Invoice> invoices;

  MonthlySalesChart({required this.invoices});

  final List<String> monthLabels = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec'
  ];

  Map<int, double> calculateMonthlySales(List<Invoice> invoices) {
    Map<int, double> monthlySales = {
      for (int i = 1; i <= 12; i++) i: 0.0,
    };

    for (var invoice in invoices) {
      try {
        final date = DateFormat("dd-MM-yyyy").parse(invoice.date);
        double total = invoice.product.fold(
          0.0,
          (sum, p) => sum + (double.tryParse(p.price) ?? 0),
        );
        monthlySales[date.month] = monthlySales[date.month]! + total;
      } catch (e) {
        print("Date parsing error: ${invoice.date}");
      }
    }

    return monthlySales;
  }

  @override
  Widget build(BuildContext context) {
    final monthlySales = calculateMonthlySales(invoices);
    final double maxY = (monthlySales.values.isNotEmpty)
        ? monthlySales.values.reduce((a, b) => a > b ? a : b) + 200000
        : 1000000;

    return Container(
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
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 11,
              minY: 0,
              maxY: maxY,
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 40,
                    getTitlesWidget: (value, _) {
                      return Text('${(value / 1000000).toStringAsFixed(1)}M',
                          style: TextStyle(fontSize: 10));
                    },
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 1,
                    getTitlesWidget: (value, _) {
                      int index = value.toInt();
                      if (index < 0 || index >= monthLabels.length)
                        return Text('');
                      return Text(monthLabels[index],
                          style: TextStyle(fontSize: 10));
                    },
                  ),
                ),
                topTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
                rightTitles:
                    AxisTitles(sideTitles: SideTitles(showTitles: false)),
              ),
              borderData: FlBorderData(show: true),
              gridData: FlGridData(show: true),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    12,
                    (i) => FlSpot(i.toDouble(), monthlySales[i + 1]!),
                  ),
                  isCurved: true,
                  color: Colors.deepPurple,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ------------------------------
// Average Calculator
// ------------------------------

class SalesCalculator {
  static double getMonthlyAverage(List<Invoice> invoices) {
    if (invoices.isEmpty) return 0.0;

    Map<int, double> monthlyTotals = {};

    for (var invoice in invoices) {
      try {
        final date = DateFormat("dd-MM-yyyy").parse(invoice.date);
        final month = date.month;
        final total = invoice.product.fold(
          0.0,
          (sum, p) => sum + (double.tryParse(p.price) ?? 0.0),
        );
        monthlyTotals[month] = (monthlyTotals[month] ?? 0.0) + total;
      } catch (_) {}
    }

    return monthlyTotals.isEmpty
        ? 0.0
        : monthlyTotals.values.reduce((a, b) => a + b) / monthlyTotals.length;
  }

  static double getWeeklyAverage(List<Invoice> invoices) {
    if (invoices.isEmpty) return 0.0;

    Map<int, double> weeklyTotals = {};

    for (var invoice in invoices) {
      try {
        final date = DateFormat("dd-MM-yyyy").parse(invoice.date);
        final week = getWeekNumber(date);
        final total = invoice.product.fold(
          0.0,
          (sum, p) => sum + (double.tryParse(p.price) ?? 0.0),
        );
        weeklyTotals[week] = (weeklyTotals[week] ?? 0.0) + total;
      } catch (_) {}
    }

    return weeklyTotals.isEmpty
        ? 0.0
        : weeklyTotals.values.reduce((a, b) => a + b) / weeklyTotals.length;
  }

  static int getWeekNumber(DateTime date) {
    final firstDay = DateTime(date.year, 1, 1);
    final days = date.difference(firstDay).inDays;
    return ((days + firstDay.weekday) / 7).ceil();
  }
}
