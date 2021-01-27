import 'package:reliance_hmo_test/business_logic/models/ActiveStatus.dart';
import 'package:reliance_hmo_test/business_logic/models/image/HMOProviderImage.dart';
import 'file:///C:/Users/user/AndroidStudioProjects/reliance_hmo_test/lib/business_logic/HMOProviderType.dart';
import 'package:reliance_hmo_test/business_logic/models/state/NState.dart';

class HMOProvider {
  String _id;
  String _name;
  String _description;
  int _rating;
  String _address;
  ActiveStatus _activeStatus; // Active or Pending.
  HMOProviderType _providerType;
  NState _state;
  List<HMOProviderImage> _images = [];

  String get id => _id;

  String get name => _name;

  String get description => _description;

  int get rating => _rating;

  String get address => _address;

  ActiveStatus get activeStatus => _activeStatus;

  HMOProviderType get providerType => _providerType;

  NState get state => _state;

  List<HMOProviderImage> get images => _images;

  String get thumbnailImageUrl {
    // Return the thumbnail url of the first image
    // Return null if empty
    return _images.isNotEmpty ? _images.first.thumbnailUrl : null;
  }

  HMOProvider.fromJson(Map<String, dynamic> json) {
    this._id = json["id"].toString();
    this._name = json["name"];
    this._description = json["description"];
    this._rating = json["rating"] ?? 0; // Default to 0 if null
    this._address = json["address"];
    this._activeStatus = ActiveStatus(json["active_status"]);
    this._providerType = HMOProviderType.fromJson(json["provider_type"]);
    this._state = NState.fromJson(json["state"]);
    List imgs = json["images"] ?? [];
    if (imgs.isNotEmpty) {
      _images =
          List<HMOProviderImage>.from(imgs.map((e) => HMOProviderImage.fromJson(e)));
    }
  }
}
