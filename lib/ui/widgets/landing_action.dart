import 'package:flutter/material.dart';

class LandingActionButton extends StatelessWidget {
  final Function onTap;
  final String title;
  final IconData icon;
  LandingActionButton(
      {required this.onTap, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        this.onTap();
      },
      child: Container(
        decoration: BoxDecoration(
            //color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.all(Radius.circular(16))),
        height: 100,
        width: size.width,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Row(
                  children: [
                    Icon(this.icon, size: 24),
                    SizedBox(width: 8),
                    Text(title, style: Theme.of(context).textTheme.bodyText2)
                  ],
                ),
              )
            ]),
      ),
    );
  }
}
