class HairService {
  final String name;
  final String price;

  const HairService({
    required this.name,
    required this.price,
  });
}

class ServiceData {
  static const List<HairService> hairStyles = [
    HairService(name: "Undercut", price: "120.000đ"),
    HairService(name: "Side Part", price: "100.000đ"),
    HairService(name: "Layer Hàn Quốc", price: "150.000đ"),
    HairService(name: "Mohican", price: "130.000đ"),
  ];

  static const List<HairService> dyeStyles = [
    HairService(name: "Nhuộm nâu tây", price: "350.000đ"),
    HairService(name: "Nhuộm xám khói", price: "450.000đ"),
    HairService(name: "Nhuộm xanh rêu", price: "400.000đ"),
    HairService(name: "Highlight", price: "250.000đ"),
  ];

  static const List<HairService> curlStyles = [
    HairService(name: "Uốn Side Part", price: "250.000đ"),
    HairService(name: "Uốn con sâu", price: "300.000đ"),
    HairService(name: "Uốn phồng Layer", price: "200.000đ"),
    HairService(name: "Uốn Preppy", price: "280.000đ"),
  ];
}
