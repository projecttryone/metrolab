import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/custom_background.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/category/category_list_page.dart';
import 'package:ecommerce_int2/screens/notifications_page.dart';
import 'package:ecommerce_int2/screens/profile_page.dart';
import 'package:ecommerce_int2/screens/search_page.dart';
import 'package:ecommerce_int2/screens/shop/order_page.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:ecommerce_int2/screens/shop/check_out_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'components/custom_bottom_bar.dart';
import 'components/product_list.dart';
import 'components/tab_view.dart';
import 'components/callpage.dart';

import '../dbmain.dart';
import '../cache_storage.dart' ;
import 'package:sqflite/sqflite.dart';
import '../../db_helper.dart';
import '../OfferCardSection.dart'; // Import the card widget above




class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

List<String> timelines = ['Weekly', 'Best of June', 'Best of 2018'];
String selectedTimeline = 'Best of June';

List<Product> _products=  [
                      Product('assets/test1.png', 'Lipid Profile',
                          'A detailed test measuring cholesterol and triglyceride levels to evaluate heart health.', 55.00,3333,''),
                      Product('assets/test2.png', 'Thyroid Profile (T3, T4, TSH)',
                          'Assesses thyroid gland function and helps diagnose hypo- or hyperthyroidism.', 75.00,3334,''),
                      Product('assets/test3.png', 'Vitamin D Test',
                          'Determines Vitamin D levels in the body to check for deficiencies that may affect bone and immune health.', 50.00,3335,''),
                    ];


class _MainPageState extends State<MainPage> with TickerProviderStateMixin<MainPage> {
  late TabController tabController;
  late TabController bottomTabController;
   Future<void> _makePhoneCall(String number) async {
    final Uri launchUri = Uri.parse("tel:$number");
    if (await canLaunchUrl(launchUri)) {
      await launchUrl(launchUri);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not launch $number")),
      );
    }
  }
  List<Product> _products2 = [];
  bool _isLoading = true;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    bottomTabController = TabController(length: 6, vsync: this);
        _loadProducts();

     }

    Future<void> _loadProducts() async {
    final list = await Dbmain.fetchAllProducts(); // your rawQuery join
    // print(list) ;
    setState(() {
      _products2 = list;
      _isLoading = false;
    });
  }

  @override
Widget build(BuildContext context) {
  final Size size = MediaQuery.of(context).size;

  // ---------- TOP BRAND BAR (logo + menu + icons) ----------
  Widget brandBar = Padding(
    padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
    child: Row(
      children: [
        IconButton(
          icon: const Icon(Icons.menu, color: Colors.black87),
          onPressed: () {},
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/MHN-ICON.png', // full logo (with text if you want)
                height: 26,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 2),
              const Text(
                'Tap. Test. Track. - Your health, digitized.',
                style: TextStyle(
                  fontSize: 10,
                  color: Color(0xFF7C7C7C),
                ),
              ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.notifications_none, color: Colors.black87),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => NotificationsPage()),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.black87),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => ProfilePage()),
            );
          },
        ),
      ],
    ),
  );

  // ---------- SEARCH BAR ----------
  Widget searchBar = Container(
    width: double.infinity,
    height: 46,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
      border: Border.all(color: Colors.green.shade700, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 6,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        Image.asset(
          'assets/vlood_icon.png',
          width: 24,
          height: 24,
        ),
        const SizedBox(width: 10),
        Expanded(
          child: InkWell(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => SearchPage()),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "Search for Test/Package",
                style: TextStyle(color: Colors.grey, fontSize: 15),
              ),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.mic_none, color: Colors.green),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.search, color: Colors.green),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => SearchPage()),
          ),
        ),
      ],
    ),
  );

  // ---------- HERO TEXT (left of big card) ----------
  Widget heroText = Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Your Health is just a Tap Away',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: Color(0xFF1F6B47),
            height: 1.2,
          ),
        ),
        SizedBox(height: 4),
        Text(
          'On a Service 24 hours\nAlways on. Always Ready.',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
            height: 1.2,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'From home sample collection to online reports access and complete laboratory diagnostic solutions.',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFF5D5D5D),
            height: 1.3,
          ),
        ),
      ],
    ),
  );

  // ---------- BIG WHITE CARD: doctor banner + dots + 2 green CTAs ----------
// BIG WHITE CARD: text + doctor image (side by side) + dots + 2 CTAs
Widget heroOfferCard = Padding(
  padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(26),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.08),
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // --- TOP ROW: TEXT (LEFT) + IMAGE (RIGHT) ---
        Padding(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // text
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Your Health is just a Tap Away',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF1F6B47),
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'On a Service 24 hours\nAlways on. Always Ready.',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'From home sample collection to online reports access and complete laboratory diagnostic solutions.',
                      style: TextStyle(
                        fontSize: 10.5,
                        color: Color(0xFF5D5D5D),
                        height: 1.3,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // doctor image
              Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: AspectRatio(
                    aspectRatio: 1, // nice square-ish
                    child: Image.asset(
                      'assets/offer/banner1.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // --- DOTS ---
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFF2BB673),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFD5E5D8),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: 6),
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: const Color(0xFFD5E5D8),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // --- TWO GREEN CTA CARDS ---
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 0, 12, 14),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => tabController.animateTo(1),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/offer/cta-2.png',
                      height: 72,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: GestureDetector(
                  onTap: () => tabController.animateTo(2),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.asset(
                      'assets/offer/cta1.png',
                      height: 72,
                      fit: BoxFit.cover,
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

  // ---------- SECTION HEADER ----------
  Widget sectionHeader(String title, {bool showSeeAll = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          if (showSeeAll)
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(40, 24),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'See all',
                style: TextStyle(
                  fontSize: 12,
                  color: Color(0xFF1F6B47),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ---------- TAB BAR FOR POPULAR LAB TESTS ----------
  Widget tabBar = TabBar(
    tabs: const [
      Tab(text: 'ALL'),
      Tab(text: 'Highest selling'),
      Tab(text: 'Preventive'),
      Tab(text: 'New Tests'),
    ],
    labelStyle: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w600),
    unselectedLabelStyle: const TextStyle(fontSize: 13.0),
    labelColor: darkGrey,
    unselectedLabelColor: const Color.fromRGBO(0, 0, 0, 0.5),
    isScrollable: true,
    controller: tabController,
  );

  return Scaffold(
    bottomNavigationBar: SafeArea(
      top: false,
      child: SizedBox(
        height: 72,
        child: CustomBottomBar(controller: bottomTabController),
      ),
    ),
    body: CustomPaint(
      painter: MainBackground(),
      child: TabBarView(
        controller: bottomTabController,
        physics: const NeverScrollableScrollPhysics(),
        children: <Widget>[
          // ================== HOME TAB ==================
      SafeArea(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      brandBar,
      searchBar,
      heroOfferCard, // text + image now inside here
      sectionHeader('Popular lab tests', showSeeAll: true),
      tabBar,
      Expanded(
        child: TabView(tabController: tabController),
      ),
    ],
  ),
),


          // other bottom tabs unchanged
          CategoryListPage(),
          CallPage(phoneNumber: '+9779860103441'),
          CheckOutPage(),
          OrdersPage(),
          ProfilePage(),
        ],
      ),
    ),
  );
}
}