class Device {
  Device({
    required this.name,
    required this.model,
  });

  final String? name;
  final String? model;

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        name: json["name"],
        model: json["model"],
      );

  @override
  String toString() {
    return '$name ($model)';
  }
}
