import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:reliance_hmo_test/business_logic/models/hmo_provider/HMOProvider.dart';
import 'package:reliance_hmo_test/business_logic/models/image/HMOProviderImage.dart';
import 'package:reliance_hmo_test/ui/components/image_view/ImagePageIndicator.dart';
import 'package:reliance_hmo_test/ui/components/image_view/ProviderImagesManager.dart';
import 'package:reliance_hmo_test/utils/utils.dart';

class ProviderImagesPreview extends StatefulWidget {
  final HMOProvider hmoProvider;
  final bool showPreview;

  ProviderImagesPreview({@required this.hmoProvider, this.showPreview = true});

  @override
  _ProviderImagesPreviewState createState() => _ProviderImagesPreviewState();
}

class _ProviderImagesPreviewState extends State<ProviderImagesPreview> {
  int page = 0;
  PhotoViewController photoViewController = PhotoViewController();
  List<HMOProviderImage> providerImages;


  @override
  void initState() {
    super.initState();
    providerImages = widget.hmoProvider?.images;
  }

  @override
  Widget build(BuildContext context) {
    // Don't show this widget when creating a provider
    if (widget.hmoProvider == null) return SizedBox();

    return widget.showPreview ? preview() : fullScreen();
  }

  Widget preview() {
    // Shows with the header and edit button
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Images",
              style: Theme.of(context)
                  .textTheme
                  .headline6
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            if (providerImages.isNotEmpty)
              Center(
                child: TextButton(
                  child: Text("Edit",
                  style: TextStyle(fontSize: 16),),
                  onPressed: () {
                    navigateToImagesManager();
                  },
                ),
              )
          ],
        ),
        SizedBox(
          height: 5,
        ),
        GestureDetector(
          onTap: providerImages.isEmpty ? navigateToImagesManager : null,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.5,
            decoration: BoxDecoration(
                color: providerImages.isNotEmpty
                    ? Colors.transparent
                    : Colors.grey.withOpacity(0.05)),
            child: providerImages.isNotEmpty
                ? imageView()
                : noImagesWidget(),
          ),
        ),
      ],
    );
  }

  Widget imageView() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: [
            PhotoViewGallery.builder(
              itemCount: providerImages.length,
              onPageChanged: (newPage) {
                setState(() {
                  page = newPage;
                });
              },
              builder: (context, index) {
                return PhotoViewGalleryPageOptions(
                  imageProvider: CachedNetworkImageProvider(
                    providerImages[index].mediumImageUrl,
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
                  constraints:
                  constraints.copyWith(minHeight: 10),
                  child: ImagePageIndicator(
                      page: page,
                      maxPage: providerImages.length),
                ))
          ],
        );
      },
    );
  }

  Widget fullScreen() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      child: imageView()
    );
  }

  Widget noImagesWidget() {
    return Center(
      child: Text(
        "No images\nTap to add",
      ),
    );
  }

  void navigateToImagesManager() {
    navigate(
        context: context,
        newPage: ProviderImagesManager(hmoProvider: widget.hmoProvider));
  }
}
