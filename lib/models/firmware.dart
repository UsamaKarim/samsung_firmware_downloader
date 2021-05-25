class Firmware {
  const Firmware({
    required this.latest,
    required this.alternate,
  });

  final String? latest;
  final List<String>? alternate;

  factory Firmware.fromJson(Map<String, dynamic> json) => Firmware(
        latest: json["latest"],
        alternate: List<String>.from(json["alternate"].map((x) => x)),
      );
}
