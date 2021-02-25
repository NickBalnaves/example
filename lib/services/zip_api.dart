import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gift_card_shopping/models.dart/gift_card.dart';
import 'package:http/http.dart';
import 'package:retry/retry.dart';

import '../providers/user.dart';

/// Service helper methods for API calls
class ZipApiService {
  factory ZipApiService({
    @required UserNotifier userNotifier,
  }) =>
      _instance ??= ZipApiService._internal(
        userNotifier: userNotifier,
      );

  ZipApiService._internal({
    @required this.userNotifier,
  });

  static ZipApiService _instance;

  /// A user change notifier instance for retrieving user data
  final UserNotifier userNotifier;

  /// Cached instance of [ZipApiService];
  static ZipApiService get instance => _instance;

  /// Wrapper for all API calls
  Future<List> _callAPI(String endpoint) async {
    try {
      final response = await retry(
        () => get('https://zip.co/$endpoint'),
        retryIf: (e) => e is SocketException,
      );

      /// API requests logging in debug mode
      if (!kReleaseMode) {
        log('');
        log('request url: ${response.request.url}');
        log('response status code: ${response.statusCode}');
        // log('response body: ${utf8.decode(response.bodyBytes)}');
        log('');
      }
      return json.decode(
        utf8.decode(response.bodyBytes),
      ) as List;

      ///Log out the user if the user is still offline after exhausting all of our retries
    } on SocketException catch (error) {
      log(error.message);
      await userNotifier?.signOut();
    } on Exception catch (e) {
      log('$e');
      await userNotifier?.signOut();
    }
    return [];
  }

  Future<List<GiftCard>> getGiftCards() async => List<GiftCard>.from(
        (await _callAPI(
          'giftcards/api/giftcards',
        ))
            .map(
          (x) => GiftCard.fromJson(x as Map<String, dynamic>),
        ),
      );
}
