import 'package:cached_network_image/cached_network_image.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gift_card_shopping/constants/routes.dart';
import 'package:gift_card_shopping/models.dart/gift_card.dart';
import 'package:gift_card_shopping/providers/cart.dart';
import 'package:provider/provider.dart';

/// Detail page
/// The user can see more details about a gift card and add denominations to the shopping cart
class DetailPage extends StatelessWidget {
  const DetailPage({
    @required this.giftCard,
  });

  final GiftCard giftCard;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(
              '${giftCard.brand} - ${(100 - giftCard.discount).toStringAsFixed(2)}%'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                CachedNetworkImage(imageUrl: giftCard.image),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: SizedBox(
                    width: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(giftCard.terms),
                        if (giftCard.termsLink != null)
                          Text(giftCard.termsLink),
                        const SizedBox(height: 8),
                        _Stock(giftCard: giftCard),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class _Stock extends StatefulWidget {
  const _Stock({
    @required this.giftCard,
  });

  final GiftCard giftCard;

  @override
  __StockState createState() => __StockState();
}

class __StockState extends State<_Stock> {
  Map<dynamic, int> localQuantities = {};

  @override
  void initState() {
    localQuantities =
        context.read<CartNotifier>().quantities[widget.giftCard.brand] ?? {};
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final demonination in widget.giftCard.denominations)
          Center(
            child: SizedBox(
              width: 250,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StockDescription(demonination: demonination),
                  if (demonination.stock != Stock.outOfStock)
                    Row(
                      children: [
                        if (localQuantities.containsKey(demonination.price) &&
                            localQuantities[demonination.price] != 0)
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () => setState(
                                () => localQuantities[demonination.price]--),
                          ),
                        Text('${localQuantities[demonination.price] ?? 0}'),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => setState(
                            () =>
                                localQuantities.containsKey(demonination.price)
                                    ? localQuantities[demonination.price]++
                                    : localQuantities[demonination.price] = 1,
                          ),
                        ),
                      ],
                    )
                  else
                    const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        _CartButtons(
          localQuantities: localQuantities,
          giftCard: widget.giftCard,
        ),
      ],
    );
  }
}

class _CartButtons extends StatelessWidget {
  const _CartButtons({
    Key key,
    @required this.localQuantities,
    @required this.giftCard,
  }) : super(key: key);

  final Map<dynamic, int> localQuantities;
  final GiftCard giftCard;

  @override
  Widget build(BuildContext context) {
    final cartNotifier = context.watch<CartNotifier>();
    return Column(
      children: [
        Center(
          child: RaisedButton(
            onPressed: localQuantities.isEmpty ||
                    mapEquals(
                      cartNotifier.quantities[giftCard.brand],
                      localQuantities,
                    )
                ? null
                : () {
                    cartNotifier.addItemsToCart(
                      giftCard.brand,
                      Map.from(localQuantities),
                    );
                    Scaffold.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Gift cards successfully added to cart'),
                      ),
                    );
                  },
            child: const Text('ADD TO CART'),
          ),
        ),
        const SizedBox(height: 8),
        Center(
          child: RaisedButton(
            onPressed: cartNotifier.quantities.isEmpty
                ? null
                : () {
                    cartNotifier.checkoutCart();
                    Navigator.of(context).pushReplacementNamed(
                      Routes.confirmation,
                    );
                  },
            child: const Text('BUY NOW'),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _StockDescription extends StatelessWidget {
  const _StockDescription({
    Key key,
    @required this.demonination,
  }) : super(key: key);

  final Denomination demonination;

  @override
  Widget build(BuildContext context) => RichText(
        text: TextSpan(
          style: const TextStyle(color: Colors.black),
          children: [
            if (demonination.currency == Currency.aud)
              const TextSpan(text: '\$'),
            TextSpan(text: '${demonination.price}'),
            const TextSpan(text: ' - '),
            TextSpan(
              text: EnumToString.convertToString(
                demonination.stock,
                camelCase: true,
              ),
            ),
          ],
        ),
      );
}
