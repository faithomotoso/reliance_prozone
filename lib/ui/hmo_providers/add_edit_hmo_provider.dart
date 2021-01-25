import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reliance_hmo_test/business_logic/models/ActiveStatus.dart';
import 'package:reliance_hmo_test/business_logic/models/hmo_provider/HMOProvider.dart';
import 'package:reliance_hmo_test/business_logic/models/image/HMOProviderType.dart';
import 'package:reliance_hmo_test/business_logic/models/state/NState.dart';
import 'package:reliance_hmo_test/business_logic/view_models/AppViewModel.dart';
import 'package:reliance_hmo_test/ui/EditableRating.dart';
import 'package:reliance_hmo_test/ui/components/ActiveStatusWidget.dart';
import 'package:reliance_hmo_test/ui/components/AppBar.dart';
import 'package:reliance_hmo_test/ui/components/AppFutureBuilder.dart';
import 'package:reliance_hmo_test/ui/components/StatesWidget.dart';
import 'package:reliance_hmo_test/ui/components/TextFieldHeader.dart';
import 'package:reliance_hmo_test/ui/components/image_view/ImagePreview.dart';

class AddEditHMOProvider extends StatefulWidget {
  final HMOProvider hmoProvider;

  AddEditHMOProvider({@required this.hmoProvider});

  @override
  _AddEditHMOProviderState createState() => _AddEditHMOProviderState();
}

class _AddEditHMOProviderState extends State<AddEditHMOProvider> {
  HMOProvider hmoProvider;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  ActiveStatus selectedActiveStatus;
  num selectedRating;

  Future statesFuture;
  List<NState> states;
  NState selectedState;

  Future providersFuture;
  List<HMOProviderType> providerTypes;
  HMOProviderType selectedProviderType;

  Future futureWait;

  void getStates() {
    statesFuture = Provider.of<AppViewModel>(context, listen: false)
        .getAllStates()
        .then((value) {
      if (value is List)
        states = value;

      return value;
    });
  }

  void getProviderTypes() {
    providersFuture = Provider.of<AppViewModel>(context, listen: false)
        .getAllProviderTypes()
        .then((value) {
      if (value is List)
        providerTypes = value;
      return value;
    });
  }

  void assignFutureWait() {
    loadLists();
    futureWait = Future.wait([statesFuture, providersFuture]);
  }

  // Calls both functions tied to Future variables
  // for Future.wait assignment in the AppFutureBuilder
  void loadLists() {
    getStates();
    getProviderTypes();
  }

  @override
  void initState() {
    super.initState();
    // loadLists();
    assignFutureWait();

    if (widget.hmoProvider != null) {
      hmoProvider = widget.hmoProvider;
      nameController.text = hmoProvider.name;
      descriptionController.text = hmoProvider.description;
      addressController.text = hmoProvider.address;
      selectedActiveStatus = hmoProvider.activeStatus;
      selectedRating = hmoProvider.rating;
      selectedState = hmoProvider.state;
      selectedProviderType = hmoProvider.providerType;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:
      appBar(title: hmoProvider != null ? "Edit Provider" : "Add Provider"),
      body: AppFutureBuilder(
        future: futureWait,
        onReload: () {
          setState(() {
            assignFutureWait();
          });
        },
        onData: (data) {
          return Form(
            key: formKey,
            child: ListView(
              padding: const EdgeInsets.all(10),
              children: [
                TextFieldWHeader(
                    header: "Name", textEditingController: nameController),
                listVerticalSpace,
                TextFieldWHeader(
                    header: "Description",
                    textEditingController: descriptionController),
                listVerticalSpace,
                imageWidget(),
                listVerticalSpace,
                TextFieldWHeader(
                    header: "Address",
                    textEditingController: addressController),
                listVerticalSpace,
                ratings(),
                listVerticalSpace,
                ActiveStatusWidget(
                    activeStatus: selectedActiveStatus,
                    onStatusSelected: (status) {
                      setState(() {
                        selectedActiveStatus = status;
                      });
                    }),
                listVerticalSpace,
                StatesWidget(
                  selectedState: selectedState,
                  onStateSelected: (state) {
                    setState(() {
                      selectedState = state;
                    });
                  },
                  states: states,
                )
              ],
            ),
          );
        },
      ),
    );
  }

  SizedBox get listVerticalSpace =>
      SizedBox(
        height: 14,
      );

  Widget ratings() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rating",
          style: Theme
              .of(context)
              .textTheme
              .headline6
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        // Rating(rating: hmoProvider.rating,)
        EditableRating(
          rating: selectedRating,
          canEdit: true,
          onRatingSelected: (rating) {
            setState(() {
              selectedRating = rating;
            });
          },
        )
      ],
    );
  }

  Widget imageWidget() {
    if (widget.hmoProvider == null) return SizedBox();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Images",
          style: Theme.of(context).textTheme.headline6.copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 5,),
        ImagePreview(providerImages: widget.hmoProvider.images)
      ],
    );
  }
}
