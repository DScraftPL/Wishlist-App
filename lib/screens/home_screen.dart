import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishlist_app/screens/exp_screen.dart';
import 'package:wishlist_app/screens/rss_screen.dart';
import 'package:wishlist_app/services/data_service.dart';
import 'package:wishlist_app/widgets/data_health.dart';
import '../widgets/custom_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final ds = Provider.of<DataService>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Home Screen')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Column(
              children: [
                CustomButton(
                  text: 'Dane RSS z PromoKlocki.pl',
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
                  text: 'Lista odchodzących zestawów',
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
            LoadingStatusWidget(
              isCsvLoading: ds.csvLoading,
              isRssLoading: ds.rssLoading,
              isParseRssLoading: ds.parseCsvLoading,
              isLoading: ds.loading,
              error: ds.error,
              onRestart: ds.init,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(onPressed: () => {}),
    );
  }
}
