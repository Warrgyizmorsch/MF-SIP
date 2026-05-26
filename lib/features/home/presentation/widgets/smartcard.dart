import 'dart:async';
import 'package:flutter/material.dart';

class SmartDiscoverySwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    // Logic: If it's the last half of March (Financial Year End in India)
    bool isTaxCrunchTime = (now.month == 3 && now.day >= 15);
    // bool isTaxCrunchTime = false;

    return isTaxCrunchTime ? TaxCountdownCard() : FeaturedFundCard();
  }
}

// --- OPTION 1: THE TAX SAVING CARD (Active Now) ---
class TaxCountdownCard extends StatefulWidget {
  @override
  _TaxCountdownCardState createState() => _TaxCountdownCardState();
}

class _TaxCountdownCardState extends State<TaxCountdownCard> {
  late Duration _timeLeft;

  @override
  void initState() {
    super.initState();
    _calculateTime();
  }

  void _calculateTime() {
    final deadline = DateTime(2026, 4, 1); // Financial Year End
    _timeLeft = deadline.difference(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade50, Colors.white],
          begin: Alignment.topLeft,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, size: 40, color: Colors.orange.shade800),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "TAX SAVER",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade900,
                        letterSpacing: 1.2,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade800,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        "${_timeLeft.inDays} Days Left",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                Text(
                  "Save ₹46,800 in Tax",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Invest in ELSS before March 31st.",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- OPTION 2: THE FEATURED FUND CARD (Rest of Year) ---
class FeaturedFundCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
        boxShadow: [
          BoxShadow(color: Colors.blue.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: Icon(Icons.trending_up, color: Colors.blue.shade700),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "FEATURED FUND",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade300,
                  ),
                ),
                Text(
                  "Nifty 50 Index Fund",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                Text(
                  "Low cost • 14.2% Annual Return",
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
          Icon(Icons.chevron_right, color: Colors.blue),
        ],
      ),
    );
  }
}
