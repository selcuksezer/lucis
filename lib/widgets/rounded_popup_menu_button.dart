import 'package:flutter/material.dart';

class RoundedPopupMenuButton extends StatelessWidget {
  const RoundedPopupMenuButton({
    Key? key,
    required this.menuItems,
  }) : super(key: key);

  final List<PopupMenuItem> menuItems;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(15.0),
        ),
      ),
      icon: const Icon(Icons.more_vert),
      itemBuilder: (context) => menuItems,
    );
  }
}

class MenuItem extends PopupMenuItem {
  final IconData iconData;
  final String textData;

  MenuItem({
    Key? key,
    required this.textData,
    required this.iconData,
    required Function() onTap,
  }) : super(
            key: key,
            child: ListTile(
              dense: true,
              trailing: Icon(
                iconData,
                color: Colors.black54,
              ),
              leading: Text(
                textData,
                style: const TextStyle(
                    fontSize: 15.0, fontWeight: FontWeight.w500),
              ),
            ),
            onTap: onTap);
}
