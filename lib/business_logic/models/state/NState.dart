// Using NState because State is a keyword
class NState {
  String _id;
  String _name;

  String get id => _id;
  String get name => _name;

  NState.fromJson(Map<String, dynamic> json) {
    this._id = json["id"].toString();
    this._name = json["name"];
  }
}