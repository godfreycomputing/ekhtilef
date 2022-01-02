import 'package:flutter/material.dart';

class BottomBarContainer extends StatelessWidget {
  final Color colors;
  final Function onTap;
  final IconData icons;

  const BottomBarContainer(
      {Key? key, required this.onTap, required this.icons, required this.colors})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return  Container(
      width: MediaQuery.of(context).size.width / 5,
      color: colors,
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: () => onTap,
          child:  Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Icon(
                icons,
                color: Colors.grey,
              ),
              const SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
