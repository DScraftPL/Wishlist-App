import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Column(
        children: [
          CustomButton(
            text: 'PRZYCISK 1',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const RSSScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
