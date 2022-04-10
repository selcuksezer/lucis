import 'package:flutter/material.dart';
import 'package:lucis/presentation/routes.dart';

class FeedListItem extends StatelessWidget {
  const FeedListItem({
    Key? key,
    required this.item,
    this.onPinTap,
    this.onFavoriteTap,
    this.enablePin,
  }) : super(key: key);

  final dynamic item;
  final void Function(String id)? onPinTap;
  final void Function(String id)? onFavoriteTap;
  final bool? enablePin;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(
            height: 35.0,
          ),
          enablePin == false
              ? Flexible(
                  child: Image.network(
                    item.imageUrl,
                    width: double.infinity,
                  ),
                )
              : Image.network(
                  item.imageUrl,
                  width: double.infinity,
                ),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Routes.userScreen,
                      arguments: item.userId);
                },
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10.0,
                    ),
                    item.avatar != null
                        ? CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(item.avatar),
                          )
                        : const Icon(
                            Icons.person_pin,
                            color: Color(0xFF303030),
                            size: 30.0,
                          ),
                    const SizedBox(
                      width: 5.0,
                    ),
                    Text(
                      item.userName,
                      style: const TextStyle(
                          inherit: false,
                          fontSize: 15,
                          color: Color(0xFF303030),
                          fontWeight: FontWeight.w500,
                          letterSpacing: -1),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {
                      if (enablePin == false) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushNamed(context, Routes.mapScreen,
                            arguments: item.location);
                      }
                    },
                    child: const Icon(
                      Icons.map_outlined,
                      color: Color(0xFF303030),
                      size: 28.0,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (onPinTap != null) {
                        onPinTap!(item.imageId);
                      }
                    },
                    child: item.isPin
                        ? const Icon(
                            Icons.push_pin,
                            color: Color(0xFF303030),
                            size: 25.0,
                          )
                        : const Icon(
                            Icons.push_pin_outlined,
                            color: Color(0xFF303030),
                            size: 25.0,
                          ),
                  ),
                  InkWell(
                    onTap: () {
                      if (onFavoriteTap != null) {
                        onFavoriteTap!(item.imageId);
                      }
                    },
                    child: item.isFavorite
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.redAccent,
                            size: 28.0,
                          )
                        : const Icon(
                            Icons.favorite_border,
                            color: Color(0xFF303030),
                            size: 28.0,
                          ),
                  ),
                  const SizedBox(
                    width: 10.0,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(
            height: 15.0,
          ),
        ],
      ),
    );
  }
}
