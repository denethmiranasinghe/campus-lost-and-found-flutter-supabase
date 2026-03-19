import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import '../models/item_model.dart';

/// Item Provider
/// Handles CRUD operations for lost and found items
class ItemProvider with ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  List<ItemModel> _items = [];
  List<ItemModel> _lostItems = [];
  List<ItemModel> _foundItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ItemModel> get items => _items;
  List<ItemModel> get lostItems => _lostItems;
  List<ItemModel> get foundItems => _foundItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// Fetch all items
  Future<void> fetchItems() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _supabase
          .from('items')
          .select('*, users!items_user_id_fkey(full_name, email)')
          .order('created_at', ascending: false);

      _items = (response as List).map((item) {
        final itemModel = ItemModel.fromJson(item);
        // Add user information
        if (item['users'] != null) {
          return itemModel.copyWith(
            userName: item['users']['full_name'],
            userEmail: item['users']['email'],
          );
        }
        return itemModel;
      }).toList();

      _lostItems = _items.where((item) => item.status == 'lost').toList();
      _foundItems = _items.where((item) => item.status == 'found').toList();

      _errorMessage = null;
    } catch (e) {
      _errorMessage = 'Failed to fetch items: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Create new item
  Future<bool> createItem({
    required String userId,
    required String title,
    required String description,
    required String category,
    required String status,
    required String location,
    required DateTime date,
    File? imageFile,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      String? imageUrl;

      // Upload image if provided
      if (imageFile != null) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
        final storagePath = 'items/$fileName';

        await _supabase.storage
            .from('item-images')
            .upload(storagePath, imageFile);

        imageUrl = _supabase.storage
            .from('item-images')
            .getPublicUrl(storagePath);
      }

      // Insert item into database
      await _supabase.from('items').insert({
        'user_id': userId,
        'title': title,
        'description': description,
        'category': category,
        'status': status,
        'location': location,
        'date': date.toIso8601String(),
        'image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      await fetchItems();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to create item: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Update item
  Future<bool> updateItem({
    required String itemId,
    required String title,
    required String description,
    required String category,
    required String status,
    required String location,
    required DateTime date,
    File? imageFile,
    String? existingImageUrl,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      String? imageUrl = existingImageUrl;

      // Upload new image if provided
      if (imageFile != null) {
        final fileName =
            '${DateTime.now().millisecondsSinceEpoch}_${imageFile.path.split('/').last}';
        final storagePath = 'items/$fileName';

        await _supabase.storage
            .from('item-images')
            .upload(storagePath, imageFile);

        imageUrl = _supabase.storage
            .from('item-images')
            .getPublicUrl(storagePath);
      }

      // Update item in database
      await _supabase
          .from('items')
          .update({
            'title': title,
            'description': description,
            'category': category,
            'status': status,
            'location': location,
            'date': date.toIso8601String(),
            'image_url': imageUrl,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', itemId);

      await fetchItems();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update item: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Delete item
  Future<bool> deleteItem(String itemId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _supabase.from('items').delete().eq('id', itemId);
      await fetchItems();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete item: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Search items
  List<ItemModel> searchItems(String query, String status) {
    final itemsToSearch = status == 'lost' ? _lostItems : _foundItems;

    if (query.isEmpty) {
      return itemsToSearch;
    }

    return itemsToSearch.where((item) {
      return item.title.toLowerCase().contains(query.toLowerCase()) ||
          item.description.toLowerCase().contains(query.toLowerCase()) ||
          item.category.toLowerCase().contains(query.toLowerCase()) ||
          item.location.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  /// Filter items by category
  List<ItemModel> filterByCategory(String category, String status) {
    final itemsToFilter = status == 'lost' ? _lostItems : _foundItems;

    if (category.isEmpty || category == 'All') {
      return itemsToFilter;
    }

    return itemsToFilter.where((item) => item.category == category).toList();
  }

  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
