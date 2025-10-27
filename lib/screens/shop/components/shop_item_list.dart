import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class ShopItemList extends StatefulWidget {
  final Product product;
  final VoidCallback onRemove;

  const ShopItemList(this.product, {Key? key, required this.onRemove})
      : super(key: key);

  @override
  _ShopItemListState createState() => _ShopItemListState();
}

class _ShopItemListState extends State<ShopItemList> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE6E6E6)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // small leading icon (no image as requested)
            Padding(
              padding: const EdgeInsets.only(top: 2.0),
              child: Icon(Icons.biotech, size: 18, color: const Color(0xFF1F7A53)),
            ),
            const SizedBox(width: 10),

            // title + subtitle + quantity (kept logic)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // test name
                  Text(
                    widget.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: darkGrey,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                      height: 1.25,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // subtitle like screenshot
                  const Text(
                    '3 Tests included',
                    style: TextStyle(
                      color: Color(0xFF6B7280),
                      fontSize: 12,
                    ),
                  ),

                  const SizedBox(height: 6),

                  // quantity picker (unchanged logic; compact so it never overflows)
                  // Theme(
                  //   data: Theme.of(context).copyWith(
                  //     textTheme: Theme.of(context).textTheme.copyWith(
                  //           titleLarge: const TextStyle(
                  //             fontFamily: 'Montserrat',
                  //             fontSize: 14,
                  //             color: Colors.black,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //           bodyLarge: TextStyle(
                  //             fontFamily: 'Montserrat',
                  //             fontSize: 12,
                  //             color: Colors.grey[400],
                  //           ),
                  //         ),
                  //     colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.black),
                  //   ),
                  //   child: NumberPicker(
                  //     value: quantity,
                  //     minValue: 1,
                  //     maxValue: 10,
                  //     itemHeight: 28,
                  //     itemWidth: 40,
                  //     textStyle: const TextStyle(fontSize: 12, color: Colors.grey),
                  //     selectedTextStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  //     onChanged: (value) => setState(() => quantity = value),
                  //   ),
                  // ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // trailing column: red X + price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // remove button
                IconButton(
                  visualDensity: VisualDensity.compact,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.close, color: Colors.red, size: 25),
                  onPressed: widget.onRemove,
                  tooltip: 'Remove',
                ),
                const SizedBox(height: 8),

                // price (₹ / Rs as per your app)
                Text(
                  'Rs. ${_price(widget.product.price)}',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: darkGrey,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _price(num p) {
    // avoids trailing .0 while keeping simple
    final s = p.toString();
    return s.endsWith('.0') ? s.substring(0, s.length - 2) : s;
  }
}
