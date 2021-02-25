import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:gift_card_shopping/constants/routes.dart';
import 'package:gift_card_shopping/models.dart/gift_card.dart';
import 'package:gift_card_shopping/providers/cart.dart';
import 'package:gift_card_shopping/providers/user.dart';
import 'package:provider/provider.dart';

/// Home page
/// The user can view gift cards and their shopping cart from this page
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<UserNotifier>().signOut();
              },
            ),
          ],
          bottom: isTablet
              ? null
              : const TabBar(
                  tabs: [
                    Tab(icon: Icon(Icons.card_giftcard)),
                    Tab(icon: Icon(Icons.shopping_cart)),
                  ],
                ),
        ),
        body: isTablet
            ? Row(
                children: const [
                  Expanded(child: _GiftCardView()),
                  Expanded(child: _ShoppingCartView()),
                ],
              )
            : const TabBarView(
                children: [
                  _GiftCardView(),
                  _ShoppingCartView(),
                ],
              ),
      ),
    );
  }
}

class _ShoppingCartView extends StatelessWidget {
  const _ShoppingCartView();

  @override
  Widget build(BuildContext context) {
    final cartNotifier = context.watch<CartNotifier>();
    if (cartNotifier.quantities.isEmpty) {
      return const Center(
        child: Text('No gift cards have been added to your shopping cart'),
      );
    }
    return ListView(
      children: [
        for (final brand in cartNotifier.quantities.entries) ...[
          Padding(
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Center(
              child: Text(
                brand.key,
                style: Theme.of(context).textTheme.headline6,
              ),
            ),
          ),
          for (final quantities in brand.value.entries)
            Center(
              child: SizedBox(
                width: 200,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        style: const TextStyle(color: Colors.black),
                        children: [
                          const TextSpan(text: '\$'),
                          TextSpan(text: '${quantities.key}'),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => cartNotifier.removeFromCart(
                            brand.key,
                            quantities.key,
                          ),
                        ),
                        Text('${quantities.value}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => cartNotifier.addToCart(
                            brand.key,
                            quantities.key,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
        ],
        const SizedBox(height: 16),
        Align(
          child: SizedBox(
            width: 200,
            child: RaisedButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  Routes.confirmation,
                );
                context.read<CartNotifier>().checkoutCart();
              },
              child: const Text('CHECK OUT'),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _GiftCardView extends StatelessWidget {
  const _GiftCardView();

  @override
  Widget build(BuildContext context) => FutureBuilder<List<GiftCard>>(
        future: getGiftCards(),
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            children: [
              for (final card in snapshot.data)
                ListTile(
                  title: Text(
                      '${card.brand} - ${(100 - card.discount).toStringAsFixed(2)}%'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(card.vendor),
                      FlatButton(
                        onPressed: () => Navigator.of(context).pushNamed(
                          Routes.detail,
                          arguments: card,
                        ),
                        child: const Text('DETAIL'),
                      )
                    ],
                  ),
                  trailing: CachedNetworkImage(
                    imageUrl: card.image,
                    placeholder: (context, url) => Container(),
                    width: 100,
                  ),
                ),
            ],
          );
        },
      );
}
