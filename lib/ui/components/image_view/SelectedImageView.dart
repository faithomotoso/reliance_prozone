import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/src/asset.dart';

class SelectedImageView extends StatefulWidget {
  /// The asset we want to show thumb for.
  final Asset asset;

  final int width;

  final int height;

  const SelectedImageView({
    Key key,
    @required this.asset,
    @required this.width,
    @required this.height,
  }) : super(key: key);

  @override
  _SelectedImageViewState createState() => _SelectedImageViewState();
}

class _SelectedImageViewState extends State<SelectedImageView> {
  ByteData _thumbData;

  int get width => widget.width;

  int get height => widget.height;

  Asset get asset => widget.asset;

  @override
  void initState() {
    super.initState();
    this._loadThumb();
  }

  @override
  void didUpdateWidget(SelectedImageView oldWidget) {
    if (oldWidget.asset.identifier != widget.asset.identifier) {
      this._loadThumb();
    }
    super.didUpdateWidget(oldWidget);
  }

  void _loadThumb() async {
    setState(() {
      _thumbData = null;
    });

    ByteData thumbData = await asset.getByteData(quality: 100);

    if (this.mounted) {
      setState(() {
        _thumbData = thumbData;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_thumbData == null) {
      return Center(child: CircularProgressIndicator(),);
    }
    return Image.memory(
      _thumbData.buffer.asUint8List(),
      key: ValueKey(asset.identifier),
      fit: BoxFit.cover,
      gaplessPlayback: true,
    );
  }
}
