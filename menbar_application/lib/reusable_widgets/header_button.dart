import 'package:flutter/material.dart';

class HeaderButton extends StatelessWidget {
  var icon;
  var onPress;

  HeaderButton({this.icon,this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ButtonTheme(
        height: 50,
        minWidth:30,
        splashColor: Colors.transparent,
        child: RaisedButton(
          elevation: 0,
          color: Color(0xffffff),
          onPressed: onPress,
          child: icon,
        ),
      ),
    );
  }
}