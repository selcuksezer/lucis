import 'package:flutter/material.dart';

class AvatarMarker extends StatelessWidget {
  const AvatarMarker({
    Key? key,
    required this.radius,
    required this.url,
  }) : super(key: key);

  final double radius;
  final String url;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2 * radius,
      height: 2 * radius,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(url),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
        border: Border.all(
          color: Colors.deepOrange,
          width: 3.0,
        ),
      ),
    );
  }
}
