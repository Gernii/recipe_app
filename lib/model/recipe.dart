enum RecipeType {
  food,
  drink,
}

class Recipe {
  final String id;
  final RecipeType type;
  final String name;
  final int duration;
  final List<Map<String, dynamic>> ingredients;
  final List<String> preparation;
  final String imageURL;

  const Recipe({
    required this.id,
    required this.type,
    required this.name,
    required this.duration,
    required this.ingredients,
    required this.preparation,
    required this.imageURL,
  });

  String get getDurationString {
    return '$duration phút';
  }

  Recipe.fromMap(Map<String, dynamic> data, String id)
      : this(
          id: id,
          type: RecipeType.values[data['type']],
          name: data['name'],
          duration: data['duration'],
          ingredients: List<Map<String, dynamic>>.from(data['ingredients']),
          preparation: List<String>.from(data['preparation']),
          imageURL: data['image'],
        );
}
