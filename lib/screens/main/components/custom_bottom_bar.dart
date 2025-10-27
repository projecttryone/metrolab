// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

// class CustomBottomBar extends StatelessWidget {
//   final TabController controller;

//   const CustomBottomBar({
//     required this.controller,
//   });
//   @override
//   Widget build(BuildContext context) {
//     return BottomAppBar(
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: <Widget>[
//           IconButton(
//             icon: SvgPicture.asset(
//               'assets/icons/home_icon.svg',
//               fit: BoxFit.fitWidth,
//             ),
//             onPressed: () {
//               controller.animateTo(0);
//             },
//           ),
//           IconButton(
//             icon: Image.asset('assets/icons/category_icon.png'),
//             onPressed: () {
//               controller.animateTo(1);
//             },
//           ),
//           IconButton(
//             icon: SvgPicture.asset('assets/icons/cart_icon.svg'),
//             onPressed: () {
//               controller.animateTo(2);
//             },
//           ),
//           IconButton(
//             icon: Image.asset('assets/icons/profile_icon.png'),
//             onPressed: () {
//               controller.animateTo(3);
//             },
//           )
//         ],
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class CustomBottomBar extends StatefulWidget {
  final TabController controller;
  const CustomBottomBar({required this.controller});

  @override
  _CustomBottomBarState createState() => _CustomBottomBarState();
}

class _CustomBottomBarState extends State<CustomBottomBar> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: _currentIndex,
      height: 65,
      color: Colors.white,
      buttonBackgroundColor: Colors.green.shade700,
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOut,
      animationDuration: const Duration(milliseconds: 400),
      items: const <Widget>[
        Icon(Icons.home_rounded, size: 30, color: Colors.black87),
        Icon(Icons.category_rounded, size: 30, color: Colors.black87),
         Icon(Icons.call, size: 30, color: Colors.black87),
        Icon(Icons.shopping_cart_rounded, size: 30, color: Colors.black87),
                        Icon(Icons.document_scanner, size: 30, color: Colors.black87),

        Icon(Icons.person_rounded, size: 30, color: Colors.black87),

      ],
      onTap: (index) {
        setState(() => _currentIndex = index);
        widget.controller.animateTo(index);
      },
      letIndexChange: (index) => true,
    );
  }
}
