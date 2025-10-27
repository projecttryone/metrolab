import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:ecommerce_int2/screens/product/components/product_card.dart';
import 'package:flutter/material.dart';

class MoreProducts extends StatelessWidget {
  final List<Product> products = [
    Product('assets/test1.png', 'Lipid Profile',
                          'A detailed test measuring cholesterol and triglyceride levels to evaluate heart health.', 55.00,3336,''),
                      Product('assets/test2.png', 'Thyroid Profile (T3, T4, TSH)',
                          'Assesses thyroid gland function and helps diagnose hypo- or hyperthyroidism.', 75.00,4000 ,''),
                      Product('assets/test3.png', 'Vitamin D Test',
                          'Determines Vitamin D levels in the body to check for deficiencies that may affect bone and immune health.', 50.00,3337,''),
  ];

                    
                   
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 24.0, bottom: 8.0),
          child: Text(
            'More products',
            style: TextStyle(color: Colors.white, shadows: shadow),
          ),
        ),
        Container(
          margin: EdgeInsets.only(bottom: 20.0),
          height: 250,
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (_, index) {
              return Padding(
                ///calculates the left and right margins
                ///to be even with the screen margin
                  padding: index == 0
                      ? EdgeInsets.only(left: 24.0, right: 8.0)
                      : index == 4
                      ? EdgeInsets.only(right: 24.0, left: 8.0)
                      : EdgeInsets.symmetric(horizontal: 8.0),
                  child: ProductCard(products[index]));
            },
            scrollDirection: Axis.horizontal,
          ),
        )
      ],
    );
  }
}
