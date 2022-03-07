import 'package:flutter/material.dart';

import '/model/recipe.dart';
import '/ui/widgets/recipe_title.dart';
import '/utils/store.dart';
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
    print(recipe.duration);
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
                tabs: [
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

class IngredientsView extends StatelessWidget {
  final List<Map<String, dynamic>> ingredients;

  const IngredientsView(this.ingredients, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];
    ingredients.forEach((item) {
      children.add(
        Row(
          children: [
            Icon(Icons.done),
            SizedBox(width: 5.0),
            Text(item['name']),
          ],
        ),
      );
      // Add spacing between the lines:
      children.add(
        SizedBox(
          height: 15.0,
        ),
      );
    });
    return ListView(
      padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 75.0),
      children: children,
    );
  }
}

class PreparationView extends StatelessWidget {
  final List<String> preparationSteps;

  PreparationView(this.preparationSteps);

  @override
  Widget build(BuildContext context) {
    List<Widget> textElements = [];
    preparationSteps.asMap().forEach((i, item) {
      textElements.add(
        Text('${i + 1}. $item'),
      );
      textElements.add(
        SizedBox(
          height: 20.0,
          // Add spacing between the line
        ),
      );
    });
    return ListView(
      padding: EdgeInsets.fromLTRB(25.0, 25.0, 25.0, 75.0),
      children: textElements,
    );
  }
}
