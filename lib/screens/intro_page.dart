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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // ---- FULL BACKGROUND ----
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color.fromARGB(255, 167, 221, 186), Color.fromARGB(255,  167, 221, 186)],
              ),
            ),
          ),

          // ---- MAIN CONTENT ----
          SafeArea(
            child: Stack(
              children: <Widget>[
                // PAGES
                PageView(
                  onPageChanged: (value) {
                    setState(() => pageIndex = value);
                  },
                  controller: controller,
                  children: <Widget>[
                    // --- PAGE 1 ---
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 12),
                        Center(
                          child: Image.asset('assets/slider3.png',
                              height: 200, width: 200),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 16 + MediaQuery.of(context).padding.bottom,
                            left: 16,
                            right: 16,
                          ),
                          child: Container(
                            padding:
                                const EdgeInsets.fromLTRB(20, 18, 20, 18),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Verified Labs, Trusted Results',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'All our labs are certified and results are reviewed by top diagnostic professionals for accuracy and safety.',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xFF404040),
                                    fontSize: 16.0,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                // Dots inside the card
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(3, (i) {
                                    final bool active = pageIndex == i;
                                    return AnimatedContainer(
                                      duration: const Duration(
                                          milliseconds: 220),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      height: 6,
                                      width: active ? 16 : 6,
                                      decoration: BoxDecoration(
                                        color: active
                                            ? const Color(0xFF2BB673)
                                            : const Color(0xFFE6E6E6),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // --- PAGE 2 ---
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        const SizedBox(height: 12),
                        Center(
                          child: Image.asset('assets/slider1.png',
                              height: 200, width: 200),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 16 + MediaQuery.of(context).padding.bottom,
                            left: 16,
                            right: 16,
                          ),
                          child: Container(
                            padding:
                                const EdgeInsets.fromLTRB(20, 18, 20, 18),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Health at home',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Get tests done without stepping out. Book any test and our expert technician will visit your home to collect samples.',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xFF404040),
                                    fontSize: 16.0,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(3, (i) {
                                    final bool active = pageIndex == i;
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 220),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      height: 6,
                                      width: active ? 16 : 6,
                                      decoration: BoxDecoration(
                                        color: active
                                            ? const Color(0xFF2BB673)
                                            : const Color(0xFFE6E6E6),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),

                    // --- PAGE 3 ---
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        const SizedBox(height: 12),
                        Center(
                          child: Image.asset('assets/slider2.png',
                              height: 200, width: 200),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            bottom: 16 + MediaQuery.of(context).padding.bottom,
                            left: 16,
                            right: 16,
                          ),
                          child: Container(
                            padding:
                                const EdgeInsets.fromLTRB(20, 18, 20, 18),
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
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Your Reports, digitized',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 20),
                                ),
                                const SizedBox(height: 10),
                                const Text(
                                  'Instant access to your medical reports digitally. No more waiting—track, download, and share with your doctor on the go.',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    color: Color(0xFF404040),
                                    fontSize: 16.0,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(3, (i) {
                                    final bool active = pageIndex == i;
                                    return AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 220),
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 5),
                                      height: 6,
                                      width: active ? 16 : 6,
                                      decoration: BoxDecoration(
                                        color: active
                                            ? const Color(0xFF2BB673)
                                            : const Color(0xFFE6E6E6),
                                        borderRadius:
                                            BorderRadius.circular(999),
                                      ),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // ---- TOP RIGHT "Skip to Login" PILL ----
                Positioned(
                  top: 12,
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
                              builder: (context) => MainPage()),
                        );
                      },
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 14, vertical: 10),
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
          ),
        ],
      ),
    );
  }
}
