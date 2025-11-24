import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rubber/rubber.dart';
import 'package:ecommerce_int2/screens/dbmain.dart';

import '../../db_helper.dart';
import '../../models/product.dart';
import 'package:ecommerce_int2/screens/product/view_product_page.dart';
import 'calltoActionWidget.dart';
import 'package:ecommerce_int2/app_properties.dart';
import 'main/components/PackageDetailPage.dart';
import 'package:url_launcher/url_launcher.dart';

void openWhatsApp(String phone, {String message = ''}) async {
  final Uri whatsappUri = Uri.parse("whatsapp://send?phone=$phone&text=${Uri.encodeComponent(message)}");

  if (await canLaunchUrl(whatsappUri)) {
    await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
  } else {
    // fallback to browser or show error
    print("WhatsApp is not installed on this device");
  }
}

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> with SingleTickerProviderStateMixin {
  List<Product> _products = [];
  List<Product> searchResults = [];
  bool _isLoading = true;
  TextEditingController searchController = TextEditingController();
  late RubberAnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = RubberAnimationController(
      vsync: this,
      halfBoundValue: AnimationControllerValue(percentage: 0.4),
      upperBoundValue: AnimationControllerValue(percentage: 0.4),
      lowerBoundValue: AnimationControllerValue(pixel: 50),
      duration: Duration(milliseconds: 200),
    );
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final db = await DBHelper.instance.db;
      final rows = await db.rawQuery('''
      SELECT
        p.id     AS id,
        p.url_code     AS image,
        pfv.value       AS name,
                pfv2.value       AS price,

        p.test_desc     AS testDesc,
        p.test_method   AS testMethod
      FROM products p
      LEFT JOIN product_field_values pfv
        ON p.id = pfv.product_id
       AND pfv.product_field_id = 1
            LEFT JOIN product_field_values pfv2
        ON p.id = pfv2.product_id
       AND pfv2.product_field_id = 2
    ''');

    //   Future<List<Product>> fetchAllProducts() async {
//     final db = await DBHelper.instance.db;
//     final rows = await db.rawQuery('''
//       SELECT
//         p.id     AS id,
//         p.url_code     AS image,
//         pfv.value       AS name,
//         p.test_desc     AS testDesc,
//         p.test_method   AS testMethod
//       FROM products p
//       LEFT JOIN product_field_values pfv
//         ON p.id = pfv.product_id
//        AND pfv.product_field_id = 1
//     ''');

    _products = rows.map((r) {
      final rawImage = (r['image'] as String?).isNullOrEmpty
        ? 'assets/placeholder.png'
        : r['image'] as String;
          // final rawPrice = r['price'] as num?;

final rawPrice = double.tryParse(r['price']?.toString() ?? '') ?? 0.0;
          final price = rawPrice?.toDouble() ?? 0.0;



      return Product(
        'assets/placeholder.png',
        r['name']       as String? ?? '',
        r['description'] as String? ?? '',
       price,
        r['id']         as int,
        r['testMethod'] as String? ?? '' ,
      );
    }).toList();

    setState(() {
      searchResults = List.from(_products);
      _isLoading = false;
    });
  }

  Widget _buildProductCard(Product item) {
    final thumb = item.image.startsWith('http')
      ? Image.network(item.image, width: 80, height: 80, fit: BoxFit.cover)
      : Image.asset(item.image, width: 80, height: 80, fit: BoxFit.cover);

    return Card(
      color: const Color.fromARGB(255, 254, 254, 254),
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: InkWell(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => PackageDetailPage(packageId: item.id.toString())),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // thumb,
              SizedBox(width: 12),
            Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1) Title
                        Text(
                          item.name,
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),

                        // 2) Also called
                        if (item.test_method.isNotEmpty)
                          Text(
                            'Also called: ${item.test_method}',
                            style: TextStyle(
                              color: const Color.fromARGB(255, 65, 65, 65),
                              fontSize: 14,
                            ),
                          ),
                        SizedBox(height: 4),

                        // 3) Includes
                      FutureBuilder<int>(
                    future: Dbmain.fetchnooftest(catid: item.id),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          'Includes: ...',
                          style: TextStyle(
                            color: Color.fromARGB(255, 65, 65, 65),
                            fontSize: 14,
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text(
                          'Includes: Error',
                          style: TextStyle(
                            color: Color.fromARGB(255, 65, 65, 65),
                            fontSize: 14,
                          ),
                        );
                      }

                      final count = snapshot.data ?? 0;
                      return Text(
                        'Includes: $count Tests',
                        style: const TextStyle(
                          color: Color.fromARGB(255, 65, 65, 65),
                          fontSize: 14,
                        ),
                      );
                    },
                  ),

                        SizedBox(height: 8),

                        // 4) Description
                        Text(
                          item.description,
                          style: TextStyle(
                            color: const Color.fromARGB(255, 65, 65, 65),
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 8),

                        // 5) Price
                        Text(
                          '₹${item.price.toStringAsFixed(0)}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),

              // TextButton(
              //   onPressed: () {
              //     // TODO: add-to-cart logic
                  
              //   },
              //   style: TextButton.styleFrom(
              //     backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              //     shape: StadiumBorder(),
              //     padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //   ),
              //   child: Text('Add', style: TextStyle(color: const Color.fromARGB(255, 12, 117, 44),fontWeight: FontWeight.bold, fontSize: 20,)),
              // ),
              TextButton(
                  onPressed: () async {
                    try {
                      final cartId = await Dbmain.insertCartLineFromProduct(
                        productId: int.parse( item.id.toString()), // ensure int
                        qty: 1,
                      );

                      print("Inserted into cart with row id $cartId");

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Added ${item.name} (1) to cart')),
                      );
                    } catch (e) {
                      print("Error adding to cart: $e");
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error adding to cart')),
                      );
                    }
                  },
                  style: TextButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: StadiumBorder(),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                  child: Text(
                    'Add',
                    style: TextStyle(
                      color: const Color.fromARGB(255, 12, 117, 44),
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                )
                ,
            ],
          ),
        ),
      ),
    );
  }

  Widget _getLowerLayer() {
    return Container(
      // margin: const EdgeInsets.only(top: kToolbarHeight),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('', style: TextStyle(color: darkGrey, fontSize: 22, fontWeight: FontWeight.bold)),
                // CloseButton(),
              ],
            ),
          ),
          // Search field
  Container(
  margin: const EdgeInsets.symmetric(horizontal: 16),
  decoration: const BoxDecoration(
    border: Border(bottom: BorderSide(color: Color.fromARGB(255, 239, 238, 236), width: 1)),
  ),
  child: TextField(
    controller: searchController,
    onChanged: (value) => setState(() {
      searchResults = value.isEmpty
          ? List.from(_products)
          : _products
              .where((p) => p.name.toLowerCase().contains(value.toLowerCase()))
              .toList();
    }),
    cursorColor: darkGrey,
    textInputAction: TextInputAction.search,
    style: const TextStyle(fontSize: 16, height: 1.2),
    decoration: InputDecoration(
      hintText: 'Search tests, packages…',
      hintStyle: const TextStyle(fontSize: 15, color: Colors.black54),

      // pill + filled background
      filled: true,
      fillColor: const Color(0xFFF7F7F7),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 14),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Colors.black12),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color.fromARGB(255, 238, 237, 236), width: 1.6),
      ),

      // search icon with padding
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12),
        child: SvgPicture.asset('assets/icons/search_icon.svg'),
      ),
                      
      prefixIconConstraints:
          const BoxConstraints(minWidth: 48, minHeight: 48),
     suffixIcon: CloseButton() ,

      // show "Clear" only when there is text
      suffix: AnimatedSwitcher(
        duration: const Duration(milliseconds: 150),
        child: searchController.text.isNotEmpty
            ? TextButton(
                onPressed: () {
                  searchController.clear();
                  setState(() => searchResults = List.from(_products));
                },
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  foregroundColor: const Color.fromARGB(255, 236, 235, 235),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Clear'),
              )
            : const SizedBox.shrink(),
      ),
      
    ),
    
  ),

),
          // CTA
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: CallToActionWidget(
              phoneNumber: '+9779860103441',
              onChatPressed: () {  openWhatsApp('9779860103441', message: 'Hello, I need help with your service.');
},
            ),
          ),
          // List
          Expanded(
            child: _isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  itemCount: searchResults.length,
                  itemBuilder: (_, i) => _buildProductCard(searchResults[i]),
                ),
          ),
        ],
      ),
    );
  }

  Widget _getUpperLayer() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 12),
      child: CallToActionWidget(
        phoneNumber: '+9779860103441',
        onChatPressed: () {  openWhatsApp('9779860103441', message: 'Hello, I need help with your service.');
},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Scaffold(
          body: RubberBottomSheet(
            lowerLayer: _getLowerLayer(),
            upperLayer: _getUpperLayer(),
            animationController: _controller,
          ),
        ),
      ),
    );
  }
}

extension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

