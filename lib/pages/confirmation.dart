import 'package:flutter/material.dart';

/// Confirmation page
/// The user is presented with a success message for having
/// successfully purchased their gift cards
class ConfirmationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Column(
              children: const [
                Text('Successfully purchased gift cards, thanks!'),
              ],
            ),
          ),
        ),
      );
}
