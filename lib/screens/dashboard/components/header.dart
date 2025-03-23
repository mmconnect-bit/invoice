import 'package:admin/controllers/menu_app_controller.dart';
import 'package:admin/constants/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../../../constants/constants.dart';

class Header extends StatelessWidget {
  const Header({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
    );
  }
}

class GlowingText extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow Effect
          Text(
            "AMOS INVESTMENT CO.LTD",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              foreground: Paint()
                ..style = PaintingStyle.stroke
                ..strokeWidth = 3
                ..color = Colors.blueAccent.withOpacity(0.6),
            ),
          ),
          // Main Text with Shadow
          Text(
            "AMOS INVESTMENT CO.LTD",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [
                Shadow(
                  color: Colors.blueAccent.withOpacity(0.8),
                  blurRadius: 10,
                  offset: Offset(2, 2),
                ),
                Shadow(
                  color: Colors.blueAccent.withOpacity(0.5),
                  blurRadius: 20,
                  offset: Offset(-2, -2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// class ProfileCard extends StatelessWidget {
//   const ProfileCard({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(left: defaultPadding),
//       padding: EdgeInsets.symmetric(
//         horizontal: defaultPadding,
//         vertical: defaultPadding / 2,
//       ),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: const BorderRadius.all(Radius.circular(10)),
//         border: Border.all(color: Colors.white10),
//       ),
//       child: Row(
//         children: [
//           Image.asset(
//             "assets/images/profile_pic.png",
//             height: 38,
//           ),
//           if (!Responsive.isMobile(context))
//             Padding(
//               padding:
//                   const EdgeInsets.symmetric(horizontal: defaultPadding / 2),
//               child: Text("Angelina Jolie"),
//             ),
//           Icon(Icons.keyboard_arrow_down),
//         ],
//       ),
//     );
//   }
// }

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      child: TextField(
        decoration: InputDecoration(
          hintText: "Search",
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2), // Primary color border
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2), // Border when not focused
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 3), // Thicker border when focused
            borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          suffixIcon: InkWell(
            onTap: () {},
            child: Container(
              padding: EdgeInsets.all(defaultPadding * 0.75),
              margin: EdgeInsets.symmetric(horizontal: defaultPadding / 2),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: SvgPicture.asset("assets/icons/Search.svg"),
            ),
          ),
        ),
      ),
    );
  }
}
