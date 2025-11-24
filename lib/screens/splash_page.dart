
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
  final ready = _videoCtrl?.value.isInitialized ?? false;

  return Scaffold(
    backgroundColor: Colors.black,
    // no SafeArea here – we want true edge-to-edge
    body: Stack(
      fit: StackFit.expand, // fill the screen
      children: [
        // Background image (optional)
        Image.asset('assets/bck.png', fit: BoxFit.cover),

        // Video full-bleed
        if (ready)
          Positioned.fill(
            child: Transform.scale(
              scale: 1.01, // nudge to hide any 1px gap due to rounding
              child: FittedBox(
                fit: BoxFit.cover, // fill; will crop a bit
                child: SizedBox(
                  width: _videoCtrl!.value.size.width,
                  height: _videoCtrl!.value.size.height,
                  child: VideoPlayer(_videoCtrl!),
                ),
              ),
            ),
          )
        else
          const Center(child: CircularProgressIndicator()),

        // Footer label
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: RichText(
              text: const TextSpan(
                style: TextStyle(color: Colors.white),
                children: [
                  TextSpan(text: 'Powered by '),
                  TextSpan(text: 'Axis Software Solutions',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

    }