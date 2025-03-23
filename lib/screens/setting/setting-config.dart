class AppSettings {
  // Singleton instance
  static final AppSettings _instance = AppSettings._internal();
  factory AppSettings() => _instance;
  AppSettings._internal();

  // ===============================
  // 💰 Currency & Money Formatting
  // ===============================
  String currency = "TZS";
  String moneyFormat = "M"; // Options: "M", "K", "RAW"
  int decimalPlaces = 2;

  // ===============================
  // 📅 Date Format
  // ===============================
  String dateFormat = "dd-MM-yyyy";

  // ===============================
  // 🧾 Company Information
  // ===============================
  String companyName = "Your Company Ltd.";
  String companyAddress = "1234 Main Street, Dar es Salaam";
  String companyPhone = "+255 712 345 678";
  String companyEmail = "info@company.com";
  String logoPath = "assets/images/logo.png"; // Used on invoices

  // ===============================
  // 📄 Invoice Configuration
  // ===============================
  int invoiceStartNumber = 1000;
  bool showCompanyLogoOnInvoice = true;

  // ===============================
  // 🌐 Localization & UI
  // ===============================
  String defaultLanguage = "en";
  bool enableDarkMode = false;

  // ===============================
  // 🔢 Helper Methods
  // ===============================

  String formatMoney(double amount) {
    switch (moneyFormat) {
      case "M":
        return "$currency ${(amount / 1000000).toStringAsFixed(decimalPlaces)}M";
      case "K":
        return "$currency ${(amount / 1000).toStringAsFixed(decimalPlaces)}K";
      default:
        return "$currency ${amount.toStringAsFixed(decimalPlaces)}";
    }
  }
}
