import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'models/wishlist.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => WishlistModel(),
    child: const MyApp(),
  ));

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Wishlist App', home: const HomeScreen());
  }
}
