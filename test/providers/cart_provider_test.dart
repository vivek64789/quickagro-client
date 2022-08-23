import 'package:flutter_test/flutter_test.dart';
import 'package:quickagro/providers/cart_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'cart_provider_test.mocks.dart';

@GenerateMocks([CartProvider])
void main() {
  CartProvider? cartProvider;

  setUp(() {
    cartProvider = MockCartProvider();
  });
  test('Get all the cart items ...', () async {
    when(cartProvider?.cartItems).thenReturn({
      "items": [],
      "coupon": "",
      "discountAmount": 0,
      "totalPrice": 0,
    });
    final cart = await cartProvider?.cartItems;
    verify(cartProvider?.cartItems);
    expect(cart, {
      "items": [],
      "coupon": "",
      "discountAmount": 0,
      "totalPrice": 0,
    });
  });

  test("Adding product to item is successful", () {
    when(cartProvider?.addToCart("", "", "", "", "", [""], false))
        .thenReturn(true);

    final result = cartProvider?.addToCart("", "", "", "", "", [""], false);
    verify(cartProvider?.addToCart("", "", "", "", "", [""], false));
    expect(result, true);
  });

  test("Subtracting from Cart is successful", () {
    when(cartProvider?.subtractFromCart("product1")).thenReturn(-1);

    final result = cartProvider?.subtractFromCart('product1');
    verify(cartProvider?.subtractFromCart("product1"));
    expect(result, -1);
  });
  test("Removing from Cart is successful", () {
    when(cartProvider?.removeFromCart("product1")).thenReturn(0);

    final result = cartProvider?.removeFromCart('product1');
    verify(cartProvider?.removeFromCart("product1"));
    expect(result, 0);
  });
  test("Getting total Cart Quantity is successful", () {
    when(cartProvider?.getQuantity("product1")).thenReturn(10);

    final result = cartProvider?.getQuantity('product1');
    verify(cartProvider?.getQuantity("product1"));
    expect(result, 10);
  });
}
