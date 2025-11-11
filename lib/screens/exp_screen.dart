import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishlist_app/services/data_service.dart';
import 'package:wishlist_app/widgets/csv_item_card.dart';

class ExpScreen extends StatefulWidget {
  const ExpScreen({super.key});

  @override
  State<StatefulWidget> createState() => _ExpState();
}

class _ExpState extends State<ExpScreen> {
  String? _selectedTheme;

  @override
  Widget build(BuildContext context) {
    final ds = context.watch<DataService>();
    final items = ds.csvItems;
    final themes = ds.themes;
    final filteredItems = _selectedTheme == null
        ? items
        : items.where((e) => e.theme == _selectedTheme).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Expiration List')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ds.loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
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
                        return CsvItemCardWidget(data: item);
                      },
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
