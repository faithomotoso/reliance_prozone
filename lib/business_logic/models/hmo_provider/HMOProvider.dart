import 'package:reliance_hmo_test/business_logic/models/image/HMOProviderImage.dart';
import 'package:reliance_hmo_test/business_logic/models/image/HMOProviderType.dart';
import 'package:reliance_hmo_test/business_logic/models/state/NState.dart';

class HMOProvider {
  String _id;
  String _name;
  String _description;
  int _rating;
  String _address;
  String _activeStatus; // Active or Pending.
  HMOProviderType _providerType;
  NState _state;
  List<HMOProviderImage> _images = [];

  String get id => _id;

  String get name => _name;

  String get description => _description;

  int get rating => _rating;

  String get address => _address;

  String get activeStatus => _activeStatus;

  HMOProviderType get providerType => _providerType;

  NState get state => _state;

  List<HMOProviderImage> get images => _images;

  HMOProvider.fromJson(Map<String, dynamic> json) {
    this._id = json["id"];
    this._name = json["name"];
    this._description = json["description"];
    this._rating = json["rating"] ?? 0; // Default to 0 if null
    this._address = json["address"];
    this._activeStatus = json["active_status"];
    this._providerType = HMOProviderType.fromJson(json["provider_type"]);
    this._state = NState.fromJson(json["state"]);
    List imgs = json["images"] ?? [];
    if (imgs.isNotEmpty) {
      _images =
          List<HMOProviderImage>.from(imgs.map((e) => HMOProvider.fromJson(e)));
    }
  }
}
