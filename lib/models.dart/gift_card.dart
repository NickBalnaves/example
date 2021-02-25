import 'package:json_annotation/json_annotation.dart';

part 'gift_card.g.dart';

@JsonSerializable()
class GiftCard {
  GiftCard({
    this.vendor,
    this.id,
    this.brand,
    this.image,
    this.denominations,
    this.position,
    this.discount,
    this.terms,
    this.importantContent,
    this.cardTypeStatus,
    this.customDenominations,
    this.disclaimer,
    this.termsLink,
    this.isFixedValue,
  });

  String vendor;
  String id;
  String brand;
  String image;
  List<Denomination> denominations;
  int position;
  double discount;
  String terms;
  String importantContent;
  CardTypeStatus cardTypeStatus;
  List<CustomDenomination> customDenominations;
  String disclaimer;
  String termsLink;
  bool isFixedValue;

  factory GiftCard.fromJson(Map<String, dynamic> json) =>
      _$GiftCardFromJson(json);
}

enum CardTypeStatus {
  @JsonValue("AVAILABLE")
  available,
}

@JsonSerializable()
class CustomDenomination {
  CustomDenomination({
    this.minPrice,
    this.maxPrice,
  });

  int minPrice;
  int maxPrice;

  factory CustomDenomination.fromJson(Map<String, dynamic> json) =>
      _$CustomDenominationFromJson(json);
}

@JsonSerializable()
class Denomination {
  Denomination({
    this.price,
    this.currency,
    this.stock,
  });

  dynamic price;
  Currency currency;
  Stock stock;

  factory Denomination.fromJson(Map<String, dynamic> json) =>
      _$DenominationFromJson(json);
}

enum Currency {
  @JsonValue("AUD")
  aud,
}

enum Stock {
  @JsonValue("IN_STOCK")
  inStock,
  @JsonValue("LOW_STOCK")
  lowStock,
  @JsonValue("OUT_OF_STOCK")
  outOfStock,
}
