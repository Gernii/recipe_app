import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../widgets/recipe_search.dart';
import '/model/recipe.dart';
import '/utils/store.dart';
import '/ui/widgets/recipe_card.dart';
import '/model/state.dart';
import '/state_widget.dart';
import '/ui/screens/login.dart';
import '/ui/widgets/settings_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
  StateModel? appState;
  final controller = ScrollController();
  String query = '';
  String isQueried = '';

  DefaultTabController _buildTabView({Widget? body}) {
    const double _iconSize = 20.0;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: PreferredSize(
          // We set Size equal to passed height (50.0) and infinite width:
          preferredSize: const Size.fromHeight(50.0),
          child: AppBar(
            backgroundColor: Color(0xFF03ACFE),
            elevation: 2.0,
            bottom: TabBar(
              labelColor: Theme.of(context).indicatorColor,
              tabs: const [
                Tab(icon: Icon(Icons.restaurant, size: _iconSize)),
                Tab(icon: Icon(Icons.local_drink, size: _iconSize)),
                Tab(icon: Icon(Icons.favorite, size: _iconSize)),
                Tab(icon: Icon(Icons.settings, size: _iconSize)),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(5.0),
          child: body,
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (appState!.isLoading) {
      return _buildTabView(
        body: _buildLoadingIndicator(),
      );
    } else if (!appState!.isLoading && appState?.user == null) {
      return const LoginScreen();
    } else {
      return _buildTabView(
        body: _buildTabsContent(),
      );
    }
  }

  Widget _buildSearch() => RecipeSearch(
        text: query,
        hintText: 'Tìm công thức',
        onChanged: (query) => updateQuery(query),
      );

  Center _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Column _buildSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SettingsButton(
          Icons.exit_to_app,
          "Đăng xuất",
          appState!.user!.displayName!,
          () async {
            await StateWidget.of(context).signOutOfGoogle();
          },
        ),
      ],
    );
  }

  TabBarView _buildTabsContent() {
    Scaffold _buildRecipes({RecipeType? recipeType, List<String>? ids}) {
      CollectionReference collectionReference =
          FirebaseFirestore.instance.collection('recipe');
      Stream<QuerySnapshot> stream;
      // Kiểm tra loại của công thức
      if (recipeType != null) {
        if (isQueried != '') {
          stream = collectionReference
              .where("type", isEqualTo: recipeType.index)
              .where("name", isGreaterThanOrEqualTo: isQueried)
              .snapshots();
        } else {
          stream = collectionReference
              .where("type", isEqualTo: recipeType.index)
              .snapshots();
        }
      } else {
        // sử dụng snapshots để lưu lại tất cả công thức nếu không truyền loại công thức
        stream = collectionReference.snapshots();
      }
      // Define query depeneding on passed args
      return Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Theme.of(context).indicatorColor,
          onPressed: () => scrollUp(),
          child: const Icon(Icons.arrow_upward),
        ),
        body: Padding(
          // Padding before and after the list view:
          padding: const EdgeInsets.symmetric(vertical: 5.0),
          child: Column(
            children: [
              _buildSearch(),
              Expanded(
                child: StreamBuilder(
                  stream: stream,
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) return _buildLoadingIndicator();
                    return ListView(
                      controller: controller,
                      children: snapshot.data!.docs
                          // Check if the argument ids contains document ID if ids has been passed:
                          .where((d) => ids == null || ids.contains(d.id))
                          .map((document) {
                        return RecipeCard(
                          recipe: Recipe.fromMap(
                              (document.data() as Map<String, dynamic>),
                              document.id),
                          onFavoriteButtonPressed: _handleFavoritesListChanged,
                        );
                      }).toList(),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    }

    return TabBarView(
      children: [
        _buildRecipes(recipeType: RecipeType.food),
        _buildRecipes(recipeType: RecipeType.drink),
        _buildRecipes(ids: appState?.favorites),
        _buildSettings(),
      ],
    );
  }

  void _handleFavoritesListChanged(String recipeID) {
    updateFavorites(appState!.user!.uid, recipeID).then((result) {
      if (result == true) {
        setState(() {
          if (!appState!.favorites.contains(recipeID)) {
            appState?.favorites.add(recipeID);
          } else {
            appState?.favorites.remove(recipeID);
          }
        });
      }
    });
  }

  void scrollUp() {
    const double start = 0;
    // controller.jumpTo(start);
    controller.animateTo(start,
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  void updateQuery(String value) {
    setState(() {
      isQueried = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Build the content depending on the state:
    appState = StateWidget.of(context).state;
    return _buildContent();
  }
}
