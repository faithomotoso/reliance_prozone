import 'package:flutter/material.dart';

class Ratings extends StatelessWidget {
  // Rating out of 5, assuming whole numbers
  num rating;

  Ratings({@required this.rating}) {
    assert(rating <= 5, "Rating can't be more than 5");
    // Set rating to 0 if null
    rating ??= 0;
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
          return index+1 <= rating ? starFilled() : starBorder();
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
