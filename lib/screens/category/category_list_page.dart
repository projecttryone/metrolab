import 'dart:math';
import 'package:ecommerce_int2/app_properties.dart';
import 'package:ecommerce_int2/models/category.dart';
import 'package:ecommerce_int2/screens/dbmain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'components/staggered_category_card.dart';

Color _randomColor() {
  final random = Random();
  return Colors.primaries[random.nextInt(Colors.primaries.length)].shade200;
}

Color _randomColorDark() {
  final random = Random();
  return Colors.primaries[random.nextInt(Colors.primaries.length)].shade400;
}

class CategoryListPage extends StatefulWidget {
  @override
  _CategoryListPageState createState() => _CategoryListPageState();
}

class _CategoryListPageState extends State<CategoryListPage> {
  List<Category> categories = [];
  List<Category> searchResults = [];
  TextEditingController searchController = TextEditingController();
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    final dbList = await Dbmain.fetchLabPackagesparent(catid: 0);

    final mapped = dbList.map((c) {
      return Category(
        _randomColor(),
        _randomColorDark(),
        c.name ?? '',
         'assets/placeholder.png',
        c.id ?? 0,
      );
    }).toList();

    setState(() {
      categories = mapped;
      searchResults = List.from(mapped);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Color(0xffF9F9F9),
      child: Container(
        margin: const EdgeInsets.only(top: kToolbarHeight),
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: <Widget>[
            Align(
              alignment: Alignment(-1, 0),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Category List',
                  style: TextStyle(
                    color: darkGrey,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Search Field
            Container(
              padding: EdgeInsets.only(left: 16.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5)),
                color: Colors.white,
              ),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search',
                  prefixIcon: SvgPicture.asset(
                    'assets/icons/search_icon.svg',
                    fit: BoxFit.scaleDown,
                  ),
                ),
                onChanged: (value) {
                  value = value.toLowerCase();
                  setState(() {
                    if (value.isEmpty) {
                      searchResults = List.from(categories);
                    } else {
                      searchResults = categories
                          .where((cat) =>
                              cat.category.toLowerCase().contains(value))
                          .toList();
                    }
                  });
                },
              ),
            ),

            const SizedBox(height: 10),

            // Loader
            if (loading) CircularProgressIndicator(),

            // Category List
            if (!loading)
              Expanded(
                child: ListView.builder(
                  itemCount: searchResults.length,
                  itemBuilder: (_, index) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 16.0),
                    child: StaggeredCardCard(
                      begin: searchResults[index].begin,
                      end: searchResults[index].end,
                      categoryName: searchResults[index].category,
                      assetPath: searchResults[index].image,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
