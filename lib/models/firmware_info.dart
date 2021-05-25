class FirmwareDetail {
  const FirmwareDetail({
    required this.filename,
    required this.version,
    required this.sizeReadable,
  });

  final String? filename;
  final String? version;
  final String? sizeReadable;

  factory FirmwareDetail.fromJson(Map<String, dynamic> json) => FirmwareDetail(
        filename: json["filename"],
        version: json["version"],
        sizeReadable: json["size_readable"],
      );
}
