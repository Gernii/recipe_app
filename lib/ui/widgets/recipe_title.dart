import 'package:flutter/material.dart';

import '../../model/recipe.dart';

class RecipeTitle extends StatelessWidget {
  final Recipe recipe;
  final double padding;

  const RecipeTitle(this.recipe, this.padding, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        // Default value for crossAxisAlignment is CrossAxisAlignment.center.
        // We want to align title and description of recipes left:
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            recipe.name,
            style: Theme.of(context).textTheme.subtitle1,
          ),
          // Empty space:
          const SizedBox(height: 10.0),
          Row(
            children: [
              const Icon(Icons.timer, size: 20.0),
              const SizedBox(width: 5.0),
              Text(
                recipe.getDurationString,
                style: Theme.of(context).textTheme.caption,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
