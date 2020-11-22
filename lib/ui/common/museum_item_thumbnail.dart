import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';

class MuseumItemImage extends StatelessWidget {
  final String imageUri;
  final String tag;
  final BoxFit fit;

  MuseumItemImage({
    Key key,
    @required this.imageUri,
    @required this.tag,
    @required this.fit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Hero(
    tag: tag,
    child: CachedNetworkImage(
      imageUrl: imageUri,
      placeholder: (context, url) => Center(child: CircularProgressIndicator()),
      errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
      fit: fit,
    ),
  );
}