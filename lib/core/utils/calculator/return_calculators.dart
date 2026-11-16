import 'dart:math';

/// Represents a financial cash flow with an exact calendar date and signed amount.
/// In mutual funds:
/// - Negative amounts represent cash outflows from the investor (Purchases, SIPs).
/// - Positive amounts represent cash inflows to the investor (Redemptions, Current Valuation).
typedef CashFlow = ({DateTime date, double amount});

/// Production-grade financial return calculators supporting CAGR, XIRR, and SEBI/AMFI conventions.
class FinancialCalculators {
  FinancialCalculators._();

  /// Normalizes dates to UTC midnight for consistent day-count calculations.
  static DateTime? parseDate(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    try {
      final d = DateTime.parse(value.trim());
      return DateTime.utc(d.year, d.month, d.day);
    } catch (_) {
      return null;
    }
  }

  /// 1. CAGR for Single Lump-Sum Investments
  ///
  /// Adheres to standard Indian mutual fund (AMFI / SEBI) guidelines:
  /// - For holding periods >= 1 year (365 days): Annualized CAGR formula:
  ///   ((currentValue / initialInvested) ^ (365 / days) - 1) * 100
  /// - For holding periods < 1 year: Absolute Return formula:
  ///   ((currentValue - initialInvested) / initialInvested) * 100
  ///
  /// Returns annualized percentage value (e.g. 15.5 for 15.5%).
  static double? calculateLumpsumReturn({
    required double initialInvested,
    required double currentValue,
    required DateTime investmentDate,
    required DateTime valuationDate,
  }) {
    if (initialInvested <= 0) return null;
    if (currentValue == 0) return -100.0;

    final days = valuationDate.difference(investmentDate).inDays;
    if (days <= 0) return 0.0;

    // For holding period < 1 year, return Absolute Return (not distorted annualized CAGR)
    if (days < 365) {
      return ((currentValue - initialInvested) / initialInvested) * 100.0;
    }

    // For holding period >= 1 year, return Annualized CAGR
    return (pow(currentValue / initialInvested, 365.0 / days) - 1.0) * 100.0;
  }

  /// 2. XIRR for SIPs, Daily/Weekly Installments & Arbitrary Cash Flows
  ///
  /// Solves the standard Net Present Value root:
  /// NPV(r) = sum( C_i / (1 + r)^((d_i - d_1) / 365) ) = 0
  ///
  /// Uses Newton-Raphson method with Bisection fallback.
  /// Handles:
  /// - Daily, weekly, fortnightly, monthly, and irregular SIP dates
  /// - Multi-year investments with intermediate redemptions
  /// - Positive gains and negative market losses (down to -99.99%)
  ///
  /// Returns annualized percentage return (e.g. 24.01 for 24.01%).
  static double? calculateXirr(
    List<CashFlow> cashFlows, {
    double guess = 0.1,
    int maxIterations = 100,
    double tolerance = 1e-6,
  }) {
    if (cashFlows.length < 2) return null;

    final hasOutflow = cashFlows.any((c) => c.amount < 0);
    final hasInflow = cashFlows.any((c) => c.amount > 0);
    if (!hasOutflow || !hasInflow) return null;

    final flows = [...cashFlows]..sort((a, b) => a.date.compareTo(b.date));
    final startDate = flows.first.date;
    final totalDays = flows.last.date.difference(startDate).inDays;
    if (totalDays <= 0) return 0.0;

    // Helper: evaluate NPV and its derivative d(NPV)/dr
    (double npv, double dNpv) evaluate(double rate) {
      double npv = 0.0;
      double dNpv = 0.0;

      for (final flow in flows) {
        final double t = flow.date.difference(startDate).inDays / 365.0;
        final double base = 1.0 + rate;
        if (base <= 0.0) return (double.nan, double.nan);

        final double discount = pow(base, t).toDouble();
        npv += flow.amount / discount;
        dNpv -= (t * flow.amount) / (discount * base);
      }
      return (npv, dNpv);
    }

    // Phase 1: Newton-Raphson Iteration (converges in 5-10 iterations)
    double rate = guess;
    for (int i = 0; i < maxIterations; i++) {
      final (npv, dNpv) = evaluate(rate);

      if (npv.isNaN || dNpv.isNaN || dNpv.abs() < 1e-12) break;
      if (npv.abs() < tolerance) {
        return rate * 100.0;
      }

      final double newRate = rate - (npv / dNpv);
      if (newRate <= -0.9999) {
        rate = (rate - 0.9999) / 2.0;
      } else {
        rate = newRate;
      }
    }

    // Phase 2: Bisection Fallback (if Newton-Raphson didn't reach tolerance)
    double low = -0.9999;
    double high = 10.0; // Up to 1000% annualized return

    double npvLow = evaluate(low).$1;
    double npvHigh = evaluate(high).$1;

    // Expand upper bound if positive
    while (npvHigh > 0 && high < 1e6) {
      high *= 2.0;
      npvHigh = evaluate(high).$1;
    }

    if (npvLow.isNaN || npvHigh.isNaN || npvLow * npvHigh > 0) {
      return null;
    }

    for (int i = 0; i < 100; i++) {
      final mid = (low + high) / 2.0;
      final npvMid = evaluate(mid).$1;

      if (npvMid.abs() < tolerance) {
        return mid * 100.0;
      }

      if (npvLow * npvMid < 0) {
        high = mid;
        npvHigh = npvMid;
      } else {
        low = mid;
        npvLow = npvMid;
      }
    }

    return ((low + high) / 2.0) * 100.0;
  }
}
