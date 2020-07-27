abstract class Mappable {
  factory Mappable.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }

  factory Mappable.fromNetworkMap(Map<String, dynamic> map) {
    throw UnimplementedError();
  }

  Map<String, dynamic> toMap();
}