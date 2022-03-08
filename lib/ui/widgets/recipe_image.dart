import 'package:flutter/material.dart';

class RecipeImage extends StatelessWidget {
  final String imageURL;

  const RecipeImage(this.imageURL, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16.0 / 9.0,
      child: Image.network(
        imageURL,
        fit: BoxFit.cover,
      ),
    );
  }
}
