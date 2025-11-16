// MADE BY CLAUDE.AI

import 'package:flutter/material.dart';

class LoadingStatusWidget extends StatelessWidget {
  final bool isCsvLoading;
  final bool isRssLoading;
  final bool isParseRssLoading;
  final bool isLoading;
  final String? error;
  final VoidCallback onRestart;

  const LoadingStatusWidget({
    super.key,
    required this.isCsvLoading,
    required this.isRssLoading,
    required this.isParseRssLoading,
    required this.isLoading,
    this.error,
    required this.onRestart
  });

  @override
  Widget build(BuildContext context) {
    // if (!isLoading && error == null) {
    //   return const SizedBox.shrink();
    // }

    if (error != null) {
      return Card(
        color: Colors.red.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.error, color: Colors.red.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Error: $error',
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
              TextButton(onPressed: onRestart, child: Text('Restart'))
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Status ładowania danych',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            _LoadingItem(
              label: 'Dane o odchodzących zestawach',
              isLoading: isCsvLoading,
            ),
            const SizedBox(height: 8),
            _LoadingItem(
              label: 'Dane z RSS',
              isLoading: isRssLoading,
            ),
            const SizedBox(height: 8),
            _LoadingItem(
              label: 'Przetworzenie danych z RSS',
              isLoading: isParseRssLoading,
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingItem extends StatelessWidget {
  final String label;
  final bool isLoading;

  const _LoadingItem({
    required this.label,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: isLoading
              ? CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                )
              : Icon(
                  Icons.check_circle,
                  color: Colors.green.shade600,
                  size: 20,
                ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: isLoading ? Colors.grey.shade700 : Colors.green.shade700,
            fontWeight: isLoading ? FontWeight.normal : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}