class ProvincePositionParam {
  final String name;
  final List<double> position;
  ProvincePositionParam({required this.name, required this.position});
  Map<String, dynamic> toJson() => {'name': name, 'position': position};
}
