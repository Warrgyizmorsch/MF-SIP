import 'package:flutter/material.dart';
import 'package:my_sip/common/widget/appbar/custom_appbar_normal.dart';

import '../../../explore/presentation/pages/explore.dart';

class WatchlistPage extends StatelessWidget {
  const WatchlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBarNormal(title: 'Watchlist'),
      body: ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) =>
            MutualFundCard(isDelete: true, containercolor: Color(0xffFEF0F0)),
      ),
    );
  }
}
