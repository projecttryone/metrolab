import 'package:flutter/material.dart';

const Color yellow = Color.fromARGB(255, 10, 84, 59);
const Color mediumYellow = Color.fromARGB(255, 16, 50, 14);
const Color darkYellow = Color.fromARGB(255, 138, 128, 111);
const Color transparentYellow = Color.fromRGBO(252, 252, 252, 0.702);
const Color darkGrey = Color(0xff202020);

// const LinearGradient mainButton = LinearGradient(colors: [
//   Color.fromRGBO(186, 128, 108, 1),
//   Color.fromRGBO(151, 117, 106, 1),
//   Color.fromRGBO(93, 72, 62, 1),
// ], begin: FractionalOffset.topCenter, end: FractionalOffset.bottomCenter);

const LinearGradient mainButton = LinearGradient(
  colors: [
    Color.fromARGB(255, 133, 129, 114), // Light gold
    Color.fromARGB(255, 76, 72, 58), // Gold
    Color.fromARGB(255, 23, 71, 19), // Rich amber
  ],
  begin: FractionalOffset.topCenter,
  end: FractionalOffset.bottomCenter,
);



const List<BoxShadow> shadow = [
  BoxShadow(color: Colors.black12, offset: Offset(0, 3), blurRadius: 6)
];

screenAwareSize(int size, BuildContext context) {
  double baseHeight = 640.0;
  return size * MediaQuery.of(context).size.height / baseHeight;
}