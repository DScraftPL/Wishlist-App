import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:wishlist_app/models/wishlist.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:wishlist_app/services/data_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final dataService = DataService();

  await Hive.initFlutter();

  Hive.registerAdapter(WishlistItemAdapter());

  await Hive.openBox<WishlistItem>('wishlistBox');

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider.value(value: dataService)],
      child: const MyApp(),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    dataService.init();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'Flutter Wishlist App', home: const HomeScreen());
  }
}
