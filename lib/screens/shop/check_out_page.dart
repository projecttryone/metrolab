import 'package:card_swiper/card_swiper.dart';
import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/address/add_address_page.dart';
import 'package:ecommerce_int2/screens/dbmain.dart';
import 'package:ecommerce_int2/screens/payment/unpaid_page.dart';
import 'package:ecommerce_int2/screens/profile_page.dart';
import 'package:flutter/material.dart';
import '../../api_service.dart';
import 'components/credit_card.dart';
import 'components/shop_item_list.dart';
import '../main/main_page.dart';

class CheckOutPage extends StatefulWidget {
  @override
  _CheckOutPageState createState() => _CheckOutPageState();
}
Map<String, dynamic>? customer;

class _CheckOutPageState extends State<CheckOutPage> {
  @override
  void initState() {
    super.initState();
    _loadCartFromDb();
      _loadCustomer();

  }
Future<void> _loadCustomer() async {
  final data = await Dbmain.getLastInsertedCustomer();
  if (!mounted) return;
  setState(() {
    customer = data;
  });
}
  Future<void> _loadCartFromDb() async {
               Map<String, dynamic>? customer_name = await Dbmain.getLastInsertedCustomer();

    try {
      final rows = await Dbmain.getCartItems();
      if (rows.isEmpty) return;

      double _asDouble(dynamic v, [double fallback = 0.0]) {
        if (v == null) return fallback;
        if (v is num) return v.toDouble();
        return double.tryParse(v.toString()) ?? fallback;
      }

      int _asInt(dynamic v, [int fallback = 0]) {
        if (v == null) return fallback;
        if (v is int) return v;
        if (v is num) return v.toInt();
        return int.tryParse(v.toString()) ?? fallback;
      }

      String _asString(dynamic v, [String fallback = '']) {
        if (v == null) return fallback;
        return v.toString();
      }

      final fetched = rows.map<Product>((r) {
        final img = 'assets/test2.png';
        final title = _asString(r['title'], _asString(r['name'], 'Item'));
        final desc = _asString(r['description'], _asString(r['desc'], ''));
        final price = _asDouble(r['price'], 0.0);
        final qty = _asInt(r['product_id'], 1);
        final code = _asString(r['id'] ?? r['sku'] ?? '');
        return Product(img, title, desc, price, qty, code);
      }).toList();

      if (!mounted) return;
      setState(() => products = fetched);
    } catch (e) {
      debugPrint('loadCartFromDb error: $e');
    }
  }

  SwiperController swiperController = SwiperController();

  List<Product> products = [];

  @override
  Widget build(BuildContext context) {
    // unchanged logic, only UI composition moved to bottomNavigationBar
    final Widget checkOutButton = InkWell(
      onTap: () async {
        final sure = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Confirm checkout'),
            content:
                const Text('Are you sure you want to place this order?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('No')),
              ElevatedButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Yes')),
            ],
          ),
        );

        if (sure != true) return;

        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const Center(child: CircularProgressIndicator()),
        );

        try {
          final int? customer_id = await Dbmain.getLastInsertedCustomerId();

          final tests =
              products.map<Map<String, dynamic>>((p) {
            return {
              'product_id': p.id,
              'product_price': p.price,
              'quantity': 1, // keep as in your original code
            };
          }).toList();

          final api = ApiService(baseUrl: 'http://127.0.0.1:8000');
          await api.login(email: 'admin@example.com', password: 'password');

          final res = await api.createOrder(
            customerId: customer_id!, // unchanged
            tests: tests,
          );

          if (context.mounted) Navigator.of(context).pop(); // close loader

          await Dbmain.removeCartItemall();

          if (!context.mounted) return;
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (_) => MainPage()));
        } catch (e) {
          if (context.mounted) {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Checkout failed: $e')),
            );
          }
        }
      },
      child: Container(
        height: 56,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 55, 120, 83),
          boxShadow: const [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.16),
              offset: Offset(0, 5),
              blurRadius: 10.0,
            )
          ],
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: const Center(
          child: Text(
            "Continue",
            style: TextStyle(
              color: Color(0xfffefefe),
              fontWeight: FontWeight.w600,
              fontSize: 18.0,
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        elevation: 0,
        iconTheme: IconThemeData(color: darkGrey),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Image.asset('assets/icons/denied_wallet.png'),
        //     onPressed: () => Navigator.of(context)
        //         .push(MaterialPageRoute(builder: (_) => UnpaidPage())),
        //   )
        // ],
        title: Text(
          'My Cart',
          style: TextStyle(
            color: darkGrey,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ),

      // ===== BODY (pure layout; no logic changed) =====
     
     
      body: SafeArea(
        child: Column(
          children: [
            // top call-banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _CallNowBanner(),
            ),
            const SizedBox(height: 12),
            // patient header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _PatientHeaderCard(customer: customer),

            ),
            const SizedBox(height: 8),

            // list of items + "Add More Test" as footer — expands to fill
            Expanded(
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                itemCount: products.length + 1,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  if (index == products.length) {
                    // footer = "Add More Test"
                    return Center(
                      child: TextButton(
                        onPressed: () {
                          // keep it simple; you can hook navigation later
                        },
                        child: const Text(
                          '',
                          style: TextStyle(
                            color: Color.fromARGB(255, 55, 120, 83),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    );
                  }

                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE6E6E6),
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0F000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        )
                      ],
                    ),
                    child: ShopItemList(
                      products[index],
                      onRemove: () async {
                        final idStr = products[index].test_method;
                        final cartId = int.tryParse(idStr);
                        if (cartId == null) {
                          debugPrint(
                              'Remove aborted: bad cart id "$idStr"');
                          return;
                        }
                        await Dbmain.removeCartItem(cartId);
                        setState(() => products.removeAt(index));
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),

      // sticky bottom button (matches screenshot "Continue")
      bottomNavigationBar: SafeArea(
        minimum:
            EdgeInsets.only(left: 16, right: 16, bottom: 16),
        child: checkOutButton,
      ),
    );
  }
}

/// simple green banner with "Call Now" pill button
class _CallNowBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF1F7A53),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Do you have any questions\nregarding your tests?',
                  style: TextStyle(
                    color: Colors.white,
                    height: 1.2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Talk to our health advisors to book now',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(999),
            ),
            child: Row(
              children: const [
                Icon(Icons.call, size: 18, color: Color(0xFF1F7A53)),
                SizedBox(width: 6),
                Text(
                  'Call Now',
                  style: TextStyle(
                    color: Color(0xFF1F7A53),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

/// patient header card like the screenshot
class _PatientHeaderCard extends StatelessWidget {
  final Map<String, dynamic>? customer;
  const _PatientHeaderCard({this.customer});

  @override
  Widget build(BuildContext context) {
    final name = [
      customer?['bill_first_name'] ?? '',
      customer?['bill_last_name'] ?? ''
    ].where((s) => s.isNotEmpty).join(' ');

    final gender = customer?['gender'] ?? 'N/A';
    final dob = customer?['dob']; // 'YYYY-MM-DD'

    // quick age calc
    int? age;
    if (dob != null && dob.toString().contains('-')) {
      final birth = DateTime.tryParse(dob);
      if (birth != null) {
        final now = DateTime.now();
        age = now.year - birth.year -
            ((now.month < birth.month ||
                    (now.month == birth.month && now.day < birth.day))
                ? 1
                : 0);
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF0F5C3F),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${name.isEmpty ? "Unknown" : name} (self)\n'
              '${gender}, ${age ?? "--"} yrs',
              style: const TextStyle(
                color: Colors.white,
                height: 1.3,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// (kept; unused painter from your original file)
class Scroll extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    LinearGradient grT = const LinearGradient(
        colors: [Colors.transparent, Colors.black26],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter);
    LinearGradient grB = const LinearGradient(
        colors: [Colors.transparent, Colors.black26],
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter);

    canvas.drawRect(
        Rect.fromLTRB(0, 0, size.width, 30),
        Paint()
          ..shader =
              grT.createShader(Rect.fromLTRB(0, 0, size.width, 30)));

    canvas.drawRect(
        Rect.fromLTRB(0, 30, size.width, size.height - 40),
        Paint()..color = const Color.fromRGBO(50, 50, 50, 0.4));

    canvas.drawRect(
        Rect.fromLTRB(0, size.height - 40, size.width, size.height),
        Paint()
          ..shader = grB.createShader(Rect.fromLTRB(
              0, size.height - 40, size.width, size.height)));
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
