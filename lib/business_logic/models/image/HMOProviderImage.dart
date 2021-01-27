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

  // todo remove unused url
  String get url => _url;

  String get thumbnailUrl {
    // Return image url for thumbnail, if thumbnail isn't available
    // return image url for small and so on...

    return _imageFormats?.thumbnailImageFormat?.url ??
        _imageFormats?.smallImageFormat?.url ??
        _imageFormats?.mediumImageFormat?.url ??
        _imageFormats?.largeImageFormat?.url;
  }

  String get mediumImageUrl {
    // Returns the url for medium, lower quality, smaller data usage
    // If medium is unavailable, return large or small
    return _imageFormats?.mediumImageFormat?.url ??
        _imageFormats?.largeImageFormat?.url ??
        _imageFormats?.smallImageFormat?.url ?? _url;
  }

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
