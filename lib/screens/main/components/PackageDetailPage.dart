import 'dart:math' as math;
import 'package:ecommerce_int2/models/labpackage.dart';
import 'package:ecommerce_int2/models/product.dart';
import 'package:flutter/material.dart';
import '../../dbmain.dart';

// ===== Fake Data (replace with SQL later) =====


const _brandGreen = Color.fromARGB(255, 55, 120, 83);
const _softGreenBG = Color(0xFFEFF8F3);

final Map<String, LabPackage> _packages = {
      '129135': LabPackage(
        id: '129135',
        title: 'METROLABS Welcome',
        codeLabel: '129135',
        mrp: 11999,
        price: 9999,
        testsCount: 59,
        highlights: [
          'Preventive Care, Metrolabs full body package',
          'Preventive Care, Metrolabs full body package',
          'Preventive Care, Metrolabs full body package',
        ],
        topBadges: ['T.CODES: 1595', 'PARA: 68'],
        image: 'https://picsum.photos/seed/lab/600/320',
        discountPct: 40,
        suggestionIds: ['sug1', 'sug2', 'sug3'],
      )
  };
  final Map<String, LabPackage> suggestionPackages = {
  'sug1': LabPackage(
    id: 'sug1',
    title: 'Healthy Aama',
    codeLabel: '—',
    mrp: 11999,
    price: 9999,
    testsCount: 59,
    highlights: const [],
    topBadges: const [],
    image: 'https://picsum.photos/seed/aama/400/240',
    discountPct: 17,
    suggestionIds: const [],
  ),
  'sug2': LabPackage(
    id: 'sug2',
    title: 'Healthy Hajurama',
    codeLabel: '—',
    mrp: 11999,
    price: 9999,
    testsCount: 59,
    highlights: const [],
    topBadges: const [],
    image: 'https://picsum.photos/seed/hajurama/400/240',
    discountPct: 22,
    suggestionIds: const [],
  ),
  'sug3': LabPackage(
    id: 'sug3',
    title: 'Healthy Papa',
    codeLabel: '—',
    mrp: 11999,
    price: 9999,
    testsCount: 59,
    highlights: const [],
    topBadges: const [],
    image: 'https://picsum.photos/seed/papa/400/240',
    discountPct: 18,
    suggestionIds: const [],
  ),
};

// ===== Screen =====
class PackageDetailPage extends StatefulWidget {
  final String packageId;
  const PackageDetailPage({super.key, required this.packageId});
     

  @override
  State<PackageDetailPage> createState() => _PackageDetailPageState();
}

class _PackageDetailPageState extends State<PackageDetailPage> 
{
   late Future<List<LabPackage>> futurePackages;
  late Future<List<Map<String, dynamic>>> testrelated;

    @override
    void initState() {
      super.initState();
      _hydrateMainPackageOnly(); // replaces only _packages[packageId]
        testrelated = Dbmain.testrelated(catid: int.parse(widget.packageId));

    }

  Future<void> _hydrateMainPackageOnly() async {
  try {
    // Fetch from DB (use your actual filter; catid:1 is just your current test)
    // final list = await Dbmain.fetchLabPackages(catid: widget.packageId);
final list = await Dbmain.fetchLabPackages(
  catid: int.parse(widget.packageId),
);
      // final test = await Dbmain.fetchnooftest(catid: widget.packageId) ;
    // final testrelated = await Dbmain.fetchnooftest(catid: int.parse(widget.packageId));

    // Find the package that matches this page’s id
    final int idx = list.indexWhere((p) => p.id == widget.packageId);
    final LabPackage? dbPkg =
        (idx != -1) ? list[idx] : (list.isNotEmpty ? list.first : null);

    if (!mounted || dbPkg == null) {
      debugPrint('ℹ️ No DB package found; keeping hardcoded entry for ${widget.packageId}.');
      return;
    }

    // Replace only the main package entry. Do NOT modify sug1/sug2/sug3.
    setState(() {
      _packages[widget.packageId] = dbPkg;
    });

    debugPrint('✅ Replaced _packages[${widget.packageId}] from DB ${widget.packageId}');
  } catch (e, st) {
    debugPrint('❌ hydrate error: $e');
  }
}


  int memberCount = 1;
  final TextEditingController _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final pkg = _packages[widget.packageId];
    if (pkg == null) {
      return Scaffold(appBar: AppBar(leading: const BackButton()), body: const Center(child: Text('Package not found')));
    }

const List<String> _defaultSuggestionIds = ['sug1', 'sug2', 'sug3'];

    // final suggestions = pkg.suggestionIds.map((id) => _packages[id]).whereType<LabPackage>().toList();
// Use DB suggestionIds if present else fallback to defaults
final sugIds = (pkg.suggestionIds.isNotEmpty)
    ? pkg.suggestionIds
    : _defaultSuggestionIds;

// Build from the dedicated suggestions map
final suggestions = sugIds
    .map((id) => suggestionPackages[id])
    .whereType<LabPackage>()
    .toList();

// (Optional) log to confirm
// debugPrint('👉 sugIds: $sugIds, built suggestions: ${suggestions.length}');
    // Guard text scale to avoid layout explosions
    final mq = MediaQuery.of(context);
    final media = mq.copyWith(textScaleFactor: mq.textScaleFactor.clamp(1.0, 1.2));

    // Responsive suggestion sizes (always enough vertical room)
    final screenW = mq.size.width;
    final itemW = math.max(180.0, math.min(240.0, screenW * 0.6));
    final imageH = itemW * 9 / 16;
    final suggestionListH = imageH + 210; // generous space to prevent child overflow

    return MediaQuery(
      data: media,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
              slivers: [
                // ---- Top bar with BACK in a round pill ----
                SliverAppBar(
                  pinned: false,
                  floating: true,
                  snap: true,
                  elevation: 0,
                  backgroundColor: const Color.fromARGB(0, 168, 12, 12),
                  leadingWidth: 64,
                  leading: Padding(
                    padding: const EdgeInsets.only(left: 12, top: 6, bottom: 6),
                    child: _CircleIconButton(
                      icon: Icons.arrow_back,
                      onTap: () => Navigator.maybePop(context),
                    ),
                  ),
                ),

                // ---- Search ----
                 SliverToBoxAdapter(child: _SearchBar(controller: _search)),

                // ---- Hero card ----
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  sliver: SliverToBoxAdapter(
                    child: _HeroPackageCard(
                      testdata : testrelated ,
                      pkg: pkg,
                      memberCount: memberCount,
                      onMinus: () => setState(() {
                        if (memberCount > 1) memberCount--;
                      }),
                      onPlus: () => setState(() => memberCount++),
                      // onBookNow: () {
                      //   ScaffoldMessenger.of(context).showSnackBar(
                      //     SnackBar(content: Text('Booked ${pkg.id} for $memberCount')),
                      //   );
                      // },
                      onBookNow: () async {
                        try {
                          // Insert this package into the cart
                          final cartId = await Dbmain.insertCartLineFromProduct(
                          productId: int.parse(pkg.id.toString()), // ensure int
                            qty: memberCount,    
                          );

                          // Optional: confirm success in console
                          print("Inserted into cart with row id $cartId");

                          // Navigate / show message after insert
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Added ${pkg.id} (x$memberCount) to cart')),
                          );
                        } catch (e) {
                          print("Error adding to cart: $e");
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error adding to cart')),
                          );
                        }
                      },


                    ),
                  ),
                ),

                // ---- Suggestions ----
                if (suggestions.isNotEmpty)
                  const SliverToBoxAdapter(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
                      child: Text('Suggested For You', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ),
                  ),
                if (suggestions.isNotEmpty)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: suggestionListH,
                      child: ListView.separated(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        scrollDirection: Axis.horizontal,
                        itemCount: suggestions.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) => _SuggestionCard(pkg: suggestions[i], width: itemW, imageH: imageH),
                      ),
                    ),
                  ),

                // ---- Bottom safe padding (prevents last item being hidden) ----
                SliverToBoxAdapter(child: SizedBox(height: 24 + mq.padding.bottom)),
              ],
            ),
          ),
        ),
      ),
    );
  }


}

// ===== Widgets =====
class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 2,
      shape: const StadiumBorder(),
      child: InkWell(
        customBorder: const StadiumBorder(),
        onTap: onTap,
        child: const SizedBox(width: 44, height: 44, child: Icon(Icons.arrow_back, color: Colors.black87)),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  const _SearchBar({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: TextField(
        controller: controller,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Search for 'Blood Test'",
          prefixIcon: const Icon(Icons.search, size: 22),
          filled: true,
          fillColor: _softGreenBG,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.green.shade200),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: Colors.green.shade200),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: _brandGreen, width: 1.4),
          ),
        ),
      ),
    );
  }
}

class _HeroPackageCard extends StatelessWidget {
  final LabPackage pkg;
  final int memberCount;
  final VoidCallback onMinus, onPlus, onBookNow;
    final Future<List<Map<String, dynamic>>> testdata; // ✅ define property

  const _HeroPackageCard({
    required this.pkg,
    required this.memberCount,
    required this.onMinus,
    required this.onPlus,
    required this.onBookNow, 
    required  this.testdata,
  });

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormatLikeNPR();
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade200, width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // ensures the card wraps content (no flex overflow)
        children: [
          // image + corner badges
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    pkg.image,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: _softGreenBG,
                      alignment: Alignment.center,
                      child: const Icon(Icons.image_not_supported, color: Colors.black26),
                    ),
                  ),
                ),
              ),
              if (pkg.topBadges.isNotEmpty)
                Positioned(
                  left: 10,
                  top: 10,
                  child: Wrap(
                    spacing: 6,
                    children: pkg.topBadges.map((b) => _YellowChip(text: b)).toList(),
                  ),
                ),
              if (pkg.discountPct > 0)
                Positioned(right: 10, top: 10, child: _DiscountPill(text: '${pkg.discountPct.toStringAsFixed(0)}% OFF')),
            ],
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + price
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        pkg.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: _brandGreen, fontSize: 20, fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(minWidth: 90),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(' ${currency.format(pkg.mrp)}',
                              style: const TextStyle(color: Colors.black54, fontSize: 12, decoration: TextDecoration.lineThrough)),
                          Text(' ${currency.format(pkg.price)}',
                              style: const TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.w800)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                // Text(pkg.codeLabel, style: const TextStyle(color: Colors.black54, fontSize: 12)),
              // FutureBuilder<List<Map<String, dynamic>>>(
              //   future: testdata,
              //   builder: (context, snapshot) {
              //     if (!snapshot.hasData) {
              //       return const Text("Loading...");
              //     }

              //     final related = snapshot.data!;

              //     return Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         Text("Includes: ${related.length} Tests"),

              //         // show each child product name
              //         for (var row in related)
              //           Text(row['url_code']?.toString() ?? "Unnamed"),
              //       ],
              //     );
              //   },
              // ),

              FutureBuilder<List<Map<String, dynamic>>>(
                future: testdata,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Text("Loading...");
                  }

                  final related = snapshot.data!;
                  final showAll = ValueNotifier(false); // controls expand/collapse

                  return ValueListenableBuilder<bool>(
                    valueListenable: showAll,
                    builder: (context, expanded, _) {
                      final itemsToShow = expanded
                          ? related
                          : related.take(4).toList(); // only first 4 if not expanded

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Includes: ${related.length} Tests"),

                          // show url_code list
                          for (var row in itemsToShow)
                            Text(
                              row['name']?.toString() ?? "Unnamed",
                              style: const TextStyle(
                                fontWeight: FontWeight.w600, // semi-bold, use FontWeight.bold if you want stronger
                                fontSize: 14,                // adjust size if needed
                                color: Colors.black,         // keep it dark for emphasis
                              ),
                            ),
                          // show "See more" / "See less" only if needed
                          if (related.length > 4)
                            GestureDetector(
                              onTap: () => showAll.value = !expanded,
                              child: Padding(
                                padding: const EdgeInsets.only(top: 4.0),
                                child: Text(
                                  expanded ? "See less" : "See more",
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      );
                    },
                  );
                },
              ),


                const SizedBox(height: 8),
                // Highlights
                // ...pkg.highlights.map(
                //   (h) => Padding(
                //     padding: const EdgeInsets.only(bottom: 6),
                //     child: Row(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         const SizedBox(width: 2),
                //         const Padding(padding: EdgeInsets.only(top: 6), child: Icon(Icons.circle, size: 6, color: Colors.black45)),
                //         const SizedBox(width: 8),
                //         Expanded(
                //           child: Text(h, softWrap: true, style: const TextStyle(fontSize: 13.5, color: Colors.black87, height: 1.3)),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                const SizedBox(height: 10),
                _MembersRow(count: memberCount, onMinus: onMinus, onPlus: onPlus),

                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255,55, 120, 83),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    onPressed: onBookNow,
                    child: const Text('BOOK NOW', style: TextStyle(fontWeight: FontWeight.w700)),
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

class _MembersRow extends StatelessWidget {
  final int count;
  final VoidCallback onMinus, onPlus;
  const _MembersRow({required this.count, required this.onMinus, required this.onPlus});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _SelectChip(icon: Icons.person, label: 'Myself', selected: true),
        const SizedBox(width: 10),
        // _SelectChip(icon: Icons.person_outline, label: 'Shanvi', selected: false),
        // const Spacer(),
        const Text('', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.black54)),
        const SizedBox(width: 8),
        _Counter(count: count, onMinus: onMinus, onPlus: onPlus),
      ],
    );
  }
}

class _SelectChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  const _SelectChip({required this.icon, required this.label, required this.selected});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: selected ? _softGreenBG : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: selected ? _brandGreen : Colors.black26),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: selected ? _brandGreen : Colors.black54),
          const SizedBox(width: 6),
          Text(label, style: TextStyle(color: selected ? _brandGreen : Colors.black87, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _Counter extends StatelessWidget {
  final int count;
  final VoidCallback onMinus, onPlus;
  const _Counter({required this.count, required this.onMinus, required this.onPlus});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(999), border: Border.all(color: Colors.black26)),
      child: Row(
        children: [
          _IconBtn(icon: Icons.remove, onTap: onMinus),
          Padding(padding: const EdgeInsets.symmetric(horizontal: 10), child: Text(count >= 2 ? '$count+' : '$count', style: const TextStyle(fontWeight: FontWeight.w700))),
          _IconBtn(icon: Icons.add, onTap: onPlus),
        ],
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _IconBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: SizedBox(width: 34, height: 34, child: Icon(icon, size: 18, color: Colors.black87)),
    );
  }
}

class _YellowChip extends StatelessWidget {
  final String text;
  const _YellowChip({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFFFF2B2), borderRadius: BorderRadius.circular(999), border: Border.all(color: const Color(0xFFFFE27A))),
      child: Text(text, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.black87)),
    );
  }
}

class _DiscountPill extends StatelessWidget {
  final String text;
  const _DiscountPill({required this.text});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: const Color(0xFFEFFCCF), borderRadius: BorderRadius.circular(999), border: Border.all(color: const Color(0xFFD9F28E))),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w800, color: Colors.black87, fontSize: 12)),
    );
  }
}

class _SuggestionCard extends StatelessWidget {
  final LabPackage pkg;
  final double width, imageH;
  const _SuggestionCard({required this.pkg, required this.width, required this.imageH});

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormatLikeNPR();
    return Container(
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.green.shade200, width: 1),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
            child: SizedBox(
              height: imageH,
              width: double.infinity,
              child: Image.network(
                pkg.image,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: _softGreenBG, alignment: Alignment.center, child: const Icon(Icons.image_not_supported, color: Colors.black26)),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(pkg.title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text('${pkg.testsCount} Tests', style: const TextStyle(fontSize: 12, color: Colors.black54)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  decoration: BoxDecoration(color: _softGreenBG, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.green.shade200)),
                  child: Text('EXCLUSIVE OFFER  ₹ ${currency.format(pkg.price)}',
                      maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: _brandGreen)),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: _brandGreen,
                      side: const BorderSide(color: _brandGreen, width: 1.2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    onPressed: () {},
                    child: const Text('BOOK NOW', style: TextStyle(fontWeight: FontWeight.w700)),
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

// ===== Tiny INR formatter (no intl dependency) =====
// class NumberFormatLikeINR {
//   String format(num n) {
//     final s = n.toStringAsFixed(0);
//     if (s.length <= 3) return s;
//     final last3 = s.substring(s.length - 3);
//     String rest = s.substring(0, s.length - 3);
//     final parts = <String>[];
//     while (rest.length > 2) {
//       parts.add(rest.substring(rest.length - 2));
//       rest = rest.substring(0, rest.length - 2);
//     }
//     if (rest.isNotEmpty) parts.add(rest);
//     final left = parts.reversed.join(',');
//     return '$left,$last3';
//   }
// }
class NumberFormatLikeNPR {
  String format(num n) {
    final s = n.toStringAsFixed(0);
    if (s.length <= 3) return "Rs $s";
    final last3 = s.substring(s.length - 3);
    String rest = s.substring(0, s.length - 3);
    final parts = <String>[];
    while (rest.length > 2) {
      parts.add(rest.substring(rest.length - 2));
      rest = rest.substring(0, rest.length - 2);
    }
    if (rest.isNotEmpty) parts.add(rest);
    final left = parts.reversed.join(',');
    return 'Rs $left,$last3';
  }
}

