import 'dart:ffi';

// import 'package:ecommerce_int2/models/categories.dart';
import 'package:ecommerce_int2/models/category.dart';
import 'package:flutter/material.dart';
import 'recommended_list.dart';
import 'package:ecommerce_int2/screens/dbmain.dart';
import '/models/categories.dart';

class TabView extends StatefulWidget {
  final TabController tabController;
  const TabView({super.key, required this.tabController});

  @override
  State<TabView> createState() => _TabViewState();



  
}

class _TabViewState extends State<TabView> {
  String selectedCategory = '';
int? selectedCategoryId;
List<categories> categorie = [];
bool _isLoading = false;

Future<void> _loadCategories() async {
  setState(() => _isLoading = true);
  final list = await Dbmain.fetchLabPackagesparent(catid: 0); // par_cod = 0
  if (!mounted) return;
  setState(() {
    categorie = list;
    _isLoading = false;
  });
}
  // final List<Category> categories = [
  //   Category(Color(0xffA8E6CF), Color(0xff56C596), 'Blood Tests', 'assets/vlood_icon.png', 174 as int),
  //   Category(Color(0xffFFD3B6), Color(0xffFFAAA5), 'Kidney Test', 'assets/kidney_icon.png', 151 as int),
  //   Category(Color(0xffD4A5A5), Color(0xff9C4F4F), 'Heart Panels', 'assets/heart_icon.png', 150 as int),
  //   Category(Color(0xff81D4FA), Color(0xff4FC3F7), 'Covid Tests', 'assets/corona_icon.png', 141 as int),
  //   Category(Color(0xffFFF176), Color(0xffFFD54F), 'General Test', 'assets/general_test.png', 137 as int),
  // ];



// e.g. call once when the screen opens
@override
void initState() {
  super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) => _loadCategories());
}
  @override
  Widget build(BuildContext context) {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: widget.tabController,
      children: <Widget>[
        _buildTab(context,'All',),
        _buildTab(context ,'Highest Selling'),
        _buildTab(context,'Preventive'),
        _buildTab(context,'New Tests'),
      ],
    );
  }

  Widget _buildTab(BuildContext context,String namerr) {
    return CustomScrollView(
      physics: const ClampingScrollPhysics(),
      slivers: [
        // Category strip
        // SliverToBoxAdapter(
        //   child: Container(
        //     margin: const EdgeInsets.symmetric(horizontal: 6),
        //     height: MediaQuery.of(context).size.height / 9,
        //     width: MediaQuery.of(context).size.width,
        //     child: ListView.builder(
        //       scrollDirection: Axis.horizontal,
        //       physics: const ClampingScrollPhysics(),
        //       itemCount: categories.length,
        //       itemBuilder: (_, index) {
        //         final c = categories[index];
        //         final isSelected = c.category == selectedCategory;
        //         return GestureDetector(
        //           // onTap: () => setState(() => selectedCategory = c.category),
        //           // onTap: () => setState(() {
        //           //       selectedCategory = (selectedCategory == c.category) ? '' : c.category;
        //           //     }),
        //           onTap: () => setState(() {
        //           if (selectedCategory == c.category) {
        //             selectedCategory = '';
        //             selectedCategoryId = null;
        //           } else {
        //             selectedCategory = c.category;
        //             selectedCategoryId = c.id as int?; // store ID
        //           }
        //         }),


        //           child: Padding(
        //             padding: const EdgeInsets.only(top: 15, left: 6, right: 6 , bottom: 10),
        //             child: Column(
        //               mainAxisSize: MainAxisSize.min,
        //               children: [
        //                 CircleAvatar(
        //                   radius: 30,
        //                   backgroundColor: isSelected
        //                       ? const Color.fromARGB(255, 120, 190, 160)
        //                       : const Color.fromARGB(255, 171, 214, 190),
        //                   child: ClipOval(
        //                     child: Image.asset(
        //                       c.image,
        //                       width: 45,
        //                       height: 45,
        //                       fit: BoxFit.contain,
        //                     ),
        //                   ),
        //                 ),
        //                 const SizedBox(height: 8),
        //                 SizedBox(
        //                   width: 90,
        //                   child: Text(
        //                     c.category,
        //                     style: TextStyle(
        //                       fontSize: 10,
        //                       fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        //                     ),
        //                     textAlign: TextAlign.center,
        //                     maxLines: 2,
        //                     overflow: TextOverflow.ellipsis,
        //                   ),
        //                 ),
        //               ],
        //             ),
        //           ),
        //         );
        //       },
        //     ),
        //   ),
        // ),
      SliverToBoxAdapter(
  child: Container(
    margin: const EdgeInsets.symmetric(horizontal: 6),
    height: MediaQuery.of(context).size.height * 0.12, // dynamic height
    width: double.infinity,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      physics: const ClampingScrollPhysics(),
      itemCount: categorie.length,
      itemBuilder: (_, index) {
        final c = categorie[index];
        final isSelected = c.name == selectedCategory;

        return GestureDetector(
          onTap: () {
            setState(() {
              if (selectedCategory == c.name) {
                selectedCategory = '';
                selectedCategoryId = null;
              } else {
                selectedCategory = c.name;
                selectedCategoryId = c.id;
              }
            });
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.015,
              vertical: MediaQuery.of(context).size.height * 0.01,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // keeps content centered
              children: [
                Flexible(
                  flex: 5,
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width * 0.08,
                    backgroundColor: isSelected
                        ? const Color.fromARGB(255, 120, 190, 160)
                        : const Color.fromARGB(255, 171, 214, 190),
                    child: ClipOval(
                      child: Image.asset(
                        c.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Flexible(
                  flex: 3,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.20,
                    child: Text(
                      c.name,
                      //  "${c.id}",
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.025,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ),
  ),
),

        // Recommended section — now receives the selection
        SliverToBoxAdapter(
          child: RecommendedList(nameofcat:namerr,selectedCategory: selectedCategory ,catid: selectedCategoryId ?? 0),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 8)),

        const SliverFillRemaining(
          hasScrollBody: false,
          fillOverscroll: true,
          child: SizedBox.shrink(),
        ),
      ],
    );
  }



}
