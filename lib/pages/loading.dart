import 'package:flutter/material.dart';
import 'package:gift_card_shopping/providers/user.dart';
import 'package:provider/provider.dart';

import '../providers/user.dart';

/// Loading page
/// This is the first page the user sees before navigating to
/// the login page or other pages
class LoadingPage extends StatefulWidget {
  @override
  _LoadingPageState createState() => _LoadingPageState();
}

class _LoadingPageState extends State<LoadingPage> {
  @override
  void initState() {
    super.initState();

    /// Starts initialisation of user data
    context.read<UserNotifier>().init();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(
                Icons.card_giftcard,
                size: 50,
              ),
              SizedBox(height: 16),
              CircularProgressIndicator(),
            ],
          ),
        ),
      );
}
