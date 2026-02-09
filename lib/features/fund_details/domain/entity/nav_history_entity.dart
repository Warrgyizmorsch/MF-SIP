import 'package:equatable/equatable.dart';
import 'package:my_sip/features/fund_details/data/models/nav_history_model.dart';

class NavHistoryResponseEntity extends Equatable {
  final bool? success;
  final int? schemeCode;
  final String? from;
  final String? to;
  final int? count;
  final List<NavEntryEntity> data;

  const NavHistoryResponseEntity({
    required this.success,
    required this.schemeCode,
    required this.from,
    required this.to,
    required this.count,
    required this.data,
  });

  @override
  List<Object?> get props => [success, schemeCode, from, to, count, data];
}

class NavEntryEntity extends Equatable {
  final String? navDate;
  final double? nav;

  const NavEntryEntity({required this.navDate, required this.nav});

  @override
  List<Object?> get props => [navDate, nav];
}

extension NavEntryEntityX on NavEntry {
  NavEntryEntity toEntity() {
    return NavEntryEntity(navDate: navDate, nav: nav);
  }
}

extension NavHistoryResponseEntityX on NavHistoryResponseModel {
  NavHistoryResponseEntity toEntity() {
    return NavHistoryResponseEntity(
      success: success,
      schemeCode: schemeCode,
      from: from,
      to: to,
      count: count,
      data: data?.map((e) => e.toEntity()).toList() ?? [],
    );
  }
}
