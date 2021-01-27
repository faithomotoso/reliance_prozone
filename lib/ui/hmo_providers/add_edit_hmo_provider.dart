import 'package:flutter/cupertino.dart';
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

  Future providerTypesFuture;
  List<HMOProviderType> providerTypes;
  HMOProviderType selectedProviderType;

  Future futureWait;

  ValueNotifier<bool> editMode;

  void getStates() {
    statesFuture = Provider.of<AppViewModel>(context, listen: false)
        .getAllStates()
        .then((value) {
      if (value is List) states = value;

      return value;
    });
  }

  void getProviderTypes() {
    providerTypesFuture = Provider.of<AppViewModel>(context, listen: false)
        .getAllProviderTypes()
        .then((value) {
      if (value is List) providerTypes = value;
      return value;
    });
  }

  void assignFutureWait() {
    loadLists();
    futureWait = Future.wait([statesFuture, providerTypesFuture]);
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
    editMode = ValueNotifier<bool>(widget.hmoProvider != null ? false : true);
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
    appViewModel = Provider.of<AppViewModel>(context);
    setState(() {
      hmoProvider = appViewModel.allProviders.firstWhere(
          (element) => element.id == hmoProvider?.id,
          orElse: () => hmoProvider);
    });
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
    return ValueListenableBuilder(
      valueListenable: editMode,
      builder: (context, editMode, child) {
        return Scaffold(
          key: scaffoldKey,
          backgroundColor: Colors.white,
          appBar: appBar(
              title: hmoProvider != null ? "Edit Provider" : "Add Provider",
              actions: [
                if (!editMode)
                  IconButton(
                      icon: Icon(Icons.edit_outlined),
                      tooltip: "Edit",
                      onPressed: () {
                        this.editMode.value = !this.editMode.value;
                      })
              ]),
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
                      enabled: editMode,
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
                      enabled: editMode,
                      contentPadding: EdgeInsets.all(10),
                      validator: (String value) {
                        if (value.isEmpty) return "Please enter a description";
                        return null;
                      },
                    ),
                    listVerticalSpace,
                    // imageWidget(),
                    ProviderImagesPreview(
                      hmoProvider: hmoProvider,
                      editMode: editMode,
                    ),
                    listVerticalSpace,
                    TextFieldWHeader(
                      header: "Address",
                      textEditingController: addressController,
                      multiLine: true,
                      enabled: editMode,
                      contentPadding: EdgeInsets.all(10),
                      validator: (String value) {
                        if (value.isEmpty) return "Please enter an address";
                        return null;
                      },
                    ),
                    listVerticalSpace,
                    ratingWidget(editMode),
                    listVerticalSpace,
                    ActiveStatusWidget(
                        key: activeStatusKey,
                        activeStatus: selectedActiveStatus,
                        canEdit: editMode,
                        onStatusSelected: (status) {
                          setState(() {
                            selectedActiveStatus = status;
                          });
                        }),
                    listVerticalSpace,
                    StatesWidget(
                      key: statesKey,
                      selectedState: selectedState,
                      canEdit: editMode,
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
                        canEdit: editMode,
                        onProviderTypeSelected: (type) {
                          setState(() {
                            selectedProviderType = type;
                          });
                        },
                        providerTypes: providerTypes),
                    SizedBox(
                      height: 20,
                    ),
                    if (editMode) AppButton(
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
      },
    );
  }

  SizedBox get listVerticalSpace => SizedBox(
        height: 14,
      );

  Widget ratingWidget(bool editMode) {
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
          canEdit: editMode,
          onRatingSelected: (rating) {
            setState(() {
              selectedRating = rating;
            });
          },
        )
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
