import 'package:flutter/material.dart';
import 'package:wishlist_app/models/wishlist.dart';
import 'package:wishlist_app/services/wishlist_service.dart';

class AddWishlistScreen extends StatefulWidget {
  const AddWishlistScreen({super.key});

  @override
  State<AddWishlistScreen> createState() => _AddWishlistScreenState();
}

class _AddWishlistScreenState extends State<AddWishlistScreen> {
  final _formKey = GlobalKey<FormState>();
  final _setNameController = TextEditingController();
  final _setNumberController = TextEditingController();
  final _pieceCountController = TextEditingController();
  final _retirementDateController = TextEditingController();
  final _themeController = TextEditingController();

  @override
  void dispose() {
    _setNameController.dispose();
    _setNumberController.dispose();
    _pieceCountController.dispose();
    _retirementDateController.dispose();
    _themeController.dispose();
    super.dispose();
  }

  Future<void> _saveWishlistItem() async {
    if (_formKey.currentState!.validate()) {
      final item = WishlistItem(
        setName: _setNameController.text,
        setNumber: _setNumberController.text,
        pieceCount: int.parse(_pieceCountController.text),
        retirmentDate: _retirementDateController.text,
        theme: _themeController.text,
      );

      await WishlistService.addEntry(item);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Wishlist item added successfully!')),
        );
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Wishlist Item')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _setNameController,
                decoration: const InputDecoration(
                  labelText: 'Set Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a set name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _setNumberController,
                decoration: const InputDecoration(
                  labelText: 'Set Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a set number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _pieceCountController,
                decoration: const InputDecoration(
                  labelText: 'Piece Count',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter piece count';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _retirementDateController,
                decoration: const InputDecoration(
                  labelText: 'Retirement Date',
                  border: OutlineInputBorder(),
                  hintText: 'e.g., 2025-12-31',
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter retirement date';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _themeController,
                decoration: const InputDecoration(
                  labelText: 'Theme',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a theme';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _saveWishlistItem,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Add to Wishlist',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
