import 'package:animated_check/animated_check.dart';
import 'package:flutter/material.dart';

class PanelSuccess extends StatefulWidget {
  @override
  _PanelSuccessState createState() => new _PanelSuccessState();
}

class _PanelSuccessState extends State<PanelSuccess>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation = new Tween<double>(begin: 0, end: 1)
      .animate(new CurvedAnimation(
          parent: _animationController, curve: Curves.easeInOutCirc));
  late AnimationController _animationController =
      _animationController = AnimationController(
    duration: Duration(seconds: 1),
    vsync: this,
  );
  @override
  Widget build(BuildContext context) {
    _animation = new Tween<double>(begin: 0, end: 1).animate(
        new CurvedAnimation(
            parent: _animationController, curve: Curves.easeInOutCirc));
    Size size = MediaQuery.of(context).size;
    _animationController.forward();
    return Expanded(
      child: Center(
        child: Container(
          decoration: new BoxDecoration(
            color: Colors.transparent,
            shape: BoxShape.circle,
            border: new Border.all(
              color: Theme.of(context).canvasColor,
              width: 10,
            ),
          ),
          width: size.width / 2,
          height: size.width / 2,
          alignment: Alignment.center,
          child: AnimatedCheck(
            progress: _animation,
            color: Theme.of(context).canvasColor,
            size: size.width / 2,
          ),
        ),
      ),
    );
  }
}
