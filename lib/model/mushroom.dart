class MushroomWithRecipe {
  final String name;
  final String commonName;
  final String image;
  final String recipeName;
  final String instructions;
  final List<String> ingredients;

  MushroomWithRecipe({
    required this.name,
    required this.commonName,
    required this.image,
    required this.recipeName,
    required this.instructions,
    required this.ingredients,
  });

  factory MushroomWithRecipe.fromJson(Map<String, dynamic> json) {
    final recipe = json['recipe'];
    return MushroomWithRecipe(
      name: json['name'],
      commonName: json['commonname'],
      image: json['image'],
      recipeName: recipe['name'],
      instructions: recipe['instructions'],
      ingredients: List<String>.from(recipe['ingredients']),
    );
  }
}