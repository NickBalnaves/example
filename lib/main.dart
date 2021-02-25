import 'package:flutter/material.dart';
import 'package:gift_card_shopping/models.dart/gift_card.dart';
import 'package:gift_card_shopping/pages/confirmation.dart';
import 'package:gift_card_shopping/pages/detail.dart';
import 'package:gift_card_shopping/pages/home.dart';
import 'package:gift_card_shopping/pages/loading.dart';
import 'package:gift_card_shopping/pages/login.dart';
import 'package:gift_card_shopping/providers/cart.dart';
import 'package:gift_card_shopping/providers/user.dart';
import 'package:gift_card_shopping/services/zip_api.dart';
import 'package:provider/provider.dart';

import 'constants/routes.dart';

void main() {
  final navigatorKey = GlobalKey<NavigatorState>();
  final userNotifier = UserNotifier(navigatorKey: navigatorKey);
  ZipApiService(userNotifier: userNotifier);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserNotifier>.value(value: userNotifier),
        ChangeNotifierProvider<CartNotifier>(
          create: (_) => CartNotifier(),
        ),
      ],
      child: _App(
        navigatorKey: navigatorKey,
      ),
    ),
  );
}

class _App extends StatelessWidget {
  const _App({
    @required this.navigatorKey,
  });

  /// Allowing access to the navigatorKey for providers to allow for navigation
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) => MaterialApp(
        navigatorKey: navigatorKey,
        title: 'Gift card shopping',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: Routes.loading,
        routes: {
          Routes.loading: (_) => LoadingPage(),
          Routes.login: (_) => LoginPage(),
          Routes.home: (_) => HomePage(),
          Routes.detail: (context) => DetailPage(
                giftCard: ModalRoute.of(context).settings.arguments as GiftCard,
              ),
          Routes.confirmation: (_) => ConfirmationPage(),
        },
      );
}
