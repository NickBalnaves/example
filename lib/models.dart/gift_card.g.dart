// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiftCard _$GiftCardFromJson(Map<String, dynamic> json) {
  return GiftCard(
    vendor: json['vendor'] as String,
    id: json['id'] as String,
    brand: json['brand'] as String,
    image: json['image'] as String,
    denominations: (json['denominations'] as List)
        ?.map((e) =>
            e == null ? null : Denomination.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    position: json['position'] as int,
    discount: (json['discount'] as num)?.toDouble(),
    terms: json['terms'] as String,
    importantContent: json['importantContent'] as String,
    cardTypeStatus:
        _$enumDecodeNullable(_$CardTypeStatusEnumMap, json['cardTypeStatus']),
    customDenominations: (json['customDenominations'] as List)
        ?.map((e) => e == null
            ? null
            : CustomDenomination.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    disclaimer: json['disclaimer'] as String,
    termsLink: json['termsLink'] as String,
    isFixedValue: json['isFixedValue'] as bool,
  );
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$CardTypeStatusEnumMap = {
  CardTypeStatus.available: 'AVAILABLE',
};

CustomDenomination _$CustomDenominationFromJson(Map<String, dynamic> json) {
  return CustomDenomination(
    minPrice: json['minPrice'] as int,
    maxPrice: json['maxPrice'] as int,
  );
}

Denomination _$DenominationFromJson(Map<String, dynamic> json) {
  return Denomination(
    price: json['price'],
    currency: _$enumDecodeNullable(_$CurrencyEnumMap, json['currency']),
    stock: _$enumDecodeNullable(_$StockEnumMap, json['stock']),
  );
}

const _$CurrencyEnumMap = {
  Currency.aud: 'AUD',
};

const _$StockEnumMap = {
  Stock.inStock: 'IN_STOCK',
  Stock.lowStock: 'LOW_STOCK',
  Stock.outOfStock: 'OUT_OF_STOCK',
};
