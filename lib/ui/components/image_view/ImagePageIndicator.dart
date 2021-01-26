import 'package:flutter/material.dart';

class ImagePageIndicator extends StatelessWidget {
  int page;
  int maxPage; // total number of images

  ImagePageIndicator({@required this.page, @required this.maxPage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 10,
      child: Center(
        child: ListView.builder(
          itemCount: maxPage,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return Circle(filled: index == page,);
          },
        ),
      ),
    );
  }
}

class Circle extends StatelessWidget {
  bool filled;

  Circle({@required this.filled});

  Color filledColor = Colors.white;
  Color borderColor = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width:  20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: borderColor),
        color: filled ? filledColor : Colors.transparent
      ),
    );
  }
}

