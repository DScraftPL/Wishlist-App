import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishlist_app/helpers/local_pager.dart';
import 'package:wishlist_app/services/data_service.dart';
import 'package:wishlist_app/widgets/all_sets.dart';
import 'package:wishlist_app/widgets/paginanted_list.dart';

class AllScreen extends StatefulWidget {
  const AllScreen({super.key});

  @override
  State<StatefulWidget> createState() => _AllState();
}

class _AllState extends State<AllScreen> {
  String? _selectedTheme;

  @override
  Widget build(BuildContext context) {
    final ds = context.watch<DataService>();
    final items = ds.allSetItems;
    final themes = ds.parsedThemeItem;
    final filteredItems = _selectedTheme == null
        ? items
        : items.where((e) => e.themeName == _selectedTheme).toList();
    final pager = LocalPager(filteredItems);

    return Scaffold(
      appBar: AppBar(title: const Text('All items')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ds.loading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
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
                    child: PaginantedList(
                      pager: pager,
                      itemBuilder: (item) => ParsedSetItemCard(item: item),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
