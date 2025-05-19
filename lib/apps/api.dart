import 'package:flutter/material.dart';
import '../model/ingridient.dart';
import '../apps/ingredient_api.dart';

class ApiService {
  final int itemsPerPage;
  final ScrollController scrollController;
  final Function(List<Ingredient>) onNewIngredientsLoaded;
  final Function(bool) onLoadingStateChanged;
  final Function(bool) onMoreContentAvailable;

  bool _isLoading = false;
  bool _hasMore = true;
  List<Ingredient> _currentIngredients = [];

  ApiService({
    required this.itemsPerPage,
    required this.scrollController,
    required this.onNewIngredientsLoaded,
    required this.onLoadingStateChanged,
    required this.onMoreContentAvailable,
  });

  final IngredientApi _ingredientApi = IngredientApi();

  Future<void> initialize() async {
    await refreshIngredients();
    scrollController.addListener(_scrollListener);
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      loadMore();
    }
  }

  Future<void> refreshIngredients() async {
    onLoadingStateChanged(true);
    try {
      final ingredients = await _ingredientApi.fetchIngredients();
      _currentIngredients = ingredients;
      onNewIngredientsLoaded(ingredients);
      onMoreContentAvailable(true);
    } catch (e) {
      onMoreContentAvailable(false);
    }
    onLoadingStateChanged(false);
  }

  void loadMore() async {
    if (_isLoading || !_hasMore) return;

    _isLoading = true;
    onLoadingStateChanged(true);
    try {
      final ingredients = await _ingredientApi.fetchIngredients();
      _currentIngredients.addAll(ingredients);
      onNewIngredientsLoaded(ingredients);
      if (ingredients.length < itemsPerPage) {
        _hasMore = false;
      } else {
        _hasMore = true;
      }
      onMoreContentAvailable(_hasMore);
    } catch (e) {
      print('Error loading more ingredients: $e');
      onMoreContentAvailable(false);
    }
    _isLoading = false;
    onLoadingStateChanged(false);
  }

  void dispose() {
    scrollController.removeListener(_scrollListener);
  }
}
