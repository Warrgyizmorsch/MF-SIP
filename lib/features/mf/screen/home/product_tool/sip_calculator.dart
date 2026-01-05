import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:my_sip/common/style/padding.dart';
import 'package:my_sip/utils/constant/colors.dart';
import 'package:my_sip/utils/constant/images.dart';
import 'package:my_sip/utils/constant/text_style.dart';

class SipCalculatorPage extends StatefulWidget {
  const SipCalculatorPage({super.key});

  @override
  State<SipCalculatorPage> createState() => _SipCalculatorPageState();
}

class _SipCalculatorPageState extends State<SipCalculatorPage> {
  double monthlyInvestment = 5000;
  double returnRate = 11.9;
  double years = 5;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: UPadding.screenPadding,
          child: DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SIP Calculator',
                  style: UTextStyles.medium.copyWith(
                    color: Ucolors.dark,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Tab(
                  child: TabBar(
                    tabAlignment: TabAlignment.start,
                    // dividerHeight: 40,
                    isScrollable: true,
                    unselectedLabelColor: Colors.grey,
                    dividerColor: Colors.transparent,
                    labelColor: Ucolors.primary,
                    indicatorColor: Colors.transparent,
                    labelPadding: EdgeInsets.symmetric(vertical: 5),

                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),

                      color: Ucolors.primary.withOpacity(0.1),
                    ),

                    // indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('SIP', style: TextStyle(fontSize: 12)),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text('Lumpsum', style: TextStyle(fontSize: 12)),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 700,
                  child: TabBarView(
                    children: [
                      //Sip calci
                      Column(
                        children: [
                          SipSliderTile2(
                            title: 'Monthly Investment',
                            value: monthlyInvestment,
                            min: 500,
                            max: 100000,
                            // valueFormatter: (val) => '₹ ${val.toInt()}',
                            suffix: '₹',

                            onChanged: (value) {
                              setState(() {
                                monthlyInvestment = value;
                              });
                            },
                          ),
                          SipSliderTile2(
                            title: 'Expected return rate (p.a)',
                            value: returnRate,
                            min: 1,
                            max: 30,
                            // valueFormatter: (val) => '${val.toStringAsFixed(1)}%',
                            suffix: '%',
                            onChanged: (val) {
                              setState(() {
                                returnRate = val;
                              });
                            },
                          ),

                          SipSliderTile2(
                            title: 'Total period',

                            suffix: 'Years',
                            onChanged: (val) {
                              setState(() {
                                years = val;
                              });
                            },

                            value: years,
                            min: 1,
                            max: 30,
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Ucolors.borderside),
                            ),
                            child: Column(
                              children: [
                                fulldetails(
                                  'Investment amount ',
                                  '284662',
                                  Ucolors.primary.withOpacity(0.7),
                                ),
                                Gap(20),
                                fulldetails(
                                  'Est Returns ',
                                  '284662',
                                  Ucolors.primary,
                                ),
                                Gap(20),
                                fulldetails(
                                  'Total Value',
                                  '284662',
                                  Ucolors.dark,
                                ),
                                Gap(20),

                                SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: PieChart(
                                    PieChartData(
                                      sectionsSpace: 0,
                                      sections: [
                                        PieChartSectionData(
                                          showTitle: false,
                                          value: 70,
                                          color: Ucolors.primary,
                                        ),
                                        PieChartSectionData(
                                          showTitle: false,
                                          color: Ucolors.primary.withOpacity(
                                            0.1,
                                          ),
                                          value: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Gap(20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color: Ucolors.primary.withOpacity(
                                              0.1,
                                            ),
                                          ),
                                        ),
                                        Gap(5),
                                        Text(
                                          'Invest amount',
                                          style: UTextStyles.caption,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color: Ucolors.primary,
                                          ),
                                        ),
                                        Gap(5),
                                        Text(
                                          'Est Returns',
                                          style: UTextStyles.caption,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      //Lumpsum
                      Column(
                        children: [
                          SipSliderTile2(
                            title: 'Total Investment',
                            value: monthlyInvestment,
                            min: 500,
                            max: 100000,
                            // valueFormatter: (val) => '₹ ${val.toInt()}',
                            suffix: '₹',

                            onChanged: (value) {
                              setState(() {
                                monthlyInvestment = value;
                              });
                            },
                          ),
                          SipSliderTile2(
                            title: 'Expected return rate (p.a)',
                            value: returnRate,
                            min: 1,
                            max: 30,
                            // valueFormatter: (val) => '${val.toStringAsFixed(1)}%',
                            suffix: '%',
                            onChanged: (val) {
                              setState(() {
                                returnRate = val;
                              });
                            },
                          ),

                          SipSliderTile2(
                            title: 'Total period',

                            suffix: 'Years',
                            onChanged: (val) {
                              setState(() {
                                years = val;
                              });
                            },

                            value: years,
                            min: 1,
                            max: 30,
                          ),

                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 15,
                              vertical: 15,
                            ),
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(color: Ucolors.borderside),
                            ),
                            child: Column(
                              children: [
                                fulldetails(
                                  'Investment amount ',
                                  '284662',
                                  Ucolors.primary.withOpacity(0.7),
                                ),
                                Gap(20),
                                fulldetails(
                                  'Est Returns ',
                                  '284662',
                                  Ucolors.primary,
                                ),
                                Gap(20),
                                fulldetails(
                                  'Total Value',
                                  '284662',
                                  Ucolors.dark,
                                ),
                                Gap(20),

                                SizedBox(
                                  height: 200,
                                  width: 200,
                                  child: PieChart(
                                    // curve: Curves.bounceIn,
                                    PieChartData(
                                      pieTouchData: PieTouchData(enabled: true),
                                      sectionsSpace: 0,
                                      sections: [
                                        PieChartSectionData(
                                          // showTitle: false,
                                          // badgeWidget: Text('data'),
                                          showTitle: false,
                                          value: 70,
                                          color: Ucolors.primary,
                                        ),
                                        PieChartSectionData(
                                          showTitle: false,
                                          color: Ucolors.primary.withOpacity(
                                            0.1,
                                          ),
                                          value: 30,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),

                                Gap(20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color: Ucolors.primary.withOpacity(
                                              0.1,
                                            ),
                                          ),
                                        ),
                                        Gap(5),
                                        Text(
                                          'Invest amount',
                                          style: UTextStyles.caption,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          width: 20,
                                          height: 10,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                            color: Ucolors.primary,
                                          ),
                                        ),
                                        Gap(5),
                                        Text(
                                          'Est Returns',
                                          style: UTextStyles.caption,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Gap(25),

                // SipSliderTile2(
                //   title: 'Monthly Investment',
                //   value: monthlyInvestment,
                //   min: 500,
                //   max: 100000,
                //   // valueFormatter: (val) => '₹ ${val.toInt()}',
                //   suffix: '₹',

                //   onChanged: (value) {
                //     setState(() {
                //       monthlyInvestment = value;
                //     });
                //   },
                // ),
                // SipSliderTile2(
                //   title: 'Expected return rate (p.a)',
                //   value: returnRate,
                //   min: 1,
                //   max: 30,
                //   // valueFormatter: (val) => '${val.toStringAsFixed(1)}%',
                //   suffix: '%',
                //   onChanged: (val) {
                //     setState(() {
                //       returnRate = val;
                //     });
                //   },
                // ),

                // SipSliderTile2(
                //   title: 'Total period',

                //   suffix: 'Years',
                //   onChanged: (val) {
                //     setState(() {
                //       years = val;
                //     });
                //   },

                //   value: years,
                //   min: 1,
                //   max: 30,
                // ),

                // Container(
                //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                //   width: double.infinity,
                //   decoration: BoxDecoration(
                //     border: Border.all(color: Ucolors.borderside),
                //   ),
                //   child: Column(
                //     children: [
                //       fulldetails(
                //         'Investment amount ',
                //         '284662',
                //         Ucolors.primary.withOpacity(0.7),
                //       ),
                //       Gap(20),
                //       fulldetails('Est Returns ', '284662', Ucolors.primary),
                //       Gap(20),
                //       fulldetails('Total Value', '284662', Ucolors.dark),
                //       Gap(20),

                //       SizedBox(
                //         height: 200,
                //         width: 200,
                //         child: PieChart(
                //           PieChartData(
                //             sectionsSpace: 0,
                //             sections: [
                //               PieChartSectionData(
                //                 showTitle: false,
                //                 value: 70,
                //                 color: Ucolors.primary,
                //               ),
                //               PieChartSectionData(
                //                 showTitle: false,
                //                 color: Ucolors.primary.withOpacity(0.1),
                //                 value: 30,
                //               ),
                //             ],
                //           ),
                //         ),
                //       ),

                //       Gap(20),
                //       Row(
                //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //         children: [
                //           Row(
                //             children: [
                //               Container(
                //                 width: 20,
                //                 height: 10,
                //                 decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(10),
                //                   color: Ucolors.primary.withOpacity(0.1),
                //                 ),
                //               ),
                //               Gap(5),
                //               Text('Invest amount', style: UTextStyles.caption),
                //             ],
                //           ),
                //           Row(
                //             children: [
                //               Container(
                //                 width: 20,
                //                 height: 10,
                //                 decoration: BoxDecoration(
                //                   borderRadius: BorderRadius.circular(10),
                //                   color: Ucolors.primary,
                //                 ),
                //               ),
                //               Gap(5),
                //               Text('Est Returns', style: UTextStyles.caption),
                //             ],
                //           ),
                //         ],
                //       ),
                //     ],
                //   ),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget fulldetails(String title, String value, Color? color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: UTextStyles.small),
        Text(
          '₹ $value',
          style: UTextStyles.medium.copyWith(
            fontWeight: FontWeight.w600,
            // color: Ucolors.dark,
            // color: Ucolors.primary,
            color: color,
          ),
        ),
      ],
    );
  }
}

class SipSliderTile extends StatelessWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final String Function(double) valueFormatter;
  final ValueChanged<double> onChanged;

  const SipSliderTile({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.valueFormatter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title + Green Value Box
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 10, color: Colors.black87),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE9FBF4),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                valueFormatter(value),
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1DBF8E),
                ),
              ),
            ),
          ],
        ),

        // const SizedBox(height: 8),

        /// Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            activeTrackColor: const Color(0xFF1DBF8E),
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: Colors.white,
            overlayColor: Colors.transparent,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
          ),
          child: Slider(value: value, min: min, max: max, onChanged: onChanged),
        ),

        // const SizedBox(height: 24),
      ],
    );
  }
}

class SipSliderTile2 extends StatefulWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final String suffix; // ₹, %, Yr
  final ValueChanged<double> onChanged;

  const SipSliderTile2({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.onChanged,
  });

  @override
  State<SipSliderTile2> createState() => _SipSliderTileState();
}

class _SipSliderTileState extends State<SipSliderTile2> {
  late TextEditingController _controller;
  late double _currentValue;

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _controller = TextEditingController(text: _currentValue.toInt().toString());
  }

  @override
  void didUpdateWidget(covariant SipSliderTile2 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _currentValue = widget.value;
      _controller.text = _currentValue.toInt().toString();
    }
  }

  void _onTextChanged(String text) {
    final parsed = double.tryParse(text);
    if (parsed == null) return;

    final clamped = parsed.clamp(widget.min, widget.max);
    setState(() {
      _currentValue = clamped;
    });
    widget.onChanged(clamped);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title + Editable Green Box
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title, style: const TextStyle(fontSize: 12)),

            /// Editable Value Box
            Container(
              width: 100,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Ucolors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        // color: Ucolors.success,
                        // backgroundColor: Colors.amber,
                        color: Ucolors.primary,
                      ),
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onChanged: _onTextChanged,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    widget.suffix,
                    style: const TextStyle(
                      // color: Color(0xFF1DBF8E),
                      color: Ucolors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),

        /// Slider
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            activeTrackColor: Ucolors.primary,
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: Colors.white,
            overlayColor: Colors.transparent,
            thumbShape: ImageSliderThumb(
              thumbRadius: 015,
              image: AssetImage(UImages.imp),
            ),
          ),
          child: Slider(
            value: _currentValue,
            min: widget.min,
            max: widget.max,
            onChanged: (val) {
              setState(() {
                _currentValue = val;
                _controller.text = val.toInt().toString();
              });
              widget.onChanged(val);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class ImageSliderThumb extends SliderComponentShape {
  final double thumbRadius;
  final ImageProvider image;

  const ImageSliderThumb({required this.thumbRadius, required this.image});

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(thumbRadius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;

    /// Draw white circle
    final Paint paint = Paint()
      ..color = Colors.grey.shade100
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, thumbRadius, paint);

    /// Draw image inside
    final imageSize = thumbRadius * 1.2;

    final Rect imageRect = Rect.fromCenter(
      center: center,
      width: imageSize,
      height: imageSize,
    );

    final paintImage = Paint();

    paintImageShader(canvas, imageRect);
  }

  void paintImageShader(Canvas canvas, Rect rect) async {
    final imageStream = image.resolve(const ImageConfiguration());
    final listener = ImageStreamListener((imageInfo, _) {
      final paint = Paint();
      canvas.drawImageRect(
        imageInfo.image,
        Rect.fromLTWH(
          0,
          0,
          imageInfo.image.width.toDouble(),
          imageInfo.image.height.toDouble(),
        ),
        rect,
        paint,
      );
    });

    imageStream.addListener(listener);
  }
}
