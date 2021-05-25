class CSC {
  const CSC({
    required this.regionCode,
    required this.regionName,
  });
  final String? regionCode;
  final String? regionName;

  factory CSC.fromJson(String? keys, String? values) {
    return CSC(regionCode: keys, regionName: values);
  }
  @override
  String toString() {
    return '$regionName ($regionCode)';
  }
}
