import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  const CustomFloatingActionButton(
      {super.key,
      this.onPressed,
      required this.btnColor,
      required this.icon,
      required this.heroTag,
      this.shape = true,
      this.iconColor});

  final void Function()? onPressed;
  final Color btnColor;
  final String heroTag;
  final IconData icon;
  final bool shape;
  final Color? iconColor;
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(right: 15, bottom: 15),
        child: FloatingActionButton(
          onPressed: onPressed,
          backgroundColor: btnColor,
          heroTag: heroTag,
          shape: shape
              ? CircleBorder()
              : RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Icon(
            icon,
            color: iconColor ?? Colors.white,
            size: 26,
          ),
        ));
  }
}
