import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';

import 'package:flutter/material.dart';

const primaryColor = Color(0x00013051);
const secondaryColor = Color(0xFF2A2D3E);
const bgColor = Color(0xFF212332);
const pdfColors = PdfColor.fromInt(0x00013051);

const defaultPadding = 16.0;

class CustomTheme {
  static ThemeData lightTheme = ThemeData(
    fontFamily: 'SatoshiVariable',
    primaryColor: const Color.fromARGB(255, 20, 23, 58),
    primaryColorLight: const Color.fromARGB(255, 21, 40, 69),
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      titleTextStyle: TextStyle(
          color: const Color.fromARGB(255, 21, 40, 69),
          fontSize: 20,
          fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: const Color.fromARGB(255, 21, 40, 69)),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(
      TextTheme(
        headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 21, 40, 69)),
        bodyMedium: TextStyle(
            fontSize: 18,
            color: const Color.fromARGB(255, 21, 40, 69),
            fontWeight: FontWeight.w400),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 21, 40, 69),
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
  );

  // 🌙 Dark Theme
  static ThemeData darkTheme = ThemeData(
    fontFamily: 'SatoshiVariable',
    brightness: Brightness.dark,
    primaryColor: const Color.fromARGB(47, 0, 0, 0),
    primaryColorLight: const Color.fromARGB(225, 255, 255, 255),
    scaffoldBackgroundColor: const Color.fromARGB(255, 22, 21, 21),
    appBarTheme: AppBarTheme(
      backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      titleTextStyle: TextStyle(
          color: const Color.fromARGB(255, 43, 42, 42),
          fontSize: 20,
          fontWeight: FontWeight.bold),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    textTheme: GoogleFonts.poppinsTextTheme(TextTheme(
      headlineMedium: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
    )),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 0, 0, 0), // Button color
        foregroundColor: Colors.white, // Text color
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
  );
}

class AppConstants {
  AppConstants._();
  static final AppConstants instance = AppConstants._();

  static const Color primaryColor = Color(0xFF1F368D);
  static const Color secondaryColor = Color.fromARGB(255, 50, 129, 121);
  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color accentColor = Color(0xFFFFE240);

  double screenHeightMain(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height -
        mediaQuery.padding.top -
        mediaQuery.padding.bottom;
  }

  double screenHeight(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.size.height;
  }

  double screenWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  String formatNumber(double number) {
    // final formatter = NumberFormat("#,###.##");
    // return formatter.format(number);
    return "";
  }

  Widget customText(String message, double size, FontWeight fontWeight,
      int maxLines, Color color,
      [TextAlign? textAlign, String? fontFamily]) {
    return Text(
      textAlign: textAlign,
      message,
      textScaler: TextScaler.linear(1.2),
      style: TextStyle(
          fontWeight: fontWeight,
          fontSize: size,
          color: color,
          fontFamily: fontFamily),
      maxLines: maxLines,
    );
  }

  Widget bottomNavigation(selectedIndex, onItemTapped) {
    return BottomNavigationBar(
      selectedItemColor: Color.fromARGB(255, 245, 241, 42),
      unselectedItemColor: Colors.white,
      backgroundColor: AppConstants.primaryColor,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
          ),
          label: 'Welcome',
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.settings,
          ),
          label: 'Setting',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onItemTapped,
    );
  }

  Widget buttons(bool isActive, String message, GestureTapCallback onPressed,
      bool isCancel, BuildContext context) {
    AppConstants constants = AppConstants.instance;
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: constants.screenWidth(context) * .4,
        height: constants.screenHeight(context) * .09,
        decoration: BoxDecoration(
          color: isActive
              ? AppConstants.primaryColor
              : isCancel
                  ? Colors.red
                  : Colors.grey,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: isActive
                ? AppConstants.primaryColor
                : isCancel
                    ? Colors.red
                    : const Color.fromARGB(255, 255, 242, 242),
            width: 2,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          message,
          textScaler: TextScaler.linear(1.2),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void showRepaymentSchedule(BuildContext context, double loanPrincipal,
      int loanTerm, double loanInterest) {
    List<Map<String, dynamic>> generateSchedule() {
      List<Map<String, dynamic>> schedule = [];
      DateTime startDate = DateTime.now();
      double remainingBalance = loanPrincipal;
      double monthlyRate = (loanInterest / 100) / (loanTerm / 30);

      int intervalDays = loanTerm <= 30
          ? loanTerm
          : loanTerm == 90
              ? 7 // Weekly
              : 30; // Monthly

      int numberOfPayments = loanTerm <= 30
          ? 1
          : loanTerm == 90
              ? 12 // 12 weeks for 3 months
              : (loanTerm / 30).round(); // Monthly for 6+ months

      for (int i = 0; i < numberOfPayments; i++) {
        double interest = remainingBalance * monthlyRate;
        double principal =
            loanTerm > 30 ? (loanPrincipal / numberOfPayments) : loanPrincipal;
        double installmentAmount =
            loanTerm >= 90 ? (principal + interest) : loanPrincipal;

        DateTime dueDate =
            startDate.add(Duration(days: intervalDays * (i + 1)));
        remainingBalance -= principal;
        schedule.add({
          // "dueDate": DateFormat('yyyy-MM-dd').format(dueDate),
          "amount": installmentAmount,
          "outstanding": remainingBalance,
        });
      }
      return schedule;
    }

    List<Map<String, dynamic>> schedule = generateSchedule();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              customText("repayment", 18, FontWeight.w600, 1, Colors.black,
                  null, "SatoshiLight"),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  itemCount: schedule.length,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: EdgeInsets.symmetric(vertical: 6),
                      child: ListTile(
                        title: customText(
                            "${schedule[index]['dueDate']}",
                            16,
                            FontWeight.bold,
                            1,
                            Colors.black,
                            null,
                            "SatoshiLight"),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            customText(
                                "Pay: ${formatNumber(schedule[index]['amount'])}",
                                13,
                                FontWeight.bold,
                                1,
                                primaryColor,
                                null,
                                "SatoshiLight"),
                            customText(
                                "Rem: ${formatNumber(schedule[index]['outstanding'])}",
                                13,
                                FontWeight.bold,
                                1,
                                Colors.red,
                                null,
                                "SatoshiLight"),
                          ],
                        ),
                        leading: customText('${index + 1}', 14, FontWeight.bold,
                            1, Colors.black54),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    minimumSize: Size(double.infinity, 50),
                  ),
                  child:
                      customText("close", 16, FontWeight.bold, 1, Colors.white))
            ],
          ),
        );
      },
    );
  }
}
