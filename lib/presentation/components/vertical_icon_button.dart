import 'package:flutter/material.dart';

class VerticalIconButton extends StatelessWidget {
  const VerticalIconButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  final IconData icon;
  final String label;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.maybeOf(context)?.size.width;
    return RawMaterialButton(
      child: Column(
        children: [
          Icon(
            icon,
            color: Colors.black54,
            size: width != null ? width / 4.0 : null,
          ),
          Text(
            label,
            textAlign: TextAlign.start,
            style: const TextStyle(
              color: Colors.black54,
              fontWeight: FontWeight.w700,
              fontSize: 15.0,
            ),
          ),
        ],
      ),
      onPressed: onPressed,
    );
  }
}
