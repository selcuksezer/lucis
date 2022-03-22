import 'package:flutter/material.dart';

class FeedListItem extends StatelessWidget {
  const FeedListItem({
    Key? key,
    required this.item,
  }) : super(key: key);

  final dynamic item;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      child: Column(
        children: [
          Image.network(
            item.image.imageId!,
            width: double.infinity,
          ),
          const SizedBox(
            height: 8.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              InkWell(
                onTap: () {},
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10.0,
                    ),
                    item.avatar != null
                        ? CircleAvatar(
                            radius: 20.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(item.avatar.imageId!),
                          )
                        : const Icon(
                            Icons.person_pin,
                            color: Colors.black38,
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
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                          letterSpacing: -1),
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.map_outlined,
                      color: Colors.black38,
                      size: 30.0,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.push_pin_outlined,
                      color: Colors.black38,
                      size: 30.0,
                    ),
                  ),
                  InkWell(
                    onTap: () {},
                    child: const Icon(
                      Icons.favorite_border,
                      color: Colors.black38,
                      size: 30.0,
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
            height: 20.0,
          ),
        ],
      ),
    );
  }
}
