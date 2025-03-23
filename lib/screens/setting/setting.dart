import 'package:admin/screens/setting/setting-config.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final settings = AppSettings();

  // Controllers
  late TextEditingController companyNameController;
  late TextEditingController companyAddressController;
  late TextEditingController companyPhoneController;
  late TextEditingController companyEmailController;
  late TextEditingController dateFormatController;
  late TextEditingController currencyController;
  late TextEditingController invoiceStartController;

  String selectedMoneyFormat = "M";

  @override
  void initState() {
    super.initState();
    companyNameController = TextEditingController(text: settings.companyName);
    companyAddressController =
        TextEditingController(text: settings.companyAddress);
    companyPhoneController = TextEditingController(text: settings.companyPhone);
    companyEmailController = TextEditingController(text: settings.companyEmail);
    dateFormatController = TextEditingController(text: settings.dateFormat);
    currencyController = TextEditingController(text: settings.currency);
    invoiceStartController =
        TextEditingController(text: settings.invoiceStartNumber.toString());
    selectedMoneyFormat = settings.moneyFormat;
  }

  void saveSettings() {
    setState(() {
      settings.companyName = companyNameController.text;
      settings.companyAddress = companyAddressController.text;
      settings.companyPhone = companyPhoneController.text;
      settings.companyEmail = companyEmailController.text;
      settings.dateFormat = dateFormatController.text;
      settings.currency = currencyController.text;
      settings.invoiceStartNumber =
          int.tryParse(invoiceStartController.text) ?? 1000;
      settings.moneyFormat = selectedMoneyFormat;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Settings updated!")),
    );
  }

  Widget buildTextField(String label, TextEditingController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Center(
          child: Card(
            child: SizedBox(
              width: double.infinity, // or fixed if you want like 400
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  labelText: label,
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text("🧾 Invoice", style: Theme.of(context).textTheme.titleLarge),
          Text("Select Invoice Templetes",
              style: Theme.of(context).textTheme.titleLarge),
          DualImageSelector(),
          SizedBox(height: 20),
          // Text("💰 Financial Settings",
          //     style: Theme.of(context).textTheme.titleLarge),
          // buildTextField("Currency (e.g., TZS)", currencyController),
          // DropdownButtonFormField<String>(
          //   value: selectedMoneyFormat,
          //   decoration: InputDecoration(
          //     labelText: "Money Format",
          //     border: OutlineInputBorder(),
          //   ),
          //   items: ["M", "K", "RAW"].map((format) {
          //     return DropdownMenuItem(
          //       value: format,
          //       child: Text(format == "M"
          //           ? "Millions (M)"
          //           : format == "K"
          //               ? "Thousands (K)"
          //               : "Raw Amount"),
          //     );
          //   }).toList(),
          //   onChanged: (value) {
          //     if (value != null) {
          //       setState(() {
          //         selectedMoneyFormat = value;
          //       });
          //     }
          //   },
          // ),
          // buildTextField("Invoice Start Number", invoiceStartController),
          // SizedBox(height: 20),
          // Text("⚙️ General Settings",
          //     style: Theme.of(context).textTheme.titleLarge),
          // // buildTextField("Date Format", dateFormatController),
          // SwitchListTile(
          //   title: Text("Show Company Logo on Invoice"),
          //   value: settings.showCompanyLogoOnInvoice,
          //   onChanged: (val) {
          //     setState(() {
          //       settings.showCompanyLogoOnInvoice = val;
          //     });
          //   },
          // ),
          // SwitchListTile(
          //   title: Text("Enable Dark Mode"),
          //   value: settings.enableDarkMode,
          //   onChanged: (val) {
          //     setState(() {
          //       settings.enableDarkMode = val;
          //     });
          //   },
          // ),
          // SizedBox(height: 20),
          // ElevatedButton.icon(
          //   onPressed: saveSettings,
          //   icon: Icon(Icons.save),
          //   label: Text("Save Settings"),
          //   style: ElevatedButton.styleFrom(
          //     minimumSize: Size(double.infinity, 50),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class DualImageSelector extends StatefulWidget {
  @override
  _DualImageSelectorState createState() => _DualImageSelectorState();
}

class _DualImageSelectorState extends State<DualImageSelector> {
  final List<String> images = [
    'assets/images/templete1.png',
    'assets/images/templete2.png',
  ];

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadSelectedIndex();
  }

  Future<void> _loadSelectedIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedIndex = prefs.getInt('selected_template') ?? 0;
    });
  }

  Future<void> _saveSelectedIndex(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('selected_template', index);
  }

  void showImageDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                height: 800,
              ),
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Close"),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(images.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () => showImageDialog(images[index]),
                    child: Container(
                      height: 200,
                      width: 200,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selectedIndex == index
                              ? Colors.blue
                              : Colors.grey,
                          width: 3,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          images[index],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Radio<int>(
                    value: index,
                    groupValue: selectedIndex,
                    onChanged: (value) {
                      setState(() {
                        selectedIndex = value!;
                      });
                      _saveSelectedIndex(value!); // Save selection
                    },
                  ),
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}
