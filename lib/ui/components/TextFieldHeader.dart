import 'package:flutter/material.dart';

class TextFieldWHeader extends StatelessWidget {
  String header;
  TextEditingController textEditingController;
  Function validator;
  bool multiLine;

  TextFieldWHeader(
      {@required this.header,
      @required this.textEditingController,
      this.validator,
      this.multiLine = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: Theme.of(context)
              .textTheme
              .headline5
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 5,
        ),
        TextFormField(
          controller: textEditingController,
          validator: validator,
          maxLines: multiLine ? 2 : 1,
          decoration: InputDecoration(
              fillColor: Colors.grey.withOpacity(0.3),
              hintText: header,
              border: OutlineInputBorder(
                borderRadius: textFieldBorderRadius,
              )),
        )
      ],
    );
  }

  BorderRadius get textFieldBorderRadius => BorderRadius.circular(10);
}
