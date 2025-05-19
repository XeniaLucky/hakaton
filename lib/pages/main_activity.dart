import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../model/mushroom.dart';

class MainActivity extends StatefulWidget {
  @override
  _MainActivityState createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  List<MushroomWithRecipe> mushrooms = [];
  List<MushroomWithRecipe> filtered = [];
  String query = '';

  @override
  void initState() {
    super.initState();
    loadMushrooms();
  }

  Future<void> loadMushrooms() async {
    final data = await rootBundle.loadString('assets/mushrooms_with_recipes.json');
    final List decoded = json.decode(data);
    final List<MushroomWithRecipe> loaded = decoded.map((e) => MushroomWithRecipe.fromJson(e)).toList();
    setState(() {
      mushrooms = loaded;
      filtered = loaded;
    });
  }

  void search(String q) {
    setState(() {
      query = q;
      filtered = mushrooms.where((m) =>
      m.name.toLowerCase().contains(q.toLowerCase()) ||
          m.commonName.toLowerCase().contains(q.toLowerCase())).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Поиск грибов...',
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
            ),
            onChanged: search,
          ),
        ),
        Expanded(
          child: GridView.builder(
            itemCount: filtered.length,
            padding: const EdgeInsets.all(12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 0.8,
            ),
            itemBuilder: (_, i) {
              final m = filtered[i];
              return GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => RecipeDetail(m: m)),
                ),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  elevation: 3,
                  child: Column(
                    children: [
                      Expanded(child: ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(m.image, fit: BoxFit.cover, width: double.infinity),
                      )),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(m.commonName.isNotEmpty ? m.commonName : m.name,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class RecipeDetail extends StatelessWidget {
  final MushroomWithRecipe m;

  const RecipeDetail({required this.m});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Рецепт с ${m.commonName.isNotEmpty ? m.commonName : m.name}')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Image.network(m.image, height: 200, fit: BoxFit.cover),
            SizedBox(height: 16),
            Text(m.recipeName, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Ингредиенты:", style: TextStyle(fontWeight: FontWeight.bold)),
            ...m.ingredients.map((i) => Text("• $i")),
            SizedBox(height: 10),
            Text("Инструкция:", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(m.instructions),
          ],
        ),
      ),
    );
  }
}