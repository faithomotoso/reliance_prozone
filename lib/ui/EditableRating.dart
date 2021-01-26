import 'package:flutter/material.dart';
import 'package:reliance_hmo_test/utils/utils.dart';

class EditableRating extends StatefulWidget {
  num rating;

  // Callback for when a new rating has been selected
  Function onRatingSelected;

  bool canEdit;

  double starSize;

  EditableRating(
      {this.rating, this.onRatingSelected, this.canEdit = false, this.starSize, Key key})
      : super(key: key) {
    assert(rating <= 5, "Rating can't be more than 5");
    // Set rating to 0 if null
    rating ??= 0;
  }

  @override
  EditableRatingState createState() => EditableRatingState();
}

class EditableRatingState extends State<EditableRating> {
  num rating;
  ValueNotifier<bool> isValid = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();

    // When editing a provider
    rating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isValid,
      builder: (context, isValid, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: widget.starSize ?? 35,
              padding: const EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                  borderRadius: appBorderRadius,
                  border: Border.all(
                      color: isValid
                          ? Colors.transparent
                          : Theme.of(context).errorColor)),
              child: ListView.separated(
                separatorBuilder: (context, index) => SizedBox(
                  width: 5,
                ),
                itemCount: 5,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: widget.canEdit
                        ? () {
                            setState(() {
                              rating = index + 1;
                            });
                            widget.onRatingSelected?.call(rating);
                            validateRating();
                          }
                        : null,
                    child: index + 1 <= rating ? starFilled() : starBorder(),
                  );
                },
              ),
            ),
            if (!isValid) _validatorWidget()
          ],
        );
      },
    );
  }

  Widget _validatorWidget() {
    return Text(
      "Please select a rating",
      style: Theme.of(context)
          .textTheme
          .bodyText2
          .copyWith(color: Theme.of(context).errorColor, fontSize: 12),
    );
  }

  Icon starFilled() {
    return Icon(
      Icons.star,
      color: Colors.orange,
      size: widget.starSize,
    );
  }

  Icon starBorder() {
    return Icon(
      Icons.star_border,
      color: Colors.grey,
      size: widget.starSize,
    );
  }

  bool validateRating() {
    // Check if rating is not null
    isValid.value = rating != 0;

    return rating != 0;
  }
}
