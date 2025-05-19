class Ingredient {
  final String idIngredient;
  final String strIngredient;
  final String? strDescription;

  Ingredient({
    required this.idIngredient,
    required this.strIngredient,
    this.strDescription,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      idIngredient: json['idIngredient'],
      strIngredient: json['strIngredient'],
      strDescription: json['strDescription'],
    );
  }
}
