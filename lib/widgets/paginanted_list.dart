import 'package:flutter/material.dart';
import 'package:wishlist_app/helpers/local_pager.dart';

class PaginantedList<T> extends StatelessWidget {
  final LocalPager<T> pager;
  final Widget Function(T item) itemBuilder;

  const PaginantedList({
    super.key,
    required this.pager,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scroll) {
        if (scroll.metrics.pixels >= scroll.metrics.maxScrollExtent - 150) {
          pager.loadNextPage();
        }
        return false;
      },
      child: AnimatedBuilder(
        animation: pager,
        builder: (_, _) {
          final items = pager.items;

          return Scrollbar(
            child: ListView.builder(
              itemCount: items.length + (pager.hasMore ? 1 : 0),
              itemBuilder: (_, index) {
                if (index == items.length) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                return itemBuilder(items[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
