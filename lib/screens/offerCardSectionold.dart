import 'package:flutter/material.dart';

class Offer {
  final String imagePath;
  final String discount;
  final String title;

  Offer({
    required this.imagePath,
    required this.discount,
    required this.title,
  });
}

class OfferCardSection extends StatelessWidget {
  final List<Offer> offers;
  final TabController tabController;
  // Optional: map each offer index -> tab index (Hearts=1, Kidney=2, Brain=3)
  final List<int> offerToTab;

  // Static banners inside this widget for now
  final List<String> banners = const [
    'assets/offer/banner1.png',
  ];

  const OfferCardSection({
    Key? key,
    required this.offers,
    required this.tabController,
    this.offerToTab = const [1, 2],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (offers.length != 3) return const SizedBox.shrink();

    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.07),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (banners.isNotEmpty) ...[
              const SizedBox(height: 8),
              SizedBox(
                height: 140,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: banners.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemBuilder: (context, i) => ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      banners[i],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ],
            LayoutBuilder(
              builder: (context, constraints) {
                final double cardWidth = (constraints.maxWidth - 32) / 3;
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(offers.length, (i) {
                      final offer = offers[i];
                      final targetTab = (i < offerToTab.length)
                          ? offerToTab[i]
                          : 0; // fallback to first tab if out of range
                      return Container(
                        width: cardWidth,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        child: _OfferCard(
                          imagePath: offer.imagePath,
                          discount: offer.discount,
                          title: offer.title,
                          tabController: tabController,
                          tabIndex: targetTab,
                        ),
                      );
                    }),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _OfferCard extends StatelessWidget {
  final String imagePath;
  final String discount;
  final String title;
  final TabController tabController;
  final int tabIndex;

  const _OfferCard({
    Key? key,
    required this.imagePath,
    required this.discount,
    required this.title,
    required this.tabController,
    required this.tabIndex,
  }) : super(key: key);

  // @override
  // Widget build(BuildContext context) {
  //   return GestureDetector(
  //     onTap: () => tabController.animateTo(tabIndex),
  //     child: AspectRatio(
  //       aspectRatio: 3 / 3, // Keeps cards proportional
  //       child: Container(
  //         padding: const EdgeInsets.all(8),
  //         decoration: BoxDecoration(
  //           color: const Color(0xB17CD57F), // dark green background
  //           borderRadius: BorderRadius.circular(18),
  //           boxShadow: const [
  //             BoxShadow(
  //               color: Colors.black12,
  //               blurRadius: 4,
  //               offset: Offset(2, 2),
  //             )
  //           ],
  //         ),
  //         child: Column(
  //           crossAxisAlignment: CrossAxisAlignment.center,
  //           children: [
  //             Expanded(
  //               flex: 3,
  //               child: Image.asset(
  //                 imagePath,
  //                 fit: BoxFit.contain,
  //               ),
  //             ),
  //             const SizedBox(height: 6),
  //             Container(
  //               padding:
  //                   const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
  //               decoration: BoxDecoration(
  //                 color: const Color.fromARGB(255, 34, 107, 57),
  //                 borderRadius: BorderRadius.circular(12),
  //               ),
  //               child: FittedBox(
  //                 fit: BoxFit.scaleDown,
  //                 child: Text(
  //                   discount,
  //                   maxLines: 1,
  //                   style: const TextStyle(
  //                     fontWeight: FontWeight.bold,
  //                     fontSize: 14,
  //                     color: Color.fromARGB(255, 234, 231, 231),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 4),
  //             Expanded(
  //               flex: 1,
  //               child: Center(
  //                 child: FittedBox(
  //                   fit: BoxFit.scaleDown,
  //                   child: Text(
  //                     title,
  //                     textAlign: TextAlign.center,
  //                     style: const TextStyle(
  //                       fontWeight: FontWeight.w500,
  //                       fontSize: 12,
  //                       color: Color.fromARGB(221, 7, 7, 7),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }

@override
Widget build(BuildContext context) {
  return GestureDetector(
    onTap: () => tabController.animateTo(tabIndex),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Image card + overlapping discount pill
        Stack(
          clipBehavior: Clip.none, // allow pill to overflow
          children: [
            AspectRatio(
              aspectRatio: 3 / 3, // keep your square card
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 167, 221, 186),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                child: Center(
                  child: Image.asset(imagePath, fit: BoxFit.contain),
                ),
              ),
            ),

            // Pill badge half outside
            Positioned(
              left: 0,
              right: 0,
              bottom: -12, // half out of the green card
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 34, 107, 57),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
                    ],
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      discount,
                      maxLines: 1,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 18), // room for the overlapping pill

        // Title outside (below), centered
        SizedBox(
          width: 140, // optional: helps wrap nicely like your screenshot
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.center,
            child: Text(
              title,
              textAlign: TextAlign.center,
              maxLines: 2,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Color.fromARGB(221, 7, 7, 7),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


}
