import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../services/rss_service.dart';
import 'package:flutter/foundation.dart';

class RSSScreen extends StatefulWidget {
  const RSSScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RSSScreenState();
}

String getRssUrl(String originalUrl) {
  if (kIsWeb) {
    return 'https://api.allorigins.win/raw?url=${Uri.encodeComponent(originalUrl)}';
  }
  return originalUrl;
}

class _RSSScreenState extends State<RSSScreen> {
  late Future<List<RssItem>> _futureItems;
  final String _feedUrl = getRssUrl('https://promoklocki.pl/okazje-lego/rss');

  @override
  void initState() {
    super.initState();
    _futureItems = RssService().fetchRss(_feedUrl);
  }

  Future<void> _refresh() async {
    setState(() {
      _futureItems = RssService().fetchRss(_feedUrl);
    });
    await _futureItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RSS Feed')),
      body: FutureBuilder(
        future: _futureItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Error: ${snapshot.error}'),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: _refresh,
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            );
          }
          final items = snapshot.data ?? <RssItem>[];
          if (items.isEmpty) {
            return RefreshIndicator(
              onRefresh: _refresh,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 200),
                  Center(child: Text('Data is empty')),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: _refresh,
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return ListTile(
                  title: Text(item.title),
                  subtitle: Text(item.description),
                  trailing: const Icon(Icons.open_in_new),
                  onTap: () async {
                    final url = item.link;
                    if (await canLaunchUrlString(url)) {
                      await launchUrlString(
                        url,
                        mode: LaunchMode.externalApplication,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('cannot open')),
                      );
                    }
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}
