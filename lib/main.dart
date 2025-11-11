import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'package:provider/provider.dart';
import 'package:wishlist_app/services/data_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // create DataService instance so we can start initialization in background
  final dataService = DataService();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider.value(value: dataService)],
      child: const MyApp(),
    ),
  );

  // initialize data after the first frame so app shows quickly
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
