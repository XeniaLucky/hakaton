import 'package:flutter/material.dart';

final mushroomRecipes = {
  'Champignon': [
    'Обжарить с луком и сливками.',
    'Добавить в пиццу или пасту.',
  ],
  'Porcini': [
    'Тушить с картошкой.',
    'Использовать в ризотто.',
  ],
  'Chanterelle': [
    'Жарить с чесноком.',
    'Добавить в сливочный соус.',
  ],
};
class Mushroom {
  final String name;
  final String commonName;
  final String imageUrl;

  Mushroom({
    required this.name,
    required this.commonName,
    required this.imageUrl,
  });

  factory Mushroom.fromJson(Map<String, dynamic> json) {
    return Mushroom(
      name: json['name'] ?? '',
      commonName: json['commonname'] ?? '',
      imageUrl: json['img'] ?? '',
    );
  }
}

class Recipe {
  final String name;
  final String imageUrl;
  final String instructions;
  final List<String> ingredients;

  Recipe({
    required this.name,
    required this.imageUrl,
    required this.instructions,
    required this.ingredients,
  });
}
class MainActivity extends StatefulWidget {
  @override
  _MushroomGridState createState() => _MushroomGridState();
}

class _MushroomGridState extends State<MainActivity> {
  List<String> mushroomNames = mushroomRecipes.keys.toList();
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filtered = mushroomNames.where((name) => name.toLowerCase().contains(searchQuery.toLowerCase())).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Поиск грибов...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
            ),
            onChanged: (val) {
              setState(() {
                searchQuery = val;
              });
            },
          ),
        ),
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            children: filtered.map((name) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => RecipeDetail(name: name),
                  ));
                },
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/$name.png', height: 60),
                      const SizedBox(height: 10),
                      Text(name, style: TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class RecipeDetail extends StatelessWidget {
  final String name;

  const RecipeDetail({required this.name});

  @override
  Widget build(BuildContext context) {
    final recipes = mushroomRecipes[name] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('Рецепты с $name'),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (_, i) => ListTile(
          title: Text(recipes[i]),
        ),
      ),
    );
  }
}