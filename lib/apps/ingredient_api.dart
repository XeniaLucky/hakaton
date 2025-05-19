import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/ingridient.dart';

class IngredientApi {
  static const String _baseUrl =
      'https://www.themealdb.com/api/json/v1/1/list.php?i=list';

  Future<List<Ingredient>> fetchIngredients() async {
    final response = await http.get(Uri.parse(_baseUrl));

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['meals'];
      return jsonData.map((item) => Ingredient.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load ingredients');
    }
  }
}
