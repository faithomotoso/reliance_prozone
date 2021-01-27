import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';
import 'package:reliance_hmo_test/business_logic/models/hmo_provider/HMOProvider.dart';
import 'package:reliance_hmo_test/business_logic/models/image/HMOProviderImage.dart';
import 'package:reliance_hmo_test/business_logic/view_models/AppViewModel.dart';
import 'package:reliance_hmo_test/ui/components/AppBar.dart';
import 'package:reliance_hmo_test/ui/components/AppButton.dart';
import 'package:reliance_hmo_test/ui/components/image_view/SelectedImageView.dart';
import 'package:reliance_hmo_test/utils/dialogs.dart';
import 'package:reliance_hmo_test/utils/utils.dart';

import 'NetworkImagePreview.dart';

class ProviderImagesManager extends StatefulWidget {
  HMOProvider hmoProvider;

  ProviderImagesManager({@required this.hmoProvider})
      : assert(hmoProvider != null);

  @override
  _ProviderImagesManagerState createState() => _ProviderImagesManagerState();
}

class _ProviderImagesManagerState extends State<ProviderImagesManager> {
  AppViewModel appViewModel;
  List<HMOProviderImage> providerImages;
  ValueNotifier<List<Asset>> selectedImages = ValueNotifier<List<Asset>>([]);
  GlobalKey<ScaffoldState> scaffoldDialogKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    providerImages = widget.hmoProvider.images;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (appViewModel == null) Provider.of<AppViewModel>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        title: "Provider Images",
      ),
      body: body(),
    );
  }

  Widget body() {
    // Builds a gridview of all available images
    return GridView.count(
      crossAxisCount: 2,
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      children: List<Widget>.from(
        providerImages.map((e) => networkImagePreview(e)).toList()
          ..add(addImageButton()),
      ),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
    );
  }

  Widget networkImagePreview(HMOProviderImage image) {
    return NetworkImagePreview(image: image);
  }

  Widget addImageButton() {
    return TextButton(
        onPressed: () {
          selectImagesFromStorage();
        },
        child: Icon(Icons.add));
  }

  Future selectImagesFromStorage() async {
    // selectedImages.value.clear();

    try {
      selectedImages.value = await MultiImagePicker.pickImages(
        maxImages: 5,
      );

      showImageSelectionDialog();
    } catch (e) {
      debugPrint(e);
    }
  }

  void showImageSelectionDialog() {
    showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            backgroundColor: Colors.transparent,
            key: scaffoldDialogKey,
            body: ValueListenableBuilder<List<Asset>>(
              valueListenable: selectedImages,
              builder: (context, images, child) {
                return Align(
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width * 0.85,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: appBorderRadius
                    ),
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 5),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Images to upload",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            CloseButton()
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Expanded(
                          child: GridView.count(
                            crossAxisCount: 2,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                            children: List<Widget>.from(
                                images.map((e) => _loadAssetImage(e))),
                          ),
                        ),
                        if (images.length < 5)
                          Center(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 5,
                                ),
                                TextButton(
                                    onPressed: () async {
                                      // add more images
                                      try {
                                        List<Asset> newImages =
                                            await MultiImagePicker.pickImages(
                                                maxImages: 5 - images.length);

                                        selectedImages.value =
                                            List<Asset>.from([])
                                              ..addAll(images)
                                              ..addAll(newImages);
                                      } on Exception catch (e) {
                                        debugPrint(e.toString());
                                      }
                                    },
                                    child: Text(
                                        "Add ${images.isNotEmpty ? "more" : "images"}"))
                              ],
                            ),
                          ),
                        SizedBox(
                          height: 10,
                        ),
                        if (images.isNotEmpty)
                          Center(
                              child: AppButton(
                                  buttonText:
                                      "Upload Image${images.length > 1 ? "s" : ""}",
                                  onPressed: () async {
                                    await Provider.of<AppViewModel>(context, listen: false).uploadProviderImages(
                                        hmoProvider: widget.hmoProvider,
                                        images: selectedImages.value,
                                        context: context,
                                    scaffoldKey: scaffoldDialogKey);
                                    // Rebuild the entire tree with new images added
                                    setState(() {
                                      providerImages = widget.hmoProvider.images;
                                    });
                                  },
                                  context: context))
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        });
  }

  Widget _loadAssetImage(Asset asset) {
    return GestureDetector(
        onTap: () {
          showRemoveSelectedImageDialog(asset);
        },
        child: SelectedImageView(asset: asset, width: 100, height: 100));
  }

  void showRemoveSelectedImageDialog(Asset asset) {
    showYesNoDialog(
        context: context,
        message: "Deselect this image?",
        noPressed: () => Navigator.pop(context),
        yesPressed: () {
          selectedImages.value = List<Asset>.from(selectedImages.value
            ..removeWhere((element) => element.identifier == asset.identifier));
          Navigator.pop(context);
        });
  }

}
