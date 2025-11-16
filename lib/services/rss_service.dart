import 'dart:async';

import 'package:http/http.dart' as http;
import 'package:wishlist_app/models/rss_item.dart';
import 'package:xml/xml.dart' as xml;
import 'package:flutter/foundation.dart';

class RssService {

  String getRssUrl(String originalUrl) {
    if (kIsWeb) {
      return 'https://api.allorigins.win/raw?url=${Uri.encodeComponent(originalUrl)}';
    }
    return originalUrl;
  }
  
  Future<List<RssItem>> fetchRss({String url = 'https://promoklocki.pl/okazje-lego/rss'}) async {
    url = getRssUrl(url);
    Uri uri;
    try {
      uri = Uri.parse(url);
      if (!uri.hasScheme) {
        // assume https if missing
        uri = uri.replace(scheme: 'https');
      }
    } catch (e) {
      return [];
    }
    final res = await http.get(uri).timeout(
      const Duration(seconds: 30),
      onTimeout: () {
        throw TimeoutException('RSS fetch timeout');
      }
    );
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
