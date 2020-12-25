import 'package:flutter/material.dart';

class FloatingActionButtorContainer extends StatelessWidget {
  const FloatingActionButtorContainer({
    Key key,
    @required this.icon,
    @required this.onPressedCallback,
    @required this.position,
  }) : super(key: key);

  final IconData icon;
  final String position;
  final Function onPressedCallback;

  @override
  Widget build(BuildContext context) {
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Container(
      padding: position == 'left'
          ? EdgeInsets.only(left: 15)
          : EdgeInsets.only(right: 15),
      child: Align(
        alignment: isLandscape
            ? (position == 'left')
                ? Alignment.bottomLeft
                : Alignment.bottomRight
            : (position == 'left')
                ? Alignment.centerLeft
                : Alignment.centerRight,
        child: Container(
          width: 30,
          child: FloatingActionButton(
            child: Icon(icon),
            onPressed: onPressedCallback,
          ),
        ),
      ),
    );
  }
}
