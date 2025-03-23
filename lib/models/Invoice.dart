import 'package:admin/models/customer.dart';
import 'package:admin/models/product_list.dart';

class Invoice {
  int? id;
  final String invoiceNo;
  final Customer customer;
  final List<Product> product;
  final String date;

  Invoice({
    this.id,
    required this.invoiceNo,
    required this.customer,
    required this.product,
    required this.date,
  });
}
