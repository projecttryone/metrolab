import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/screens/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  PageController controller = PageController();
  int pageIndex = 0;

  @override
  void initState() {
    super.initState();
    // Background behind the status bar / notch.
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
    ));
  }

  void _onNext() {
    if (pageIndex < 2) {
      controller.nextPage(
        duration: const Duration(milliseconds: 260),
        curve: Curves.easeOut,
      );
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => MainPage()),
      );
    }
  }

  void _onSkip() {
    controller.animateToPage(
      2,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOut,
    );
  }

  Widget _buildDots() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (i) {
        final bool active = pageIndex == i;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          margin: const EdgeInsets.symmetric(horizontal: 5),
          height: 6,
          width: active ? 18 : 6,
          decoration: BoxDecoration(
            color: active
                ? const Color(0xFF2BB673)
                : const Color(0xFFE6E6E6),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }

  Widget _buildBottomCard({
    required String title,
    required String body,
  }) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 16 + bottomInset,
      ),
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(36),
          topRight: Radius.circular(36),
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.12),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            body,
            textAlign: TextAlign.left,
            style: const TextStyle(
              color: Color(0xFF404040),
              fontSize: 16.0,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 24),

          // Skip | dots | Next
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _onSkip,
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF8C8C8C),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              _buildDots(),
              GestureDetector(
                onTap: _onNext,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    pageIndex == 2 ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF2BB673),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          // Bottom logo inside the card (like "by METROLABS")
          Center(
            child: Image.asset(
              'assets/logobottom.png',
              height: 26,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPage({
    required String imageAsset,
    required String title,
    required String body,
  }) {
    final topInset = MediaQuery.of(context).padding.top;

    return Stack(
      children: [
        // FULLSCREEN BACKGROUND IMAGE
        Positioned.fill(
          child: Image.asset(
            imageAsset,
            fit: BoxFit.cover,
          ),
        ),

        // CONTENT ON TOP OF IMAGE
        Positioned.fill(
          child: Column(
            children: [
              SizedBox(height: topInset + 12),
              // Top logo + title + subtitle
              Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Image.asset(
                    //   'assets/MHN-ICON.png',
                    //   height: 42,
                    // ),
                    const SizedBox(height: 6),
                    const Text(
                      'my health now',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1F6B47),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Tap. Test. Track. - Your health, digitized.',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7C7C7C),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Bottom card (with insets so it doesn’t overlap Android nav bar)
              _buildBottomCard(title: title, body: body),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Optional background gradient behind images (will be mostly covered)
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFFF6F9F6),
                    Color(0xFFE7F2E9),
                  ],
                ),
              ),
            ),
          ),

          // MAIN PAGES
          Positioned.fill(
            child: PageView(
              controller: controller,
              onPageChanged: (value) {
                setState(() => pageIndex = value);
              },
              children: [
                _buildPage(
                  imageAsset: 'assets/main1.png',
                  title: 'Verified Labs, Trusted Results',
                  body:
                      'All our labs are certified and results are reviewed by top diagnostic professionals for accuracy and safety.',
                ),
                _buildPage(
                  imageAsset: 'assets/main2.png',
                  title: 'Health at home',
                  body:
                      'Get tests done without stepping out. Book any test and our expert technician will visit your home to collect samples.',
                ),
                _buildPage(
                  imageAsset: 'assets/main3.png',
                  title: 'Your Reports, digitized',
                  body:
                      'Instant access to your medical reports digitally. No more waiting—track, download, and share with your doctor on the go.',
                ),
              ],
            ),
          ),

          // TOP-RIGHT "Skip to Login" PILL (adjusted for status bar height)
          Positioned(
            top: MediaQuery.of(context).padding.top + 8,
            right: 12,
            child: Material(
              color: Colors.white,
              elevation: 3,
              borderRadius: BorderRadius.circular(999),
              child: InkWell(
                borderRadius: BorderRadius.circular(999),
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => MainPage(),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  child: Text(
                    'Skip to Login',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
