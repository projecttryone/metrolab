// import 'package:ecommerce_int2/app_properties.dart';
// import 'package:ecommerce_int2/screens/auth/welcome_back_page.dart';
// import 'package:ecommerce_int2/screens/auth/forgot_password_page.dart';
// import 'package:ecommerce_int2/screens/intro_page.dart';

// import 'package:flutter/material.dart';
// import 'cache_storage.dart' ;
// import 'package:video_player/video_player.dart';

// class SplashScreen extends StatefulWidget {
  
//   @override
//   _SplashScreenState createState() => _SplashScreenState();

// }

// class _SplashScreenState extends State<SplashScreen>
//     with SingleTickerProviderStateMixin {
//   late Animation<double> opacity;
//   late AnimationController controller;

//   @override
//   void initState() {

//     super.initState();
//     controller = AnimationController(
//         duration: Duration(milliseconds: 2500), vsync: this);
//         opacity = Tween<double>(begin: 1.0, end: 0.0).animate(controller)
//       ..addListener(() {
//         setState(() {});
//       });
//     controller.forward().then((_) {
//       navigationPage();
//     });
//   }

  

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   // void navigationPage() {
//   //   Navigator.of(context)
//   //       .pushReplacement(MaterialPageRoute(builder: (_) => ForgotPasswordPage()));
//   // }
//     void navigationPage() async {
//             //  await CacheStorage.logout();

//     bool isLoggedIn = await CacheStorage.isLoggedIn();
//     print('Is user logged in? $isLoggedIn');

//     if (isLoggedIn) {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => IntroPage()),
//       );
//     } else {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (_) => ForgotPasswordPage()),
//       );
//     }
//   }


//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//           image: DecorationImage(
//               image: AssetImage('assets/bck.png'), fit: BoxFit.cover)),
//       child: Container(
//         decoration: BoxDecoration(color: const Color.fromARGB(252, 255, 255, 255)),
//         child: SafeArea(
//           child: new Scaffold(
//             body: Column(
//               children: <Widget>[
//                 Expanded(
//                   child: Opacity(
//                       opacity: opacity.value,
//                       child: new Image.asset('assets/logo.jpeg')),
//                 ),
//                 Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: RichText(
//                     text: TextSpan(
//                         style: TextStyle(color: Colors.black),
//                         children: [
//                           TextSpan(text: 'Powered by '),
//                           TextSpan(
//                               text: 'Axis Software Solutions',
//                               style: TextStyle(fontWeight: FontWeight.bold))
//                         ]),
//                   ),
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/screens/auth/welcome_back_page.dart';
import 'package:ecommerce_int2/screens/auth/forgot_password_page.dart';
import 'package:ecommerce_int2/screens/intro_page.dart';

import 'package:flutter/material.dart';
import 'cache_storage.dart';
import 'package:video_player/video_player.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late Animation<double> opacity;
  late AnimationController controller;

  VideoPlayerController? _videoCtrl;   // <-- nullable
  bool _didNavigate = false;

  @override
  void initState() {
    super.initState();

    // Fade animation (unchanged)
    controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    opacity = Tween<double>(begin: 1.0, end: 0.0).animate(controller)
      ..addListener(() {
        if (mounted) setState(() {});
      });
    controller.forward(); // navigation happens on video end

    // Initialize video after first frame so the platform channel is ready (iOS-safe)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctrl = VideoPlayerController.asset('assets/logo.mp4');
      _videoCtrl = ctrl; // assign first, then initialize
      ctrl.initialize().then((_) {
        if (!mounted) return;
        setState(() {});                 // show first frame
        ctrl.setLooping(false);          // play once
        ctrl.play();

        // Navigate when the video finishes (with tiny buffer)
        ctrl.addListener(() {
          final v = ctrl.value;
          if (v.isInitialized &&
              !v.isPlaying &&
              v.position >= v.duration - const Duration(milliseconds: 200) &&
              !_didNavigate) {
            _didNavigate = true;
            ctrl.pause();
            navigationPage();
          }
        });
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    _videoCtrl?.dispose(); // <-- only if created
    super.dispose();
  }

  void navigationPage() async {
    final isLoggedIn = await CacheStorage.isLoggedIn();
    if (!mounted) return;

    if (isLoggedIn) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => IntroPage()),
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ForgotPasswordPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isVideoReady = _videoCtrl?.value.isInitialized ?? false;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/bck.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          color: Color.fromARGB(252, 255, 255, 255),
        ),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Column(
              children: <Widget>[
               Expanded(
  child: (_videoCtrl?.value.isInitialized ?? false)
      ? AspectRatio(
          aspectRatio: _videoCtrl!.value.aspectRatio,
          child: VideoPlayer(_videoCtrl!),
        )
      : const Center(child: CircularProgressIndicator()),
),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: const TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(text: 'Powered by '),
                        TextSpan(
                          text: 'Axis Software Solutions',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
