class HMOProviderType {
  String _id;
  String _name;

  String get id => _id;
  String get name => _name;

  HMOProviderType.fromJson(Map<String, dynamic> json) {
    this._id = json["id"];
    this._name = json["name"];
  }
}