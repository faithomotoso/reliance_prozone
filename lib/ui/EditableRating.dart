import 'package:flutter/material.dart';

class EditableRating extends StatefulWidget {
  num rating;
  // Callback for when a new rating has been selected
  Function onRatingSelected;

  bool canEdit;

  EditableRating({this.rating, this.onRatingSelected, this.canEdit = false}) {
    assert(rating <= 5, "Rating can't be more than 5");
    // Set rating to 0 if null
    rating ??= 0;
  }

  @override
  _EditableRatingState createState() => _EditableRatingState();
}

class _EditableRatingState extends State<EditableRating> {
  num rating;

  @override
  void initState() {
    super.initState();

    // When editing a provider
    rating = widget.rating;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      child: ListView.separated(
        separatorBuilder: (context, index) => SizedBox(width: 5,),
        itemCount: 5,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: widget.canEdit ? () {
              setState(() {
                rating = index + 1;
              });
              widget.onRatingSelected?.call(rating);
            } : null,
            child: index+1 <= rating ? starFilled() : starBorder(),
          );
        },
      ),
    );
  }

  Icon starFilled() {
    return Icon(Icons.star, color: Colors.orange,);
  }

  Icon starBorder() {
    return Icon(Icons.star_border, color: Colors.grey,);
  }
}
