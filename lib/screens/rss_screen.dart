import 'package:flutter/material.dart';

class RSSScreen extends StatefulWidget {
  const RSSScreen({super.key});

  @override
  State<StatefulWidget> createState() => _RSSScreenState();
}

class _RSSScreenState extends State<RSSScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('RSS Feed')),
      body: Column(children: [Text('data')]),
    );
  }
}
