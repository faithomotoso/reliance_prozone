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
import 'package:reliance_hmo_test/ui/components/AppButton.dart';
import 'package:reliance_hmo_test/ui/components/AppFutureBuilder.dart';
import 'package:reliance_hmo_test/ui/components/HMOProviderTypeWidget.dart';
import 'package:reliance_hmo_test/ui/components/StatesWidget.dart';
import 'package:reliance_hmo_test/ui/components/TextFieldHeader.dart';
import 'package:reliance_hmo_test/ui/components/image_view/ProviderImagesPreview.dart';

class AddEditHMOProvider extends StatefulWidget {
  final HMOProvider hmoProvider;

  AddEditHMOProvider({this.hmoProvider});

  @override
  _AddEditHMOProviderState createState() => _AddEditHMOProviderState();
}

class _AddEditHMOProviderState extends State<AddEditHMOProvider> {
  AppViewModel appViewModel;
  HMOProvider hmoProvider;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  ActiveStatus selectedActiveStatus;
  num selectedRating = 0;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  GlobalKey<StatesWidgetState> statesKey = GlobalKey<StatesWidgetState>();
  GlobalKey<ActiveStatusWidgetState> activeStatusKey =
      GlobalKey<ActiveStatusWidgetState>();
  GlobalKey<EditableRatingState> editableRatingKey =
      GlobalKey<EditableRatingState>();
  GlobalKey<HMOProviderTypeWidgetState> providerTypeKey =
      GlobalKey<HMOProviderTypeWidgetState>();

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
      if (value is List) states = value;

      return value;
    });
  }

  void getProviderTypes() {
    providersFuture = Provider.of<AppViewModel>(context, listen: false)
        .getAllProviderTypes()
        .then((value) {
      if (value is List) providerTypes = value;
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
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (appViewModel == null) appViewModel = Provider.of<AppViewModel>(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
                  header: "Name",
                  textEditingController: nameController,
                  textCapitalization: TextCapitalization.words,
                  validator: (String value) {
                    if (value.isEmpty) return "Please enter a name";
                    return null;
                  },
                ),
                listVerticalSpace,
                TextFieldWHeader(
                  header: "Description",
                  textEditingController: descriptionController,
                  multiLine: true,
                  contentPadding: EdgeInsets.all(10),
                  validator: (String value) {
                    if (value.isEmpty) return "Please enter a description";
                    return null;
                  },
                ),
                listVerticalSpace,
                // imageWidget(),
                ProviderImagesPreview(providerImages: hmoProvider?.images),
                listVerticalSpace,
                TextFieldWHeader(
                  header: "Address",
                  textEditingController: addressController,
                  multiLine: true,
                  contentPadding: EdgeInsets.all(10),
                  validator: (String value) {
                    if (value.isEmpty) return "Please enter an address";
                    return null;
                  },
                ),
                listVerticalSpace,
                ratingWidget(),
                listVerticalSpace,
                ActiveStatusWidget(
                    key: activeStatusKey,
                    activeStatus: selectedActiveStatus,
                    onStatusSelected: (status) {
                      setState(() {
                        selectedActiveStatus = status;
                      });
                    }),
                listVerticalSpace,
                StatesWidget(
                  key: statesKey,
                  selectedState: selectedState,
                  onStateSelected: (state) {
                    setState(() {
                      selectedState = state;
                    });
                  },
                  states: states,
                ),
                listVerticalSpace,
                HMOProviderTypeWidget(
                    key: providerTypeKey,
                    selectedHmoProviderType: selectedProviderType,
                    onProviderTypeSelected: (type) {
                      setState(() {
                        selectedProviderType = type;
                      });
                    },
                    providerTypes: providerTypes),
                SizedBox(
                  height: 20,
                ),
                AppButton(
                    buttonText: "Save",
                    onPressed: () {
                      if (fieldsValidated()) {
                        appViewModel.saveProvider(
                            context: context,
                            scaffoldKey: scaffoldKey,
                            hmoProvider: hmoProvider,
                            providerName: nameController.text,
                            providerAddress: addressController.text,
                            providerDescription: descriptionController.text,
                            rating: selectedRating,
                            selectedState: selectedState,
                            selectedActiveStatus: selectedActiveStatus,
                            selectedProviderType: selectedProviderType);
                      }
                    },
                    context: context)
              ],
            ),
          );
        },
      ),
    );
  }

  SizedBox get listVerticalSpace => SizedBox(
        height: 14,
      );

  Widget ratingWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Rating",
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        // Rating(rating: hmoProvider.rating,)
        EditableRating(
          key: editableRatingKey,
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
          style: Theme.of(context)
              .textTheme
              .headline6
              .copyWith(fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5,
        ),
        ProviderImagesPreview(providerImages: widget.hmoProvider.images)
      ],
    );
  }

  bool fieldsValidated() {
    // Doing it this way because chaining validations don't work.
    bool isValid = true;
    isValid &= statesKey.currentState.validate();
    isValid &= activeStatusKey.currentState.validate();
    isValid &= editableRatingKey.currentState.validateRating();
    isValid &= providerTypeKey.currentState.validate();
    isValid &= formKey.currentState.validate();
    return isValid;
  }
}
