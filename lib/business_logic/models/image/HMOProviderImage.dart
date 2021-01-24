class HMOProviderImage {
  String _id;
  String _name;
  String _url;
  String _alternativeText;
  String _caption;
  num _width;
  num _height;
  HMOProviderImageFormats _imageFormats;

  String get id => _id;

  String get name => _name;

  String get url => _url;

  HMOProviderImageFormats get imageFormats => _imageFormats;

  HMOProviderImage.fromJson(Map<String, dynamic> json) {
    this._id = json["id"].toString();
    this._name = json["name"];
    this._url = json["url"];
    this._width = json["width"];
    this._height = json["height"];
    this._imageFormats = HMOProviderImageFormats.fromJson(json["formats"]);
  }
}

class HMOProviderImageFormats {
  ImageFormat largeImageFormat;
  ImageFormat smallImageFormat;
  ImageFormat mediumImageFormat;
  ImageFormat thumbnailImageFormat;

  HMOProviderImageFormats.fromJson(Map<String, dynamic> json) {
    if (json.containsKey("large"))
      largeImageFormat = ImageFormat.fromJson(json["large"]);

    if (json.containsKey("small"))
      smallImageFormat = ImageFormat.fromJson(json["small"]);

    if (json.containsKey("medium"))
      mediumImageFormat = ImageFormat.fromJson(json["medium"]);

    if (json.containsKey("thumbnail"))
      thumbnailImageFormat = ImageFormat.fromJson(json["thumbnail"]);
  }
}

class ImageFormat {
  String _url;
  num _width;
  num _height;

  String get url => _url;

  ImageFormat.fromJson(Map<String, dynamic> json) {
    this._url = json["url"];
    this._width = json["width"];
    this._height = json["height"];
  }
}
