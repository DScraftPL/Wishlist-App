import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishlist_app/models/wishlist.dart';
import 'package:wishlist_app/screens/exp_screen.dart';
import 'package:wishlist_app/screens/rss_screen.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final model = context.watch<WishlistModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                CustomButton(
                  text: 'PRZYCISK 1',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RSSScreen(),
                      ),
                    );
                  },
                ),
                CustomButton(
                  text: 'PRZYCISK 2',
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ExpScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            Expanded(
              child: model.items.isEmpty
                  ? const Center(child: Text('no items'))
                  : ListView.builder(
                      itemCount: model.items.length,
                      itemBuilder: (context, index) {
                        final item = model.items[index];
                        return Card(
                          child: ListTile(
                            title: Text(item),
                            trailing: IconButton(
                              onPressed: () => model.removeAt(index),
                              icon: const Icon(Icons.delete),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => {}),
    );
  }
}
