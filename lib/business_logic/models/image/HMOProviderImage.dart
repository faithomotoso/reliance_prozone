class HMOProviderImage {
  String _id;
  String _name;
  String _url;
  String _alternativeText;
  String _caption;
  double _width;
  double _height;
  HMOProviderImageFormats _imageFormats;

  String get id => _id;
  String get name => _name;
  String get url => _url;
  HMOProviderImageFormats get imageFormats => _imageFormats;
}

class HMOProviderImageFormats {
  ImageFormat largeImageFormat;
  ImageFormat smallImageFormat;
  ImageFormat mediumImageFormat;
  ImageFormat thumbnailImageFormat;

  HMOProviderImageFormats.fromJson(Map<String, Map> json) {
    largeImageFormat = ImageFormat.fromJson(json["large"]);
    smallImageFormat = ImageFormat.fromJson(json["small"]);
    mediumImageFormat = ImageFormat.fromJson(json["medium"]);
    thumbnailImageFormat = ImageFormat.fromJson(json["thumbnail"]);
  }
}

class ImageFormat{
  String _url;
  double _width;
  double _height;

  String get url => _url;

  ImageFormat.fromJson(Map<String, dynamic> json) {
    this._url = json["url"];
    this._width = json["width"];
    this._height = json["height"];
  }
}