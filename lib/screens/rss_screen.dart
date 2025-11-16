import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:wishlist_app/helpers/local_pager.dart';
import 'package:wishlist_app/services/data_service.dart';
import 'package:wishlist_app/widgets/paginanted_list.dart';
import 'package:wishlist_app/widgets/rss_item_card.dart';

class RSSScreen extends StatefulWidget {
  const RSSScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RSSScreenState();
}

class _RSSScreenState extends State<RSSScreen> {
  String? _selectedTheme;

  @override
  Widget build(BuildContext context) {
    final ds = context.watch<DataService>();
    final items = ds.parsedRssItems;
    final themes = ds.themes;
    final filteredItems = _selectedTheme == null
        ? items
        : items.where((e) => e.theme == _selectedTheme).toList();
    final pager = LocalPager(filteredItems);

    return Scaffold(
      appBar: AppBar(title: const Text('RSS Feed')),
      body: ds.loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // horizontal theme selector (bounded height)
                  SizedBox(
                    height: 48,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: themes.length,
                      itemBuilder: (context, index) {
                        final theme = themes[index];
                        final selected = theme == _selectedTheme;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: ChoiceChip(
                            label: Text(theme),
                            selected: selected,
                            onSelected: (on) {
                              setState(() {
                                _selectedTheme = on ? theme : null;
                              });
                            },
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  // content list
                  Expanded(
                    child: PaginantedList(
                      pager: pager,
                      itemBuilder: (item) => RssItemCardWidget(
                        data: item,
                        onTap: () async {
                          final url = item.link;
                          if (await canLaunchUrlString(url)) {
                            await launchUrlString(
                              url,
                              mode: LaunchMode.externalApplication,
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
