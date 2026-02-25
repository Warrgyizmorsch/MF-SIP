import 'package:equatable/equatable.dart';
import 'package:my_sip/features/wishlist/data/model/wishlist_model.dart';

class WishlistEntity extends Equatable {
  final bool success;
  final int? count;
  final List<WishlistDataEntity>? data;

  const WishlistEntity({
    required this.success,
    required this.count,
    required this.data,
  });
  @override
  List<Object?> get props => [success, count, data];
}

extension WishlistModelX on WishlistResponseModel {
  WishlistEntity toEntity() {
    return WishlistEntity(
      success: success,
      count: count,
      data: data?.map((e) => e.toEntity()).toList(),
    );
  }
}

class WishlistDataEntity extends Equatable {
  final int? wishlistId;
  final String? schemeName;
  final String? schemeCode;
  final String? riskLevel;
  final WishlistReturnsEntity? returns;
  final String? amcLogo;

  const WishlistDataEntity({
    required this.wishlistId,
    required this.schemeName,
    required this.schemeCode,
    required this.riskLevel,
    required this.returns,
    required this.amcLogo,
  });

  @override
  List<Object?> get props => [
    wishlistId,
    schemeName,
    schemeCode,
    riskLevel,
    returns,
    amcLogo,
  ];
}

extension WishlistDataModelX on WishListData {
  WishlistDataEntity toEntity() {
    return WishlistDataEntity(
      wishlistId: wishlistId,
      schemeName: schemeName,
      schemeCode: schemeCode,
      riskLevel: riskLevel,
      returns: returns?.toEntity(),
      amcLogo: amcLogo,
    );
  }
}

class WishlistReturnsEntity extends Equatable {
  final String? oneYear;
  final String? threeYear;
  final String? fiveYear;
  final String? tenYear;

  const WishlistReturnsEntity({
    this.oneYear,
    this.threeYear,
    this.fiveYear,
    this.tenYear,
  });

  @override
  List<Object?> get props => [oneYear, threeYear, fiveYear, tenYear];
}

extension WishListReturnModelX on WishlistReturns {
  WishlistReturnsEntity toEntity() {
    return WishlistReturnsEntity(
      oneYear: oneYear,
      threeYear: threeYear,
      fiveYear: fiveYear,
      tenYear: tenYear,
    );
  }
}
