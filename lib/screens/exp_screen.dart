import 'package:flutter/material.dart';
import 'package:wishlist_app/services/csv_service.dart';
import 'package:wishlist_app/widgets/item_card.dart';
import '../models/display_item.dart';

class ExpScreen extends StatefulWidget {
  const ExpScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ExpState();
}

class _ExpState extends State<ExpScreen> {
  late Future<List<DisplayItem>> _futureExpList;
  String? _selectedTheme;

  @override
  void initState() {
    super.initState();
    _futureExpList = loadCsv();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Expiration List')),
      body: FutureBuilder<List<DisplayItem>>(
        future: _futureExpList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final items = snapshot.data ?? <DisplayItem>[];
          if (items.isEmpty) {
            return const Center(child: Text('No data'));
          }

          final themes = items.map((e) => e.theme).toSet().toList();

          final filteredItems = _selectedTheme == null 
            ? items
            : items.where((e) => e.theme == _selectedTheme).toList();

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                // horizontal list needs a bounded height
                SizedBox(
                  height: 48,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: themes.length,
                    itemBuilder: (context, index) {
                      final selected = themes[index] == _selectedTheme;
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: ChoiceChip(
                          label: Text(themes[index]),
                          selected: selected,
                          onSelected: (on) {
                              setState(() {
                                _selectedTheme = on ? themes[index] : null;
                              }); 
                          },
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                // main vertical list must be constrained: use Expanded
                Expanded(
                  child: ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return ItemCardWidget(data: item);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
