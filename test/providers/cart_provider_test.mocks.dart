// Mocks generated by Mockito 5.1.0 from annotations
// in quickagro/test/providers/cart_provider_test.dart.
// Do not manually edit this file.

import 'dart:ui' as _i3;

import 'package:quickagro/providers/cart_provider.dart' as _i2;
import 'package:mockito/mockito.dart' as _i1;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types

/// A class which mocks [CartProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockCartProvider extends _i1.Mock implements _i2.CartProvider {
  MockCartProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  Map<String, dynamic> get cartItems =>
      (super.noSuchMethod(Invocation.getter(#cartItems),
          returnValue: <String, dynamic>{}) as Map<String, dynamic>);
  @override
  set cartItems(Map<String, dynamic>? _cartItems) =>
      super.noSuchMethod(Invocation.setter(#cartItems, _cartItems),
          returnValueForMissingStub: null);
  @override
  bool get hasListeners =>
      (super.noSuchMethod(Invocation.getter(#hasListeners), returnValue: false)
          as bool);
  @override
  dynamic setDiscount(String? couponId, int? value, String? discountType) =>
      super.noSuchMethod(
          Invocation.method(#setDiscount, [couponId, value, discountType]));
  @override
  dynamic addToCart(
          String? productId,
          String? title,
          String? weight,
          String? price,
          String? stock,
          List<dynamic>? images,
          bool? isBundle) =>
      super.noSuchMethod(Invocation.method(#addToCart,
          [productId, title, weight, price, stock, images, isBundle]));
  @override
  dynamic subtractFromCart(String? productId) =>
      super.noSuchMethod(Invocation.method(#subtractFromCart, [productId]));
  @override
  dynamic removeFromCart(String? productId) =>
      super.noSuchMethod(Invocation.method(#removeFromCart, [productId]));
  @override
  int getQuantity(String? productId) =>
      (super.noSuchMethod(Invocation.method(#getQuantity, [productId]),
          returnValue: 0) as int);
  @override
  void addListener(_i3.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#addListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void removeListener(_i3.VoidCallback? listener) =>
      super.noSuchMethod(Invocation.method(#removeListener, [listener]),
          returnValueForMissingStub: null);
  @override
  void dispose() => super.noSuchMethod(Invocation.method(#dispose, []),
      returnValueForMissingStub: null);
  @override
  void notifyListeners() =>
      super.noSuchMethod(Invocation.method(#notifyListeners, []),
          returnValueForMissingStub: null);
}
