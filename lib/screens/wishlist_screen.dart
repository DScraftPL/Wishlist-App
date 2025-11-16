import 'package:flutter/material.dart';
import 'package:wishlist_app/helpers/local_pager.dart';
import 'package:wishlist_app/screens/add_wishlist.dart';
import 'package:wishlist_app/services/wishlist_service.dart';
import 'package:wishlist_app/widgets/paginanted_list.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<StatefulWidget> createState() => _WishlistState();
}

class _WishlistState extends State<WishlistScreen> {
  @override
  Widget build(BuildContext context) {
    final entires = WishlistService.getAllEntry();
    final pager = LocalPager(entires);

    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist Screen')),
      body: entires.isEmpty
          ? const Center(child: Text("Entries are empty"))
          : Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Expanded(
                    child: PaginantedList(
                      pager: pager,
                      itemBuilder: (item) => Text(item.setName),
                    ),
                  ),
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddWishlistScreen()),
          ),
        },
      ),
    );
  }
}
