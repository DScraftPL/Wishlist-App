import 'package:flutter/material.dart';
import 'package:wishlist_app/models/wishlist.dart';

class WishlistCard extends StatelessWidget {
  final WishlistItem item;
  final VoidCallback? onTap;

  const WishlistCard({super.key, required this.item, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
      child: ListTile(
        onTap: onTap,
        title: Text('${item.setName} • ${item.setNumber}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text('Theme: ${item.theme}'),
            const SizedBox(height: 4),
            Text('Pieces: ${item.pieceCount}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, size: 18),
            const SizedBox(height: 4),
            Text(
              item.retirmentDate,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
