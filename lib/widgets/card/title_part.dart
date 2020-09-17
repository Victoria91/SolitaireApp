import 'package:flutter/material.dart';

class TitlePart extends StatelessWidget {
  final position;
  final rank;

  TitlePart(this.rank, this.position);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: position == 'top'
          ? EdgeInsets.only(top: 3, left: 3, right: 3)
          : EdgeInsets.only(left: 3, right: 3),
      child: Align(
        alignment: position == 'top' ? Alignment.topLeft : Alignment.topRight,
        child: Text(
          rank,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
    );
  }
}
