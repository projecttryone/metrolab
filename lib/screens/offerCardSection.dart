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
    return Container(
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
          const SizedBox(height: 8),
          LayoutBuilder(
            builder: (context, constraints) {
              // about 2 cards visible like your screenshot
              final double cardWidth = constraints.maxWidth * 0.46;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(offers.length, (i) {
                    final offer = offers[i];
                    final targetTab = (i < offerToTab.length)
                        ? offerToTab[i]
                        : 0;

                    return Container(
                      width: cardWidth,
                      margin: const EdgeInsets.symmetric(horizontal: 6),
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
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
class _OfferCard extends StatelessWidget {
  final String imagePath;
  final String discount; // kept for model compatibility, not used visually
  final String title;    // kept for compatibility
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => tabController.animateTo(tabIndex),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18),
        child: AspectRatio(
          // wide “button” like in your screenshot
          aspectRatio: 2.6, // tweak if you want a bit taller/shorter
          child: Image.asset(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

