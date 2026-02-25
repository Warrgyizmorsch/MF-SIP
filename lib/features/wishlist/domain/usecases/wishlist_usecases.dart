import 'package:my_sip/features/wishlist/domain/usecases/addwishlist_usecases.dart';
import 'package:my_sip/features/wishlist/domain/usecases/deleteWishlist_usecases.dart';
import 'package:my_sip/features/wishlist/domain/usecases/fetchWishlist_usecases.dart';

class WishlistUsecases {
  final AddwishlistUsecases addwishlistUsecases;
  final FetchwishlistUsecases fetchwishlistUsecases;
  final DeleteWishlistUsecase deleteWishlistUsecase;

  WishlistUsecases(this.addwishlistUsecases, this.fetchwishlistUsecases, this.deleteWishlistUsecase);
}
