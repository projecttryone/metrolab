import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/dbmain.dart';
import 'package:ecommerce_int2/screens/product/product_page.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter/material.dart';
import '../../../db_helper.dart';
import 'package:sqflite/sqflite.dart';
import 'PackageDetailPage.dart';

class RecommendedList extends StatefulWidget {
  final String selectedCategory;
  final String nameofcat;
   final int catid;

  const RecommendedList({
    super.key,
    required this.selectedCategory,
    required this.nameofcat, //preventive , highselling or new test 
        required this.catid,

  });


  @override
  State<RecommendedList> createState() => _RecommendedListState();
}

class _RecommendedListState extends State<RecommendedList>  with SingleTickerProviderStateMixin{
  List<Product> products = [];

 bool _isLoading = true;

  late final AnimationController _beat;
  late final Animation<double> _scale;

  @override
void initState() {
  super.initState();

  _beat = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 800),
  )..repeat(reverse: true);

  _scale = TweenSequence<double>([
    TweenSequenceItem(
      tween: Tween(begin: 0.90, end: 1.15).chain(CurveTween(curve: Curves.easeOut)),
      weight: 40,
    ),
    TweenSequenceItem(
      tween: Tween(begin: 1.15, end: 0.95).chain(CurveTween(curve: Curves.easeIn)),
      weight: 60,
    ),
  ]).animate(_beat);

  _loadProducts(widget.catid,widget.nameofcat);
}
 @override
  void didUpdateWidget(covariant RecommendedList oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.catid != widget.catid) {
      _loadProducts(widget.catid,widget.nameofcat); // refetch on cat change
    }
  }

 
Future<void> _loadProducts(int catId , String nameofcat) async {
  setState(() => _isLoading = true);
  final list = await Dbmain.fetchAllProducts(catid: catId , prop1 : nameofcat);
  if (!mounted) return;
  setState(() {
    products = list;
    _isLoading = false;
  });
}

@override
void dispose() {
  _beat.dispose();
  super.dispose();
}

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 35,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                IntrinsicHeight(
                  child: Container(
                    margin: const EdgeInsets.only(left: 16.0, right: 8.0),
                    width: 4,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                    
                      Text(
                        widget.nameofcat,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 28, 29, 28), //name preventive , new tests 
                        ),
                      ),
                        Text(
                        widget.selectedCategory,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 10, 10, 10),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
       SizedBox(
  height: 230,
  child: _isLoading
      ? Center(
          child: ScaleTransition(
            scale: _scale,
            child: const Icon(Icons.favorite, size: 44, color: Colors.red),
          ),
        )
      : (products.isEmpty
          ? const Center(child: Text('No tests found'))
          : ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const ClampingScrollPhysics(),
              padding: const EdgeInsets.only(left: 16),
              itemCount: products.length,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (context, index) => SizedBox(
                width: 180,
                child: _PackageCard(product: products[index], index: index),
              ),
            )),
),

        ],
      ),
    );
  }
}


// class _PackageCard extends StatelessWidget {
//   final Product product;
//   final int index;

//   const _PackageCard({required this.product, required this.index});
//   final list = await Dbmain.fetchAllProducts(catid: product.id);

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
      
//       borderRadius: const BorderRadius.all(Radius.circular(12)),
//       child: Container(
//         decoration: BoxDecoration(
//           color: Colors.white,
//           border: Border.all(color: const Color(0xFFE6F4EA)), // soft mint border
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.05),
//               blurRadius: 6,
//               offset: const Offset(0, 2),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             // Top content
//             Padding(
//               padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Title
//                   Text(
//                     product.name,
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.w700,
//                       fontSize: 13,
//                       color: Color(0xFF134E10), // deep green
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   // Small icon + "59 Tests"
//                   Row(
//                     children: [
//                       CircleAvatar(
//                         radius: 12,
//                         backgroundColor: const Color(0xFFEAF7EE),
//                         child: Hero(
//                           tag: '${product.image}-$index',
//                           child: ClipOval(
//                             child: Image.asset(
//                               product.image,
//                               width: 18,
//                               height: 18,
//                               fit: BoxFit.cover,
//                             ),
//                           ),
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       const Text(
//                         '59 Tests',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Color(0xFF4F8A52),
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 6),
//                   // Details >>
//                   const Text(
//                     'Details >>',
//                     style: TextStyle(
//                       fontSize: 11,
//                       color: Color(0xFF6A6A6A),
//                       decoration: TextDecoration.underline,
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             // Bottom green area (rounded top)
//             Container(
//               width: double.infinity,
//               decoration: const BoxDecoration(
//                 color: Color(0xFFD9F5DF), // light mint
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(18),
//                   topRight: Radius.circular(18),
//                 ),
//               ),
//               child: Column(
//                 children: [
//                   // EXCLUSIVE OFFER strip
//                   Container(
//                     width: double.infinity,
//                     padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     decoration: const BoxDecoration(
//                       color: Color(0xFFB8EFC2),
//                       borderRadius: BorderRadius.only(
//                         topLeft: Radius.circular(18),
//                         topRight: Radius.circular(18),
//                       ),
//                     ),
//                     child: const Text(
//                       'EXCLUSIVE OFFER',
//                       style: TextStyle(
//                         fontSize: 11,
//                         fontWeight: FontWeight.w800,
//                         color: Color(0xFF0E3B0C),
//                         letterSpacing: 0.2,
//                       ),
//                     ),
//                   ),

//                   // Price row
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
//                     child: Row(
//                       children: [
//                         Text(
//                           '₹ ${product.price.toStringAsFixed(0)}',
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontWeight: FontWeight.w900,
//                             color: Color(0xFF0E3B0C),
//                           ),
//                         ),
//                         const SizedBox(width: 8),
//                         if ((product.price ?? 0) > 0)
//                           Text(
//                             '₹ ${(product.price as num).toStringAsFixed(0)}',
//                             style: const TextStyle(
//                               fontSize: 11,
//                               color: Colors.black54,
//                               decoration: TextDecoration.lineThrough,
//                             ),
//                           ),
//                       ],
//                     ),
//                   ),

//                   // BOOK NOW button
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
//                     child: SizedBox(
//                       height: 34,
//                       width: double.infinity,
//                       child: ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF2BB673), // green
//                           shape: const StadiumBorder(),
//                           elevation: 0,
//                           padding: const EdgeInsets.symmetric(horizontal: 14),
//                         ),
//                         onPressed: () {
//                           Navigator.of(context).push(
//                             MaterialPageRoute(
//                               // builder: (_) => ProductPage(product: product),
//                                builder: (_) => PackageDetailPage(packageId: product.id.toString()),

//                               //   builder: (_) => PackageDetailPage(packageId: '2'),

//                             ),
//                           );
//                         },
//                         child: const Text(
//                           'BOOK NOW',
//                           style: TextStyle(
//                             color: Colors.white,
//                             fontWeight: FontWeight.w800,
//                             fontSize: 12,
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
class _PackageCard extends StatelessWidget {
  final Product product;
  final int index;

  const _PackageCard({required this.product, required this.index});

  @override
  Widget build(BuildContext context) {
     return GestureDetector(
    behavior: HitTestBehavior.opaque, // taps anywhere, even on empty space
    onTap: () {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PackageDetailPage(packageId: product.id.toString()),
        ),
      );
    },
    child: ClipRRect(
      borderRadius: const BorderRadius.all(Radius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFFE6F4EA)), // soft mint border
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top content
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      color: Color.fromARGB(255, 5, 5, 5), // deep green
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Small icon + dynamic tests count
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: const Color(0xFFEAF7EE),
                        child: Hero(
                          tag: '${product.image}-$index',
                          child: ClipOval(
                            child: Image.asset(
                              product.image,
                              width: 18,
                              height: 18,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                   FutureBuilder<int>(
                    future: Dbmain.fetchnooftest(catid: product.id), // returns Future<int>
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text(
                          'Loading...',
                          style: TextStyle(
                            fontSize: 12,
                  color: const Color.fromARGB(255, 167, 221, 186),
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }
                      if (snapshot.hasError) {
                        return const Text(
                          'Error',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.red,
                            fontWeight: FontWeight.w600,
                          ),
                        );
                      }

                      final count = snapshot.data ?? 0; // int
                      return Text(
                        '$count Tests',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 213, 156, 72),
                          fontWeight: FontWeight.w600,
                        ),
                      );
                    },
                  ),

                    ],
                  ),
                  const SizedBox(height: 6),
                  // Details >>
                  const Text(
                    'Details >>',
                    style: TextStyle(
                      fontSize: 11,
                      color: Color.fromARGB(255, 160, 158, 158),
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),

            // Bottom green area (unchanged)
            Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Color.fromARGB(255, 167, 221, 186), // light mint
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18),
                  topRight: Radius.circular(18),
                ),
              ),
              child: Column(
                children: [
                  // EXCLUSIVE OFFER strip
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: const BoxDecoration(
                color: Color.fromARGB(255, 167, 221, 186), // light mint
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                    ),
                    child: const Text(
                      'EXCLUSIVE OFFER',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0E3B0C),
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),

                  // Price row
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
                    child: Row(
                      children: [
                      
                        Text(
                          
                          '₹ ${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF0E3B0C),

                          ),
                        ),
                        const SizedBox(width: 8),
                       if ((double.tryParse(product.test_method.toString()) ?? 0.0) <
                          (product.price))
                        Text(
                          '₹ ${product.test_method}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black54,
                            decoration: TextDecoration.lineThrough,


                          ),
                        ),
                      ],
                    ),
                  ),
                  

                  // BOOK NOW button
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
                    child: SizedBox(
                      height: 44,
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 34, 107, 57), // green
                          shape: const StadiumBorder(),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                        ),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  PackageDetailPage(packageId: product.id.toString()),
                            ),
                          );
                        },
                        child: const Text(
                          'BOOK NOW',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
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
      ),
      


    ),
    );
  }
}
