import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:reliance_hmo_test/business_logic/models/image/HMOProviderImage.dart';
import 'package:reliance_hmo_test/ui/components/AppButton.dart';

class NetworkImagePreview extends StatefulWidget {
  final HMOProviderImage image;

  NetworkImagePreview({@required this.image}) : assert(image != null);

  @override
  _NetworkImagePreviewState createState() => _NetworkImagePreviewState();
}

class _NetworkImagePreviewState extends State<NetworkImagePreview> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showFullImage(CachedNetworkImageProvider(widget.image.mediumImageUrl));
      },
      child: Hero(
          tag: widget.image, child: cachedNetworkImage()),
    );
  }

  Widget cachedNetworkImage() {
    return CachedNetworkImage(
        imageUrl: widget.image.mediumImageUrl,
        progressIndicatorBuilder: (context, _, progress) {
          return Center(
            child: CircularProgressIndicator(
              value: progress.progress,
            ),
          );
        });
  }

  void showFullImage(CachedNetworkImageProvider imageProvider) {
    showDialog(
        context: context,
        barrierColor: Colors.black,
        barrierDismissible: false,
        builder: (context) {
          return Material(
            color: Colors.black,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: Stack(
                    children: [
                      PhotoView(
                        imageProvider: imageProvider,
                        heroAttributes: PhotoViewHeroAttributes(tag: widget.image),
                      ),
                      BackButton(color: Colors.white,),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 10,
                // ),
                // Center(
                //   child: AppButton(
                //     buttonText: "Delete",
                //     onPressed: () {
                //       print(widget.image.id);
                //     },
                //     context: context,
                //     buttonColor: Colors.redAccent,
                //     textColor: Colors.white,
                //   ),
                // )
              ],
            ),
          );
        });
  }
}
