import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/core/utils/constant/text_style.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/widget/image_slider_thumb.dart';


class SipSliderWithBg extends StatefulWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final String? suffix;
  final ValueChanged<double> onChanged;
  final String? prefix;
  final SliderComponentShape? customThumb;
  final Color? activeColor;
  final Color? backgroundColor;

  const SipSliderWithBg({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.onChanged,
    required this.suffix,
    this.prefix,
    this.customThumb,
    this.activeColor,
    this.backgroundColor,
  });

  @override
  State<SipSliderWithBg> createState() => _SipSliderWithBgState();
}

class _SipSliderWithBgState extends State<SipSliderWithBg> {
  late TextEditingController _controller;
  late double _currentValue;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _currentValue = widget.value;
    _controller = TextEditingController(text: _currentValue.toInt().toString());

    _focusNode.addListener(() {
      if (!_focusNode.hasFocus) {
        _controller.text = widget.value.toInt().toString();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant SipSliderWithBg oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _currentValue = widget.value;


      if (!_focusNode.hasFocus) {
        _controller.text = widget.value.toInt().toString();
      }
    }
  }

  void _onTextChanged(String text) {
    if (text.isEmpty) return;

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
    final effectiveColor = widget.activeColor ?? Ucolors.primary;
    final bgColor = widget.backgroundColor ?? const Color(0xffF4F4F5);

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(5.0)),
        border: Border(
          top: BorderSide(color: effectiveColor, width: 1.0),
          left: BorderSide(color: effectiveColor, width: 1.0),
          right: BorderSide(color: effectiveColor, width: 1.0),
          bottom: BorderSide.none,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.title,
                  style: AppTextStyles.bodySmallW500(
                    color: Colors.grey
                  ),
                ),
                Container(
                  width: 100,
                  height: 35,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: [
                      if (widget.prefix != null)
                        Text(
                          widget.prefix!,
                          style: AppTextStyles.bodySmall(),
                        ),
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          style: AppTextStyles.bodyMediumSemiBold(
                            color: effectiveColor,
                          ),
                          controller: _controller,
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                          onChanged: _onTextChanged,
                        ),
                      ),
                      const SizedBox(width: 4),
                      if (widget.suffix != null)
                        Text(
                          widget.suffix!,
                          style: AppTextStyles.bodyMediumSemiBold(
                            color: effectiveColor
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          SizedBox(
            height: 24,
            width: double.infinity,
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 10,
                activeTrackColor: effectiveColor,
                inactiveTrackColor: effectiveColor,
                thumbColor: Colors.white,
                padding: EdgeInsets.zero,
                trackShape: const RoundedRectSliderTrackShape(),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 25),
                thumbShape: widget.customThumb ??
                    ImageSliderThumb(
                      thumbRadius: 15,
                      image: AssetImage(UImages.imp),
                    ),
              ),
              child: Transform.translate(
                offset: const Offset(0, 11),
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
            ),
          ),
        ],
      ),
    );
  }
}