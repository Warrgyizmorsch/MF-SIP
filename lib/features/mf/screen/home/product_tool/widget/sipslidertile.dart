import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';
import 'package:my_sip/features/mf/screen/home/product_tool/widget/image_slider_thumb.dart';


class SipSliderTile2 extends StatefulWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final String? suffix; // ₹, %, Yr
  final ValueChanged<double> onChanged;
  final String? prefix;

  const SipSliderTile2({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.onChanged,
    this.prefix,
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
        /// Title + Editable  Box
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
                  if (widget.prefix != null)
                    Text(
                      widget.prefix.toString(),
                      style: TextStyle(
                        color: Ucolors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

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
                  if (widget.suffix != null)
                    Text(
                      widget.suffix.toString(),
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
