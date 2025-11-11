import 'package:flutter/material.dart';
import 'package:wishlist_app/models/parsed_rss_item.dart';

class RssItemCardWidget extends StatelessWidget {
  final ParsedRssItem data;
  final VoidCallback? onTap;

  const RssItemCardWidget({super.key, required this.data, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        onTap: onTap,
        title: Text('${data.setName} • ${data.setNumber}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text('Theme: ${data.theme}'),
            if( data.pieceCount != 'Unknown') ...[
            const SizedBox(height: 4),
            Text('Pieces: ${data.pieceCount}'),
            ],
            if (data.discountPrice.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                'Price: ${data.discountPrice}',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ),
            ],
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min, // Add this
          children: [
            const Icon(Icons.calendar_today, size: 18),
            const SizedBox(height: 4),
            Text(
              data.retirementDate,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
