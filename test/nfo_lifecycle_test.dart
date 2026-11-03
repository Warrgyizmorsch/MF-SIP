import 'package:flutter_test/flutter_test.dart';
import 'package:my_sip/core/utils/helper/nfo_lifecycle.dart';
import 'package:my_sip/features/explore/data/model/mutual_fund_list_model.dart';
import 'package:my_sip/features/explore/domain/entities/mutual_fund_list_entity.dart';

MutualFundListEntity fund({
  String? open = '2026-10-16',
  String? close = '2026-10-30',
  String? launch = '2026-11-13',
  bool purchase = true,
  bool sip = true,
  bool lumpsum = true,
}) => MutualFundListModel.fromJson({
  'scheme_code': '154786',
  'is_nfo': true,
  'is_purchase_allowed': purchase,
  'is_sip_allowed': sip,
  'is_lumpsum_allowed': lumpsum,
  'nfo_details': {
    'nfo_open_date': open,
    'nfo_close_date': close,
    'allotment_date': '2026-11-05',
    'launch_date': launch,
    'status': 'CLOSED',
    'is_open': false,
    'days_remaining': -14,
  },
}).toEntity();

void main() {
  NfoLifecycle at(String now, {int? daysRemaining}) => resolveNfoLifecycle(
    isNfo: true,
    openDate: '2026-10-16',
    closeDate: '2026-10-30',
    launchDate: '2026-11-13',
    daysRemaining: daysRemaining,
    now: DateTime.parse(now),
  );

  test('open and close boundaries use India dates and include closing day', () {
    expect(at('2026-10-15T18:29:59.999Z'), NfoLifecycle.upcoming);
    expect(at('2026-10-15T18:30:00Z'), NfoLifecycle.open);
    expect(at('2026-10-30T18:29:59.999Z', daysRemaining: 0), NfoLifecycle.open);
    expect(at('2026-10-30T18:30:00Z'), NfoLifecycle.closed);
  });

  test(
    'allotment does not reopen; launch overrides historical closed flags',
    () {
      final sample = fund();
      expect(
        sample.lifecycleAt(DateTime.parse('2026-11-03T12:00Z')),
        NfoLifecycle.closed,
      );
      expect(
        sample.lifecycleAt(DateTime.parse('2026-11-05T12:00Z')),
        NfoLifecycle.closed,
      );
      expect(
        sample.lifecycleAt(DateTime.parse('2026-11-12T18:29:59.999Z')),
        NfoLifecycle.closed,
      );
      expect(
        sample.lifecycleAt(DateTime.parse('2026-11-12T18:30:00Z')),
        NfoLifecycle.regular,
      );
      expect(
        sample.lifecycleAt(DateTime.parse('2026-11-14T00:00Z')),
        NfoLifecycle.regular,
      );
    },
  );

  test(
    'equivalent instants produce the same lifecycle on overseas devices',
    () {
      expect(at('2026-11-13T00:00:00+05:30'), NfoLifecycle.regular);
      expect(at('2026-11-12T10:30:00-08:00'), NfoLifecycle.regular);
    },
  );

  test('missing or invalid launch cannot reopen a closed offer', () {
    for (final launch in [null, '', 'invalid', '2026-02-30']) {
      expect(
        fund(launch: launch).lifecycleAt(DateTime.utc(2027)),
        NfoLifecycle.closed,
      );
    }
    expect(
      resolveNfoLifecycle(isNfo: false, status: 'CLOSED'),
      NfoLifecycle.regular,
    );
    expect(
      resolveNfoLifecycle(isNfo: true, isOpen: false),
      NfoLifecycle.closed,
    );
  });

  test(
    'zero remaining days is a fallback only when no closing date exists',
    () {
      expect(
        resolveNfoLifecycle(isNfo: true, closeDate: 'bad', daysRemaining: 0),
        NfoLifecycle.closed,
      );
      expect(
        nfoCalendarDate('2026-11-13T00:00:00Z'),
        DateTime.utc(2026, 11, 13),
      );
    },
  );

  test(
    'launch preserves general and per-transaction purchase restrictions',
    () {
      // Historical dates keep this independent of the date the test runs.
      final active = fund(
        open: '2000-01-01',
        close: '2000-01-02',
        launch: '2000-01-03',
        sip: false,
      );
      expect(active.isNfoOffer, isFalse);
      expect(active.isNfoClosed, isFalse);
      expect(active.isPurchasePaused, isFalse);
      expect(active.canBuySip, isFalse);
      expect(active.canBuyLumpsum, isTrue);
      final paused = fund(launch: '2000-01-03', purchase: false);
      expect(paused.isNfoClosed, isFalse);
      expect(paused.isPurchasePaused, isTrue);
      expect(paused.toLaunchDataEntity().isPurchasePaused, isTrue);
      expect(
        fund(launch: '2000-01-03', sip: false, lumpsum: false).isPurchasePaused,
        isTrue,
      );
    },
  );

  test(
    'upcoming and closed offers block purchases and retain details permissions',
    () {
      final upcoming = fund(
        open: '2999-01-01',
        close: '2999-01-02',
        launch: '2999-01-03',
      );
      expect(upcoming.isNfoUpcoming, isTrue);
      expect(upcoming.isPurchasePaused, isTrue);
      expect(upcoming.toLaunchDataEntity().lifecycle, NfoLifecycle.upcoming);
      expect(upcoming.toLaunchDataEntity().isPurchasePaused, isTrue);
      final closed = fund(close: '2000-01-02', launch: '2999-01-03');
      expect(closed.isNfoClosed, isTrue);
      expect(closed.canBuySip, isFalse);
      expect(closed.canBuyLumpsum, isFalse);
      expect(closed.toLaunchDataEntity().isPurchasePaused, isTrue);
    },
  );
}
