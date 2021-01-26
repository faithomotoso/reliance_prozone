import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:reliance_hmo_test/business_logic/models/image/HMOProviderImage.dart';
import 'package:reliance_hmo_test/ui/components/image_view/ImagePageIndicator.dart';

class ImagePreview extends StatefulWidget {
  final List<HMOProviderImage> providerImages;

  ImagePreview({@required this.providerImages});

  @override
  _ImagePreviewState createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  int page = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              PhotoViewGallery.builder(
                itemCount: widget.providerImages.length,
                onPageChanged: (newPage) {
                  setState(() {
                    page = newPage;
                  });
                },
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
                          ? progress.cumulativeBytesLoaded /
                          progress.expectedTotalBytes
                          : null,
                    ),
                  );
                },
              ),
              Positioned(
                  bottom: 10,
                  child: ConstrainedBox(
                    constraints: constraints.copyWith(minHeight: 10),
                    child: ImagePageIndicator(
                        page: page, maxPage: widget.providerImages.length),
                  ))
            ],
          );
        },
      ),
    );
  }
}
