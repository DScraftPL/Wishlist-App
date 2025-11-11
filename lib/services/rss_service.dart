import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:xml/xml.dart' as xml;

class RssItem {
  final String title;
  final String link;
  final String description;
  final String pubDate;

  RssItem({
    required this.title,
    required this.link,
    required this.description,
    required this.pubDate,
  });
}


class RssService {
  
  Future<List<RssItem>> fetchRss(String url) async {
    Uri uri;
    try {
      uri = Uri.parse(url);
      if (!uri.hasScheme) {
        // assume https if missing
        uri = uri.replace(scheme: 'https');
      }
    } catch (e) {
      print('[RssService] Invalid URL: $url — $e');
      return [];
    }
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Failed to load RSS');
    }

    final doc = xml.XmlDocument.parse(res.body);
    final items = <RssItem>[];

    for (final node in doc.findAllElements('item')) {
      final title = node.getElement('title')?.innerText ?? 'No title';
      final description =
          node.getElement('description')?.innerText ?? 'No description';
      final link = node.getElement('link')?.innerText ?? 'No link';
      final pubDate = node.getElement('pubDate')?.innerText ?? 'No Date';

      items.add(
        RssItem(
          title: title,
          link: link,
          description: description,
          pubDate: pubDate,
        ),
      );
    }

    return items;
  }
}
