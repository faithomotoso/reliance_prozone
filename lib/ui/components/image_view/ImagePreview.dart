import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:reliance_hmo_test/business_logic/models/image/HMOProviderImage.dart';

class ImagePreview extends StatefulWidget {
  final List<HMOProviderImage> providerImages;

  ImagePreview({@required this.providerImages});

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: PhotoViewGallery.builder(
        itemCount: widget.providerImages.length,
        builder: (context, index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(
              widget.providerImages[index].mediumImageUrl,
            ),
            minScale: 0.5,
          );
        },
        loadFailedChild: Center(
          child: Icon(
            Icons.broken_image_outlined,
            size: 10,
            color: Colors.blueGrey,
          ),
        ),
        loadingBuilder: (context, progress) {
          return Center(
            child: CircularProgressIndicator(
              value: progress != null
                  ? progress.cumulativeBytesLoaded / progress.expectedTotalBytes
                  : null,
            ),
          );
        },
      ),
    );
  }
}
