import 'package:flutter/material.dart';
import 'package:reliance_hmo_test/business_logic/models/hmo_provider/HMOProvider.dart';
import 'package:reliance_hmo_test/ui/components/AppBar.dart';
import 'package:reliance_hmo_test/ui/components/TextFieldHeader.dart';

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

  @override
  void initState() {
    super.initState();

    if (widget.hmoProvider != null) {
      hmoProvider = widget.hmoProvider;
      nameController.text = hmoProvider.name;
      descriptionController.text = hmoProvider.description;
      addressController.text = hmoProvider.address;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          appBar(title: hmoProvider != null ? "Edit Provider" : "Add Provider"),
      body: Form(
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
            TextFieldWHeader(
                header: "Address", textEditingController: addressController)
          ],
        ),
      ),
    );
  }

  SizedBox get listVerticalSpace => SizedBox(
        height: 10,
      );
}
