import 'package:flutter/material.dart';
import '../../model/state.dart';
import '/state_widget.dart';
import '../../model/recipe.dart';
import '../../ui/widgets/recipe_title.dart';
import '../../ui/screens/detail.dart';
import '../../ui/widgets/recipe_image.dart';

class RecipeCard extends StatefulWidget {
  final Recipe recipe;
  final Function onFavoriteButtonPressed;

  const RecipeCard(
      {Key? key, required this.recipe, required this.onFavoriteButtonPressed})
      : super(key: key);

  @override
  State<RecipeCard> createState() => _RecipeCardState();
}

class _RecipeCardState extends State<RecipeCard> {
  StateModel? appState;

  @override
  Widget build(BuildContext context) {
    appState = StateWidget.of(context).state;
    RawMaterialButton _buildFavoriteButton() {
      return RawMaterialButton(
        constraints: const BoxConstraints(minWidth: 40.0, minHeight: 40.0),
        onPressed: () => widget.onFavoriteButtonPressed(widget.recipe.id),
        child: Icon(
          // Conditional expression:
          // show "favorite" icon or "favorite border" icon depending on widget.inFavorites:
          appState!.favorites.contains(widget.recipe.id)
              ? Icons.favorite
              : Icons.favorite_border,
          color: Theme.of(context).iconTheme.color,
        ),
        elevation: 2.0,
        shape: CircleBorder(),
      );
    }

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetailScreen(
              widget.recipe,
              widget.onFavoriteButtonPressed,
              appState!.favorites.contains(widget.recipe.id)),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  RecipeImage(widget.recipe.imageURL),
                  Positioned(
                    child: _buildFavoriteButton(),
                    top: 2.0,
                    right: 2.0,
                  ),
                ],
              ),
              RecipeTitle(widget.recipe, 15),
            ],
          ),
        ),
      ),
    );
  }
}
