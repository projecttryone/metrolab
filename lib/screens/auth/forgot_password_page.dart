// import 'package:ecommerce_int2/app_properties.dart';
// import 'package:flutter/material.dart';
// import 'confirm_otp_page.dart';

// class ForgotPasswordPage extends StatefulWidget {
//   @override
//   _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
// }

// class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
//   final TextEditingController phoneNumber =
//       TextEditingController(text: '46834683');

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () => FocusScope.of(context).unfocus(),
//       child: Stack(
//         children: [
//           // 1) full‐screen background image
//           Positioned.fill(
//             child: Image.asset('assets/bck.png', fit: BoxFit.cover),
//           ),

//           // 2) yellow overlay
//           Positioned.fill(
//             child: Container(color: transparentYellow),
//           ),

//           // 3) your transparent scaffold with content
//           Scaffold(
//             backgroundColor: Colors.transparent,
//             appBar: AppBar(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//             ),
//             body: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 28.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Spacer(flex: 3),

//                   // Title
//                   Text(
//                     'Welcome',
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontSize: 34.0,
//                       fontWeight: FontWeight.bold,
//                       shadows: [
//                         BoxShadow(
//                           color: Colors.black.withOpacity(0.15),
//                           offset: Offset(0, 5),
//                           blurRadius: 10.0,
//                         ),
//                       ],
//                     ),
//                   ),

//                   Spacer(),
                  
//                   // Subtitle
//                   Padding(
//                     padding: const EdgeInsets.only(right: 56.0),
//                     child: Text(
//                       'Enter your registered or mobile number to get the OTP',
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontSize: 16.0,
//                       ),
//                     ),
//                   ),

//                   Spacer(flex: 2),

//                   // Phone form + Send button
//                   _buildPhoneForm(context),

//                   Spacer(flex: 2),

//                   // Resend text
//                   _buildResendText(),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPhoneForm(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     return SizedBox(
//       height: 210,
//       child: Stack(
//         children: [
//           // white panel
//           Container(
//             height: 100,
//             width: width,
//             padding:
//                 const EdgeInsets.only(left: 32.0, right: 12.0, bottom: 30),
//             decoration: BoxDecoration(
//               color: Colors.white.withOpacity(0.8),
//               borderRadius: BorderRadius.only(
//                 topLeft: Radius.circular(10),
//                 bottomLeft: Radius.circular(10),
//               ),
//             ),
//             child: Align(
//               alignment: Alignment.bottomLeft,
//               child: TextField(
//                 controller: phoneNumber,
//                 keyboardType: TextInputType.phone,
//                 style: TextStyle(fontSize: 16.0),
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   hintText: 'Mobile number',
//                 ),
//               ),
//             ),
//           ),

//           // Send OTP button
//           Positioned(
//             left: width / 4,
//             bottom: 40,
//             child: InkWell(
//               onTap: () {
//                 Navigator.of(context).push(
//                   MaterialPageRoute(builder: (_) => ConfirmOtpPage(phoneNumber: phoneNumber.text.trim(),)),
//                 );
//               },
//               child: Container(
//                 width: width / 2,
//                 height: 80,
//                 alignment: Alignment.center,
//                 decoration: BoxDecoration(
//                   gradient: LinearGradient(
//                     colors: [
//                       Color.fromRGBO(231, 203, 108, 1),
//                       Color.fromRGBO(219, 59, 31, 1),
//                       Color.fromRGBO(226, 183, 41, 1),
//                     ],
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                   ),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.16),
//                       offset: Offset(0, 5),
//                       blurRadius: 10.0,
//                     ),
//                   ],
//                   borderRadius: BorderRadius.circular(9.0),
//                 ),
//                 child: Text(
//                   "Send OTP",
//                   style: TextStyle(
//                     color: const Color.fromARGB(255, 52, 50, 50),
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.w600,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildResendText() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text(
//             "Didn't receive the OTP? ",
//             style: TextStyle(
//               fontStyle: FontStyle.italic,
//               color: Colors.white.withOpacity(0.5),
//               fontSize: 14.0,
//             ),
//           ),
//           GestureDetector(
//             onTap: () {
//               //TODO: implement resend logic
//             },
//             child: Text(
//               'Resend again',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontWeight: FontWeight.bold,
//                 fontSize: 14.0,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:ecommerce_int2/app_properties.dart';
import 'package:flutter/material.dart';
import 'confirm_otp_page.dart';
import 'dart:async';
import '../cache_storage.dart' ;
import 'package:ecommerce_int2/screens/intro_page.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
  
}




class _ForgotPasswordPageState extends State<ForgotPasswordPage> {

   


        Timer? _carouselTimer;

        @override
        void initState() {
          super.initState();
          _startAutoSlide();
        }

        void _startAutoSlide() {
          _carouselTimer = Timer.periodic(Duration(seconds: 2), (timer) {
            if (_pageController.hasClients) {
              int nextPage = (_currentPage + 1) % slides.length;
              _pageController.animateToPage(
                nextPage,
                duration: Duration(milliseconds: 200),
                curve: Curves.easeInOut,
              );
            }
          });
        }

        @override
        void dispose() {
          _carouselTimer?.cancel();
          _pageController.dispose();
          super.dispose();
        }


  final TextEditingController phoneNumber = TextEditingController(text: '9841296586');
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> slides = [
    {
      "image": "assets/slider1.png",
      "text": "Understand your health better with AI-powered reports & actionable advice tailored just for you."
    },
    {
      "image": "assets/slider2.png",
      "text": "Track your progress with personalized insights and daily health tips."
    },
    {
      "image": "assets/slider3.png",
      "text": "Get lab reports explained in simple language by our AI health assistant."
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            // Background
            // Positioned.fill(
            //   child: Image.asset('assets/bgmain.png', fit: BoxFit.cover),
            // ),
            Stack(
              children: [
                // Background image (full screen)
                Positioned.fill(
                  child: Image.asset('assets/bgmain.png', fit: BoxFit.fill),
                ),
                
                // Foreground half image with design
                Positioned.fill(
      top: MediaQuery.of(context).size.height * 0.3, // Start at 50% height
                        left: 0,
                        right: 0,
                  child: Image.asset('assets/bg.png', fit: BoxFit.cover),
                ),
              ],
            ),
            Positioned.fill(child: Container(color: transparentYellow)),

            SafeArea(
              child: Column(
                children: [
                  // Carousel Section
                  _buildCarouselSection(context),

                  // Bottom Sheet Section
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.95),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40),
                        ),
                      ),
                      child: SingleChildScrollView(
                        padding: EdgeInsets.symmetric(horizontal: 28.0, vertical: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Login",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87)),
                            SizedBox(height: 10),
                            _buildPhoneForm(context),
                            SizedBox(height: 20),
                            _buildResendText(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Top Carousel Section
  // Widget _buildCarouselSection(BuildContext context) {
  //   final height = MediaQuery.of(context).size.height * 0.42;
  //   return Container(
  //     height: height,
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: [
  //         Expanded(
  //           child: PageView.builder(
  //             controller: _pageController,
  //             onPageChanged: (index) => setState(() => _currentPage = index),
  //             itemCount: slides.length,
  //             itemBuilder: (_, index) => Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Flexible(
  //                   flex: 3,
  //                   child: Image.asset(slides[index]["image"]!, height: 180),
  //                 ),
  //                 SizedBox(height: 16),
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(horizontal: 24.0),
  //                   child: Text(
  //                     slides[index]["text"]!,
  //                     textAlign: TextAlign.center,
  //                     style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.w500),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //         SizedBox(height: 15),
  //         Row(
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: List.generate(slides.length, (index) {
  //             return AnimatedContainer(
  //               duration: Duration(milliseconds: 300),
  //               margin: EdgeInsets.symmetric(horizontal: 4),
  //               height: 8,
  //               width: _currentPage == index ? 20 : 8,
  //               decoration: BoxDecoration(
  //                 color: _currentPage == index ? Colors.orange : Colors.white54,
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //             );
  //           }),
  //         ),
  //         SizedBox(height: 15),
  //       ],
  //     ),
  //   );
  // }

Widget _buildCarouselSection(BuildContext context) {
  final height = MediaQuery.of(context).size.height * 0.42;
  
return Center(
  child: Container(
    height: height,
    width: MediaQuery.of(context).size.width * 0.8,
    decoration: BoxDecoration(
      image: DecorationImage(
        image: AssetImage('assets/MHN-ICON.png'),
        fit: BoxFit.contain,
      ),
    ),
    
  ),
  
);
}


  /// Phone Number Form
  Widget _buildPhoneForm(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Column(
      children: [
        Container(
          height: 60,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Text("+977", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: phoneNumber,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Enter your number',
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 30),
                SizedBox(height: 30),
        SizedBox(height: 30),
        SizedBox(height: 30),
        SizedBox(height: 30),

        InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ConfirmOtpPage(phoneNumber: phoneNumber.text.trim()),


            ));
          },
       

          child: Container(
            width: width,
            height: 55,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color.fromARGB(255, 159, 192, 50), Color.fromARGB(255, 159, 192, 50), Color.fromARGB(255, 159, 192, 50)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              "Receive OTP",
              style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  /// Footer Text with Wrap to prevent overflow
  Widget _buildResendText() {
        final width = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: 6,
        children: [
         Column(
  children: [
     Row(
      children: [
        // Text("By signing in, you accept our ",
            // style: TextStyle(fontSize: 10, color: Colors.black54)),
        // GestureDetector(
          // child: Text("T&Cs",
              // style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        // ),
        // Text(" and ", style: TextStyle(fontSize: 8, color: Colors.black54)),
        // GestureDetector(
          // child: Text("Privacy Policy",
              // style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
        // ),
      ],
    ),
         SizedBox(height: 30),
        SizedBox(height: 30),

    Image.asset(
      'assets/logobottom.png',
      height: 40, // Adjust size as needed
      width: width/2,
    ),
    SizedBox(height: 8),
   
  ],
)
        ],
      ),
    );
  }
}
