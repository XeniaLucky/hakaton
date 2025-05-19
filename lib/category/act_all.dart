import 'package:flutter/material.dart';
import '../model/ingridient.dart';
import '../apps/api.dart';

class ActAllPage extends StatefulWidget {
  const ActAllPage({Key? key}) : super(key: key);

  @override
  _ActAllPageState createState() => _ActAllPageState();
}

class _ActAllPageState extends State<ActAllPage> {
  late ApiService _apiService;
  List<Ingredient> _ingredients = [];
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService(
      itemsPerPage: 6,
      scrollController: _scrollController,
      onNewIngredientsLoaded: (ingredients) {
        setState(() {
          _ingredients = ingredients;
        });
      },
      onLoadingStateChanged: (loading) {
        setState(() {
          _isLoading = loading;
        });
      },
      onMoreContentAvailable: (hasMore) {
        setState(() {
          _hasMore = hasMore;
        });
      },
    );
    _apiService.initialize();
  }

  @override
  void dispose() {
    _apiService.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8F5E9),
      appBar: AppBar(
        title: Text("Ingredients"),
        backgroundColor: const Color(0xFFC8E6C9),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
            _ingredients.clear();
          });
          await _apiService.refreshIngredients();
        },
        child: Stack(
          children: [
            _ingredients.isEmpty
                ? Center(child: Text('Нет ингредиентов для отображения.'))
                : ListView.builder(
              controller: _scrollController,
              itemCount: _ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = _ingredients[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F8E9),
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(ingredient.strIngredient),
                    subtitle: Text(ingredient.strDescription ?? 'Нет описания'),
                  ),
                );
              },
            ),
            if (_isLoading)
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
