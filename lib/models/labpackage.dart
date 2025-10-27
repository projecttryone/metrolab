class LabPackage {
  final String id, title, codeLabel, image;
  final double mrp, price, discountPct;
  final int testsCount;
  final List<String> highlights, topBadges, suggestionIds;
  LabPackage({
    required this.id,
    required this.title,
    required this.codeLabel,
    required this.mrp,
    required this.price,
    required this.testsCount,
    required this.highlights,
    required this.topBadges,
    required this.image,
    required this.discountPct,
    required this.suggestionIds,
  });
}