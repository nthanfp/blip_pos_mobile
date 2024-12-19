import 'package:blip_pos/service/master/category.dart';
import 'package:flutter/material.dart';

class MasterCategoryPage extends StatefulWidget {
  const MasterCategoryPage({Key? key}) : super(key: key);

  @override
  _MasterCategoryPageState createState() => _MasterCategoryPageState();
}

class _MasterCategoryPageState extends State<MasterCategoryPage> {
  List<Map<String, dynamic>> _categories = [];

  @override
  void initState() {
    super.initState();
    _refreshCategories();
  }

  String generateSlug(String name) {
    return name.toLowerCase().replaceAll(' ', '-');
  }

  Future<void> _refreshCategories() async {
    try {
      final categories = await CategoryService().fetchCategories();
      setState(() {
        _categories = categories;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching categories: $e')),
      );
    }
  }

  Future<void> _showAddCategoryDialog() async {
    final categoryNameController = TextEditingController();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Category'),
        content: TextFormField(
          controller: categoryNameController,
          decoration: const InputDecoration(labelText: 'Category Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final categoryName = categoryNameController.text.trim();
              if (categoryName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a category name.')),
                );
                return;
              }

              final categorySlug = categoryName.toLowerCase().replaceAll(' ', '-');

              try {
                await CategoryService().addCategory({
                  'category_name': categoryName,
                  'category_slug': categorySlug,
                });
                _refreshCategories();
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Category added successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error adding category: $e')),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  Future<void> _showEditCategoryDialog(Map<String, dynamic> category) async {
    final categoryNameController = TextEditingController(text: category['category_name']);

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Category'),
        content: TextFormField(
          controller: categoryNameController,
          decoration: const InputDecoration(labelText: 'Category Name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final categoryName = categoryNameController.text.trim();
              if (categoryName.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a category name.')),
                );
                return;
              }

              final categorySlug = categoryName.toLowerCase().replaceAll(' ', '-');

              try {
                await CategoryService().updateCategory(category['id'], {
                  'category_name': categoryName,
                  'category_slug': categorySlug,
                });
                _refreshCategories();
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Category updated successfully')),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating category: $e')),
                );
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteCategory(int categoryId) async {
    try {
      await CategoryService().deleteCategory(categoryId);
      _refreshCategories();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Category deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting category: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Master Category'),
      ),
      body: _categories.isEmpty
          ? const Center(child: Text('No categories found.'))
          : ListView.builder(
              itemCount: _categories.length,
              itemBuilder: (ctx, index) {
                final category = _categories[index];

                return ListTile(
                  title: Text(category['category_name'] ?? 'No name'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditCategoryDialog(category),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _deleteCategory(category['id']),
                      ),
                    ],
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddCategoryDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}
