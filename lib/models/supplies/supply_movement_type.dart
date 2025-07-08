enum SupplyMovementType {
  IN(
    en: 'in',
    ar: 'وارد',
  ),
  OUT(
    en: 'out',
    ar: 'صادر',
  );

  final String en;
  final String ar;

  const SupplyMovementType({
    required this.en,
    required this.ar,
  });
}
