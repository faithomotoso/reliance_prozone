import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:reliance_hmo_test/business_logic/models/image/HMOProviderImage.dart';
import 'package:reliance_hmo_test/ui/components/AppBar.dart';
import 'package:reliance_hmo_test/utils/utils.dart';

import 'NetworkImagePreview.dart';

class ProviderImagesManager extends StatefulWidget {
  List<HMOProviderImage> providerImages;

  ProviderImagesManager({@required this.providerImages})
      : assert(providerImages != null);

  @override
  _ProviderImagesManagerState createState() => _ProviderImagesManagerState();
}

class _ProviderImagesManagerState extends State<ProviderImagesManager> {
  List<HMOProviderImage> providerImages;

  @override
  void initState() {
    super.initState();
    providerImages = widget.providerImages;
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
      children: List<Widget>.from(providerImages
          .map((e) => networkImagePreview(e))
          .toList()..add(addImageButton()),),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
    );
  }

  Widget networkImagePreview(HMOProviderImage image) {
    return NetworkImagePreview(image: image);
  }

  Widget addImageButton() {
    return TextButton(onPressed: (){}, child: Icon(Icons.add));
  }
}
