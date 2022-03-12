import 'package:flutter/material.dart';

import '../views/detail_preparation.dart';
import '../views/detail_ingredients.dart';
import '/model/recipe.dart';
import '/ui/widgets/recipe_title.dart';
import '/ui/widgets/recipe_image.dart';

class DetailScreen extends StatefulWidget {
  final Recipe recipe;
  final bool isFavorite;
  final Function onFavoriteButtonPressed;
  const DetailScreen(this.recipe, this.onFavoriteButtonPressed, this.isFavorite,
      {Key? key})
      : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  ScrollController? _scrollController;
  bool? _favorite;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    _scrollController = ScrollController();
    _favorite = widget.isFavorite;
  }

  @override
  void dispose() {
    // "Unmount" the controllers:
    _tabController?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  void _toggleInFavorites(recipe) {
    setState(() {
      _favorite = !_favorite!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        controller: _scrollController,
        headerSliverBuilder: (BuildContext context, bool innerViewIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: Colors.white,
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.pin,
                background: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    RecipeImage(widget.recipe.imageURL),
                    RecipeTitle(widget.recipe, 25.0),
                  ],
                ),
              ),
              expandedHeight: 340.0,
              pinned: true,
              floating: true,
              elevation: 2.0,
              forceElevated: innerViewIsScrolled,
              bottom: TabBar(
                tabs: const [
                  Tab(text: "Nguyên liệu"),
                  Tab(text: "Công thức"),
                ],
                controller: _tabController,
              ),
            )
          ];
        },
        body: TabBarView(
          children: [
            IngredientsView(widget.recipe.ingredients),
            PreparationView(widget.recipe.preparation),
          ],
          controller: _tabController,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          widget.onFavoriteButtonPressed(widget.recipe.id);
          _toggleInFavorites(widget.recipe);
        },
        child: Icon(
          _favorite! ? Icons.favorite : Icons.favorite_border,
          color: Theme.of(context).iconTheme.color,
        ),
        elevation: 2.0,
        backgroundColor: Colors.white,
      ),
    );
  }
}
