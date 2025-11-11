import 'package:flutter/material.dart';
import '../models/csv_item.dart';

class CsvItemCardWidget extends StatelessWidget {
  final CsvItem data;
  final VoidCallback? onTap;

  const CsvItemCardWidget({
    super.key,
    required this.data,
    this.onTap,
  });

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
            const SizedBox(height: 4),
            Text('Pieces: ${data.pieceCount}'),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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