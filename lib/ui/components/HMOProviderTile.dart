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
      leading: SizedBox(),
      title: Text(
        hmoProvider.name,
        style: Theme.of(context).textTheme.bodyText1,
      ),
      subtitle: subtitle(),
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
