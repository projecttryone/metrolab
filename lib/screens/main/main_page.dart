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
      
        // Widget appBar = Container(
        //   // height: kToolbarHeight + MediaQuery.of(context).padding.top,
        //    height: kToolbarHeight,

        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //     children: <Widget>[
        //       IconButton(
        //           onPressed: () => Navigator.of(context)
        //               .push(MaterialPageRoute(builder: (_) => NotificationsPage())),
        //           icon: Icon(Icons.notifications)),
        //       IconButton(
        //           onPressed: () => Navigator.of(context)
        //               .push(MaterialPageRoute(builder: (_) => SearchPage())),
        //           icon: SvgPicture.asset('assets/icons/search_icon.svg'))
        //     ],
        //   ),
        // );


Widget appBar = Container(
  width: double.infinity, // ✅ fit full width
  height: 42,
  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
              "Search for 'Blood Test'",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ),
        ),
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




        /// ---- PILL-STYLE HEADER ----
        Widget topHeader = Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 10.0, bottom: 8.0, top: 4.0),
          child: Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(timelines.length, (index) {
                bool isSelected = timelines[index] == selectedTimeline;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedTimeline = timelines[index];
                        // same logic for products
                      if (index == 0) {
                        // Weekly featured
                        _products = _products2 ;
                      } else if (index == 1) {
                        // Best of June
                        _products = [
                          Product('assets/test1.png', 'Lipid Profile',
                              'A detailed test measuring cholesterol and triglyceride levels to evaluate heart health.', 55.00,3336,''),
                          Product('assets/test2.png', 'Thyroid Profile (T3, T4, TSH)',
                              'Assesses thyroid gland function and helps diagnose hypo- or hyperthyroidism.', 75.00,4000,''),
                          Product('assets/test3.png', 'Vitamin D Test',
                              'Determines Vitamin D levels in the body to check for deficiencies that may affect bone and immune health.', 50.00,3337,''),
                        ];
                      } else {
                        // Best of 2018
                        _products = [
                          Product('assets/test4.png', 'COVID-19 RT-PCR Test',
                              'A highly accurate diagnostic test to detect the presence of SARS-CoV-2 using a nasal swab sample.', 80.00,3338,''),
                          Product('assets/test2.png', 'Hemoglobin (Hb) Test',
                              'Measures hemoglobin levels in the blood, useful for diagnosing anemia and other blood disorders.', 40.00,3339,''),
                          Product('assets/test3.png', 'Albumin Blood Test',
                              'Checks the albumin protein levels in the blood to help assess liver and kidney function.', 55.00,3340,''),
                        ];
                      }

                      });
                    },
                    child: AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      padding: EdgeInsets.symmetric(vertical: 2),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? const Color.fromARGB(255, 5, 74, 17) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          timelines[index],
                          style: TextStyle(
                            fontSize: isSelected ? 14 : 10,
                            color: isSelected ? Colors.white : Colors.black87,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        );

        Widget tabBar = TabBar(
          tabs: [
            Tab(text: 'ALL'),
            Tab(text: 'Highest selling'),
            Tab(text: 'Preventive'),
            Tab(text: 'New Tests'),
            // Tab(text: 'Liver'),
            //  Tab(text: 'blood'),
          ],
          labelStyle: TextStyle(fontSize: 16.0),
          unselectedLabelStyle: TextStyle(fontSize: 14.0),
          labelColor: darkGrey,
          unselectedLabelColor: Color.fromRGBO(0, 0, 0, 0.5),
          isScrollable: true,
          controller: tabController,
         );

   

return Scaffold(
  bottomNavigationBar: CustomBottomBar(controller: bottomTabController),
  body: CustomPaint(
    painter: MainBackground(),
    child: TabBarView(
      controller: bottomTabController,
      physics: const NeverScrollableScrollPhysics(),
      children: <Widget>[
        // -------- Tab 1 (no vertical scroll/bounce) --------
        SafeArea(
          child: Column(
            children: [
              appBar,

              // keep your banner static (not scrollable)
             OfferCardSection(
              offers: [
                Offer(imagePath: 'assets/offer/card4.png', discount: 'Up to 20% off', title: 'Highest Selling'),
                Offer(imagePath: 'assets/offer/card2.png', discount: 'Up to 15% off', title: 'Preventive'),
                Offer(imagePath: 'assets/offer/card3.png', discount: 'Up to 25% off', title: 'New Tests'),
              ],
              tabController: tabController,
              
            ),


              // your tab bar below the banner
              tabBar,

              // tabs content fills remaining height, with no bounce
              Expanded(
                // child: ScrollConfiguration(
                  // behavior: const NoBounceScrollBehavior(),
                  child: TabView(tabController: tabController),
                ),
              // ),
            ],
          ),
        ),

        // -------- Other tabs unchanged --------
        CategoryListPage(),
             CallPage(phoneNumber: '+9779860103441'), // 🚀 launches immediately


        CheckOutPage(),
        OrdersPage(),
          ProfilePage(),
      ],
    ),
  ),
);



      }
    }

