import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:reliance_hmo_test/business_logic/models/hmo_provider/HMOProvider.dart';
import 'package:reliance_hmo_test/ui/components/Ratings.dart';
import 'package:reliance_hmo_test/ui/hmo_providers/add_edit_hmo_provider.dart';
import 'package:reliance_hmo_test/utils/utils.dart';

class HMOProviderTile extends StatelessWidget {
  final HMOProvider hmoProvider;

  HMOProviderTile({@required this.hmoProvider});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        navigate(
            context: context,
            newPage: AddEditHMOProvider(hmoProvider: hmoProvider));
      },
      leading: providerImage(),
      title: Text(
        hmoProvider.name,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      subtitle: subtitle(),
    );
  }

  Widget providerImage() {
    return hmoProvider.thumbnailImageUrl != null
        ? ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: hmoProvider.thumbnailImageUrl,
              width: 60,
              fit: BoxFit.fill,
              progressIndicatorBuilder: (context, _, progress) {
                return Center(
                  child: Theme(
                    data: Theme.of(context)..accentColor.withOpacity(0.3),
                    child: CircularProgressIndicator(
                      value: progress.progress,
                    ),
                  ),
                );
              },
            ),
          )
        : SizedBox(
            width: 60,
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey.withOpacity(0.3),
            ),
          );
  }

  Widget subtitle() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          hmoProvider.description ?? "",
        ),
        Ratings(rating: hmoProvider.rating)
      ],
    );
  }
}
