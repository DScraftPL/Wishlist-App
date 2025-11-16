import 'package:flutter/material.dart';
import 'package:wishlist_app/models/rebrickable/set_item.dart';

class ParsedSetItemCard extends StatelessWidget {
  final ParsedSetItem item;

  const ParsedSetItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.setName,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text("Set Number: ${item.setNumber}"),
            Text("Theme: ${item.themeName}"),
            Text("Pieces: ${item.pieceCount}"),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () {
                // Open link
              },
              child: Text(
                item.link,
                style: const TextStyle(
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
