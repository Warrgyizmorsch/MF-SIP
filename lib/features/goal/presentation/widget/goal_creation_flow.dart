import 'dart:math' as math;

import 'package:dotted_border/dotted_border.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../../common/widget/images/image_picker.dart';
import '../../../fund_details/data/models/return_model.dart';
import '../controller/goal_sip_controller.dart';
import 'goal_flow_app_bar.dart';

/// Mobile creation steps. Financial calculations and persistence stay in GetX.
class GoalCreationFlow extends StatefulWidget {
  const GoalCreationFlow({
    super.key,
    required this.controller,
    required this.onBack,
    required this.onSaved,
  });

  final GoalSipController controller;
  final VoidCallback onBack;
  final Future<void> Function() onSaved;

  @override
  State<GoalCreationFlow> createState() => GoalCreationFlowState();
}

class GoalCreationFlowState extends State<GoalCreationFlow> {
  final _costScroll = ScrollController();
  final _planScroll = ScrollController();
  late final TextEditingController _amount;
  late final TextEditingController _duration;
  bool _review = false;
  bool _table = false;
  double _inflation = 6;
  Uint8List? _cover;

  GoalSipController get c => widget.controller;

  @override
  void initState() {
    super.initState();
    _amount = TextEditingController(text: _number(c.targetAmount.value));
    _duration = TextEditingController(text: c.years.value.toInt().toString());
    _readCover();
  }

  Future<void> _readCover() async {
    final image = c.coverImage.value;
    if (image == null) return;
    try {
      final bytes = await image.readAsBytes();
      if (mounted) setState(() => _cover = bytes);
    } catch (_) {
      // The existing picker reports platform errors; keep its placeholder usable.
    }
  }

  @override
  void dispose() {
    _amount.dispose();
    _duration.dispose();
    _costScroll.dispose();
    _planScroll.dispose();
    super.dispose();
  }

  /// Consumed by the existing route's PopScope before its discard prompt.
  bool backToCost() {
    if (!_review) return false;
    setState(() => _review = false);
    _resetScroll();
    return true;
  }

  void _resetScroll() {
    if (_costScroll.hasClients) _costScroll.jumpTo(0);
    if (_planScroll.hasClients) _planScroll.jumpTo(0);
  }

  void _setAmount(double value) {
    c.setTarget(value);
    _amount.text = _number(c.targetAmount.value);
  }

  void _setYears(double value) {
    c.setYears(value.roundToDouble());
    _duration.text = c.years.value.toInt().toString();
  }

  void _reviewPlan() {
    FocusScope.of(context).unfocus();
    c.setGoalName(c.goalNameTextEditingController.text);
    if (!c.isFormValid) return;
    // Commit typed values through the existing validation/rounding setters.
    _setAmount(
      (double.tryParse(_amount.text.replaceAll(',', '')) ??
              c.targetAmount.value)
          .clamp(1000, 10000000),
    );
    _setYears(double.tryParse(_duration.text) ?? c.years.value);
    c.recalculateLumpsum();
    setState(() => _review = true);
    _resetScroll();
  }

  Future<void> _save() async {
    if (c.isSavingGoal.value) return;
    await c.saveGoalToDb();
    // The legacy controller also sets isGoalSaved after API errors. Require an ID.
    if (c.isGoalSaved.value && (c.savedDatabaseId.value ?? 0) > 0) {
      await widget.onSaved();
    }
  }

  static String _number(num value) =>
      NumberFormat.decimalPattern('en_IN').format(value.round());
  static String _money(num value) => '₹${_number(value)}';

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        textTheme: Theme.of(
          context,
        ).textTheme.apply(fontFamily: 'Plus Jakarta Sans'),
      ),
      child: Scaffold(
        backgroundColor: _PlanStyle.background,
        appBar: GoalFlowAppBar(
          title: 'New Goal',
          step: _review ? 3 : 2,
          onBack: () {
            if (!backToCost()) widget.onBack();
          },
        ),
        body: SafeArea(
          top: false,
          bottom: false,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _header(),
              Expanded(
                child: AnimatedSwitcher(
                  duration: _PlanStyle.duration,
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: SlideTransition(
                      position: Tween(
                        begin: const Offset(0.035, 0),
                        end: Offset.zero,
                      ).animate(animation),
                      child: child,
                    ),
                  ),
                  child: SingleChildScrollView(
                    key: ValueKey(_review),
                    controller: _review ? _planScroll : _costScroll,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: _review ? _plan() : _cost(),
                  ),
                ),
              ),
              _footer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
    child: Text(
      'How much, and when?',
      style: _PlanStyle.text(
        24,
        weight: FontWeight.w700,
      ).copyWith(height: 37 / 24, letterSpacing: -0.48),
    ),
  );

  Widget _cost() => Padding(
    padding: const EdgeInsets.symmetric(vertical: 20),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 13,
      children: [
        _imagePicker(),
        Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _field(
                'Goal name',
                TextField(
                  controller: c.goalNameTextEditingController,
                  style: _PlanStyle.text(16, weight: FontWeight.w600),
                  decoration: _inputDecoration(hint: 'Enter goal name'),
                  textCapitalization: TextCapitalization.words,
                  onChanged: c.setGoalName,
                ),
              ),
              if (c.goalError.value.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  c.goalError.value,
                  style: _PlanStyle.text(12, color: Colors.red),
                ),
              ],
            ],
          ),
        ),
        _modeTabs(),
        _field(
          'I Need',
          TextField(
            controller: _amount,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp('[0-9,]')),
            ],
            style: _PlanStyle.text(16, weight: FontWeight.w800),
            decoration: _inputDecoration(prefix: '₹ '),
            onSubmitted: (v) => _setAmount(
              (double.tryParse(v.replaceAll(',', '')) ?? c.targetAmount.value)
                  .clamp(1000, 10000000),
            ),
          ),
        ),
        Obx(
          () => _slider(
            value: c.targetAmount.value.clamp(1000, 10000000),
            min: 1000,
            max: 10000000,
            onChanged: _setAmount,
          ),
        ),
        _field(
          'Duration',
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            decoration: _PlanStyle.box(18),
            child: Row(
              children: [
                SizedBox(
                  width: 26,
                  child: TextField(
                    controller: _duration,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    style: _PlanStyle.text(16, weight: FontWeight.w800),
                    decoration: const InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    onSubmitted: (v) =>
                        _setYears(double.tryParse(v) ?? c.years.value),
                  ),
                ),
                Text(
                  'Years',
                  style: _PlanStyle.text(
                    16,
                    color: _PlanStyle.dim,
                    weight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
        Obx(
          () => _slider(
            value: c.years.value.clamp(1, 30),
            min: 1,
            max: 30,
            onChanged: _setYears,
          ),
        ),
        _inflationStepper(),
        Obx(
          () => Container(
            padding: const EdgeInsets.all(20),
            decoration: _PlanStyle.box(26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'You’ll actually need',
                  style: _PlanStyle.text(
                    13,
                    color: _PlanStyle.navy,
                    weight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  _money(
                    c.targetAmount.value *
                        math.pow(1 + _inflation / 100, c.years.value),
                  ),
                  style: _PlanStyle.text(
                    26,
                    color: _PlanStyle.navy,
                    weight: FontWeight.w800,
                  ).copyWith(letterSpacing: -0.52),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );

  Widget _imagePicker() => DottedBorder(
    options: const RoundedRectDottedBorderOptions(
      radius: Radius.circular(22),
      color: Color(0xFF2E289F),
      strokeWidth: 1.5,
      dashPattern: [6, 4],
      padding: EdgeInsets.zero,
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: () => UImagePicker.showImageSourceOptions(
          context: context,
          onImageSelected: (source) async {
            await c.pickCoverImage(source);
            await _readCover();
          },
        ),
        child: SizedBox(
          height: 108,
          width: double.infinity,
          child: _cover != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(22),
                  child: Image.memory(_cover!, fit: BoxFit.cover),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0x1A2E289F),
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/home/figma/goal_plan_add.svg',
                          width: 22,
                          height: 22,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Add Image',
                      style: _PlanStyle.text(
                        10,
                        color: const Color(0xFF2E289F),
                        weight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    ),
  );

  Widget _field(String label, Widget input) => Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      Text(
        label,
        style: _PlanStyle.text(
          13,
          color: _PlanStyle.muted,
          weight: FontWeight.w600,
        ).copyWith(height: 16 / 13),
      ),
      const SizedBox(height: 8),
      SizedBox(height: 54, child: input),
    ],
  );

  InputDecoration _inputDecoration({
    String? hint,
    String? prefix,
    String? suffix,
  }) => InputDecoration(
    hintText: hint,
    filled: true,
    fillColor: Colors.white,
    isDense: true,
    contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
    prefixText: prefix,
    prefixStyle: _PlanStyle.text(
      16,
      color: _PlanStyle.dim,
      weight: FontWeight.w800,
    ),
    suffixText: suffix,
    suffixStyle: _PlanStyle.text(
      16,
      color: _PlanStyle.dim,
      weight: FontWeight.w800,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: _PlanStyle.line),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: _PlanStyle.line),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(18),
      borderSide: const BorderSide(color: _PlanStyle.purple),
    ),
  );

  Widget _modeTabs() => Obx(() {
    final sip = c.investmentMode.value == 'sip';
    return Container(
      height: 50,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F4F9),
        border: Border.all(color: _PlanStyle.line),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        spacing: 4,
        children: ['SIP', 'Lumpsum'].asMap().entries.map((e) {
          final selected = e.key == 0 ? sip : !sip;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                c.investmentMode.value = e.key == 0 ? 'sip' : 'lumpsum';
                c.recalculateLumpsum();
              },
              child: AnimatedContainer(
                duration: _PlanStyle.duration,
                curve: Curves.easeOut,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: selected
                        ? const Color(0x1A5B3FE0)
                        : Colors.transparent,
                  ),
                  boxShadow: selected
                      ? [
                          const BoxShadow(
                            color: Color(0x1A5B3FE0),
                            blurRadius: 4,
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  e.value,
                  style: _PlanStyle.text(
                    13,
                    color: selected ? _PlanStyle.purple : _PlanStyle.muted,
                    weight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  });

  Widget _slider({
    required double value,
    required double min,
    required double max,
    required ValueChanged<double> onChanged,
  }) => SizedBox(
    height: 18,
    child: SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 4,
        activeTrackColor: _PlanStyle.purple,
        inactiveTrackColor: const Color(0xFFE2DFF1),
        thumbColor: _PlanStyle.purple,
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 9),
        overlayShape: SliderComponentShape.noOverlay,
        trackShape: const RectangularSliderTrackShape(),
      ),
      child: Slider(
        value: value,
        min: min,
        max: max,
        padding: EdgeInsets.zero,
        onChanged: onChanged,
      ),
    ),
  );

  Widget _inflationStepper() => Container(
    height: 57,
    padding: const EdgeInsets.only(left: 16, right: 12),
    decoration: _PlanStyle.box(18),
    child: Row(
      children: [
        Expanded(
          child: Text(
            'Price rise per year',
            style: _PlanStyle.text(13, weight: FontWeight.w600),
          ),
        ),
        _stepperButton(
          '−',
          () => setState(() => _inflation = (_inflation - 1).clamp(0, 30)),
        ),
        SizedBox(
          width: 48,
          child: Text(
            '${_inflation.toInt()}%',
            textAlign: TextAlign.center,
            style: _PlanStyle.text(15, weight: FontWeight.w800),
          ),
        ),
        _stepperButton(
          '+',
          () => setState(() => _inflation = (_inflation + 1).clamp(0, 30)),
        ),
      ],
    ),
  );

  Widget _stepperButton(String label, VoidCallback onTap) => Material(
    color: const Color(0xFFF1F4F9),
    shape: const CircleBorder(),
    child: InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: SizedBox(
        width: 36,
        height: 36,
        child: Center(
          child: Text(
            label,
            style: _PlanStyle.text(18, weight: FontWeight.w800),
          ),
        ),
      ),
    ),
  );

  Widget _plan() => Obx(() {
    final sip = c.investmentMode.value == 'sip';
    final values = sip
        ? <(String, String)>[
            ('Daily SIP', _compact(c.dailySipAmount.value)),
            ('Weekly SIP', _compact(c.weeklySipAmount.value)),
            ('Monthly SIP', _compact(c.monthlySip.value)),
            ('Invested', _compact(c.invested.value)),
            ('Future Value', _compact(c.targetAmount.value)),
            ('Total Return', _compact(c.totalReturn.value)),
          ]
        : <(String, String)>[
            ('Invest Once', _compact(c.lumpsumAmount.value)),
            ('Duration', '${c.years.value.toInt()} Years'),
            ('Future Value', _compact(c.lumpsumFutureValue.value)),
            ('Total Return', _compact(c.lumpsumTotalReturn.value)),
            ('Return', '${c.lumpsumReturnPercent.value.toStringAsFixed(1)}%'),
          ];
    return Padding(
      padding: EdgeInsets.only(top: sip ? 15 : 20, bottom: 22),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, size) => Wrap(
              spacing: 12,
              runSpacing: 12,
              children: values
                  .map(
                    (v) => SizedBox(
                      width: (size.maxWidth - 12) / 2,
                      child: _summaryCard(v.$1, v.$2),
                    ),
                  )
                  .toList(),
            ),
          ),
          SizedBox(height: sip ? 21 : 16),
          _projection(sip),
        ],
      ),
    );
  });

  static String _compact(num value) {
    if (value.abs() >= 10000000) {
      return '₹${(value / 10000000).toStringAsFixed(2)}Cr';
    }
    if (value.abs() >= 100000) {
      return '₹${(value / 100000).toStringAsFixed(2)}L';
    }
    if (value.abs() >= 1000) return '₹${(value / 1000).toStringAsFixed(1)}K';
    return _money(value);
  }

  Widget _summaryCard(String title, String value) => Container(
    constraints: const BoxConstraints(minHeight: 82),
    padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 8),
    decoration: _PlanStyle.box(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: _PlanStyle.text(
            11,
            color: Colors.black,
            weight: FontWeight.w500,
          ).copyWith(height: 16 / 11),
        ),
        const SizedBox(height: 5),
        Text(
          value,
          style: _PlanStyle.text(
            16,
            color: Colors.black,
            weight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Approx',
          style: _PlanStyle.text(
            10,
            color: Colors.black,
            weight: FontWeight.w500,
          ).copyWith(height: 1.6),
        ),
      ],
    ),
  );

  Widget _projection(bool sip) {
    final rows = sip ? c.buildYearlyReport() : _lumpsumRows();
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _PlanStyle.box(26),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Projection',
                  style: _PlanStyle.text(16, weight: FontWeight.w700),
                ),
              ),
              _chartButton(
                'trend',
                'Show chart',
                () => setState(() => _table = false),
              ),
              const SizedBox(width: 10),
              _chartButton(
                'table',
                'Show yearly table',
                () => setState(() => _table = true),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (_table)
            _projectionTable(rows)
          else ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _legend('You invest', const Color(0xFF8A8DA0)),
                _legend('Value', _PlanStyle.purple),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(height: 173, child: _chart(rows, sip)),
          ],
        ],
      ),
    );
  }

  // Use the same annual-rate/PV relationship as recalculateLumpsum. The legacy
  // saved-goal graph uses a different report; do not alter that existing view.
  List<ReturnRow> _lumpsumRows() => List.generate(c.years.value.toInt(), (i) {
    final value =
        c.lumpsumAmount.value * math.pow(1 + c.annualRate.value / 100, i + 1);
    return ReturnRow(
      period: '${i + 1}',
      scheme: c.lumpsumAmount.value,
      category: value.toDouble(),
      benchmark: value - c.lumpsumAmount.value,
    );
  });

  Widget _chartButton(String asset, String label, VoidCallback onTap) =>
      Semantics(
        button: true,
        label: label,
        child: Material(
          color: const Color(0xFFF3F2F9),
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Center(
                child: SvgPicture.asset(
                  'assets/home/figma/goal_plan_$asset.svg',
                  width: asset == 'trend' ? 20.6 : 18,
                  height: asset == 'trend' ? 11.8308 : 18,
                ),
              ),
            ),
          ),
        ),
      );

  Widget _legend(String text, Color color) => Row(
    children: [
      Container(
        width: 14,
        height: 3,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
      const SizedBox(width: 6),
      Text(
        text,
        style: _PlanStyle.text(
          12,
          color: _PlanStyle.muted,
          weight: FontWeight.w500,
        ),
      ),
    ],
  );

  Widget _chart(List<ReturnRow> rows, bool sip) {
    if (rows.isEmpty) return const SizedBox.shrink();
    final highest = rows
        .map((r) => math.max(r.scheme, r.category))
        .reduce(math.max);
    final ceiling = math.max(highest * 1.2, 1.0);
    return LineChart(
      duration: _PlanStyle.duration,
      curve: Curves.easeOut,
      LineChartData(
        minX: 0,
        maxX: c.years.value,
        minY: 0,
        maxY: ceiling,
        gridData: const FlGridData(show: false),
        borderData: FlBorderData(show: false),
        extraLinesData: ExtraLinesData(
          horizontalLines: [
            HorizontalLine(
              y: c.targetAmount.value,
              color: const Color(0xFFFF9400),
              strokeWidth: 1,
              dashArray: [4, 4],
            ),
          ],
        ),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: ceiling / 4,
              reservedSize: 46,
              getTitlesWidget: (v, meta) => Text(
                v == 0 ? '0' : '${(v / 100000).toStringAsFixed(1)}L',
                style: _PlanStyle.text(
                  11,
                  color: _PlanStyle.dim,
                  weight: FontWeight.w600,
                ),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: math.max(1, (c.years.value / 9).ceil()).toDouble(),
              reservedSize: 24,
              getTitlesWidget: (v, meta) => SideTitleWidget(
                meta: meta,
                child: Text(
                  '${v.toInt()}',
                  style: _PlanStyle.text(
                    11,
                    color: _PlanStyle.dim,
                    weight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, sip ? 0 : c.lumpsumAmount.value),
              ...rows.map((r) => FlSpot(double.parse(r.period), r.scheme)),
            ],
            color: const Color(0xFF8A8DA0),
            barWidth: 2,
            dashArray: [6, 5],
            dotData: const FlDotData(show: false),
          ),
          LineChartBarData(
            spots: [
              FlSpot(0, sip ? 0 : c.lumpsumAmount.value),
              ...rows.map((r) => FlSpot(double.parse(r.period), r.category)),
            ],
            color: _PlanStyle.purple,
            barWidth: 3,
            isCurved: true,
            dotData: const FlDotData(show: false),
            belowBarData: BarAreaData(
              show: true,
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0x335B3FE0), Color(0x005B3FE0)],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _projectionTable(List<ReturnRow> rows) => Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: ['Year', 'You invest', 'Value']
              .map(
                (v) => Expanded(
                  child: Text(
                    v,
                    style: _PlanStyle.text(
                      11,
                      color: _PlanStyle.muted,
                      weight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ),
      ...rows.map(
        (r) => Padding(
          padding: const EdgeInsets.symmetric(vertical: 7),
          child: Row(
            children: [
              Expanded(child: Text(r.period, style: _PlanStyle.text(11))),
              Expanded(
                child: Text(_compact(r.scheme), style: _PlanStyle.text(11)),
              ),
              Expanded(
                child: Text(_compact(r.category), style: _PlanStyle.text(11)),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  Widget _footer() => Padding(
    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
    child: SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_review) ...[
            Text(
              'Returns are assumptions for this mix, not a promise.',
              textAlign: TextAlign.center,
              style: _PlanStyle.text(11, color: _PlanStyle.dim),
            ),
            const SizedBox(height: 10),
          ],
          Obx(() {
            final saving = c.isSavingGoal.value;
            return Container(
              height: 56,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: _PlanStyle.gradient,
                borderRadius: BorderRadius.circular(999),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x617C5CFF),
                    blurRadius: 30,
                    offset: Offset(0, 12),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: saving ? null : (_review ? _save : _reviewPlan),
                  child: Center(
                    child: saving
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            _review ? 'Save & Continue' : 'Review & Continue',
                            style: _PlanStyle.text(
                              16,
                              color: Colors.white,
                              weight: FontWeight.w700,
                            ),
                          ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    ),
  );
}

class _PlanStyle {
  static const background = Color(0xFFF5F6FA);
  static const purple = Color(0xFF441D9E);
  static const navy = Color(0xFF0E176F);
  static const line = Color(0xFFE4E6EE);
  static const muted = Color(0xFF5E6175);
  static const dim = Color(0xFF6E7186);
  static const duration = Duration(milliseconds: 350);
  static const gradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [navy, Color(0xFF5B3FE0)],
  );

  static TextStyle text(
    double size, {
    Color color = const Color(0xFF12121A),
    FontWeight weight = FontWeight.w400,
  }) => TextStyle(
    fontFamily: 'Plus Jakarta Sans',
    fontSize: size,
    color: color,
    fontWeight: weight,
  );
  static BoxDecoration box(double radius) => BoxDecoration(
    color: Colors.white,
    border: Border.all(color: line),
    borderRadius: BorderRadius.circular(radius),
  );
}
