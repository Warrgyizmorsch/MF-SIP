import 'package:my_sip/features/cart/domain/usecases/add_to_cart_usecases.dart';
import 'package:my_sip/features/cart/domain/usecases/delete_cart_item_usecases.dart';
import 'package:my_sip/features/cart/domain/usecases/get_cart_list_usecases.dart';
import 'package:my_sip/features/cart/domain/usecases/update_cart_usecases.dart';

class CartUsecases {
  final AddToCartUsecases addToCartUsecases;
  final GetCartListUsecases getCartListUsecases;
  final UpdateCartUsecases updateCartUsecases;
  final DeleteCartItemUsecases deleteCartItemUsecases ;

  CartUsecases(
    this.addToCartUsecases,
    this.getCartListUsecases,
    this.updateCartUsecases,
    this.deleteCartItemUsecases 
  );
}
