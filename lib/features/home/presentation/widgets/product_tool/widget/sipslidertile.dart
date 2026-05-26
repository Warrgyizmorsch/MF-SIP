import 'package:flutter/material.dart';
import 'package:my_sip/core/utils/constant/colors.dart';
import 'package:my_sip/core/utils/constant/images.dart';

import 'image_slider_thumb.dart';

class SipSliderTile2 extends StatefulWidget {
  final String title;
  final double value;
  final double min;
  final double max;
  final String? suffix; // ₹, %, Yr
  final ValueChanged<double> onChanged;
  final String? prefix;
  final SliderComponentShape? customThumb;
  final Color? activeColor; // Added parameter for color override

  const SipSliderTile2({
    super.key,
    required this.title,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.onChanged,
    this.prefix,
    this.customThumb,
    this.activeColor, // Initialize parameter
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
    // Determine the active color (fallback to Ucolors.primary)
    final effectiveColor = widget.activeColor ?? Ucolors.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Title + Editable Box
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.title, style: const TextStyle(fontSize: 12)),

            /// Editable Value Box
            Container(
              width: 110,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                // Use effectiveColor for background tint
                color: effectiveColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  if (widget.prefix != null)
                    Text(
                      widget.prefix.toString(),
                      style: TextStyle(
                        color: effectiveColor, // Use effectiveColor
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                  Expanded(
                    child: TextField(
                      style: TextStyle(
                        color: effectiveColor, // Use effectiveColor
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
                      style: TextStyle(
                        color: effectiveColor, // Use effectiveColor
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
            activeTrackColor: effectiveColor, // Use effectiveColor
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: Colors.white,
            overlayColor: Colors.transparent,
            tickMarkShape: SliderTickMarkShape.noTickMark,

            // Use customThumb if provided, otherwise default to ImageSliderThumb
            thumbShape:
                widget.customThumb ??
                ImageSliderThumb(
                  thumbRadius: 15,
                  image: AssetImage(UImages.imp),
                ),
          ),
          child: Slider(
            value: _currentValue,
            min: widget.min,
            max: widget.max,

            // divisions: ,
            divisions: (widget.max - widget.min).toInt(), // 🔥 integer steps

            onChanged: (val) {
              final whole = val.roundToDouble(); // safety

              setState(() {
                _currentValue = whole;
                _controller.text = whole.toInt().toString();
                // _controller.text = val.toString();
              });
              widget.onChanged(whole);
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class SipSliderTile3 extends StatefulWidget {
  final String title;
  final double value;
  final ValueChanged<double> onChanged;
  final double pMin;
  final double pMax;
  final double rMin;
  final double rMax;
  final Color? activeColor;
  final SliderComponentShape? customThumb;

  const SipSliderTile3({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.pMin = 1,
    this.pMax = 30,
    this.rMin = 500,
    this.rMax = 100000,
    this.activeColor,
    this.customThumb,
  });

  @override
  State<SipSliderTile3> createState() => _SipSliderTile3State();
}

class _SipSliderTile3State extends State<SipSliderTile3> {
  late TextEditingController _controller;
  late double _currentValue;
  bool isRupeeActive = true;

  double get currentMin => isRupeeActive ? widget.rMin : widget.pMin;
  double get currentMax => isRupeeActive ? widget.rMax : widget.pMax;

  @override
  void initState() {
    super.initState();

    isRupeeActive = true;

    _currentValue = widget.value.clamp(widget.rMin, widget.rMax);

    _controller = TextEditingController(
      text: _currentValue.toInt().toString(),
    );
  }

  // 🔹 CRITICAL: This updates the internal UI when parent data is cleared/changed
  @override
  void didUpdateWidget(covariant SipSliderTile3 oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.value != oldWidget.value) {
      setState(() {
        _currentValue = widget.value;
        // Update text controller only if not currently typing to avoid cursor jumps
        if (_controller.text != widget.value.toInt().toString()) {
          _controller.text = widget.value.toInt().toString();
        }
      });
    }
  }

  void _updateValue(double val) {
    final clamped = val.clamp(currentMin, currentMax);
    setState(() {
      _currentValue = clamped;
      _controller.text = clamped.toInt().toString();
    });
    widget.onChanged(clamped);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveColor = widget.activeColor ?? Colors.blue;

    // Thumb icon logic
    final WidgetStateProperty<Icon?> thumbIcon = WidgetStateProperty.resolveWith<Icon?>(
          (Set<WidgetState> states) {
        if (isRupeeActive) {
          return const Icon(Icons.currency_rupee, size: 16, color: Colors.white);
        }
        return const Icon(Icons.percent, size: 16, color: Colors.grey);
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text(widget.title, style: const TextStyle(fontSize: 12)),
                const SizedBox(width: 4),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    thumbIcon: thumbIcon,
                    value: isRupeeActive,
                    activeColor: effectiveColor,
                    onChanged: (bool value) {
                      setState(() {
                        isRupeeActive = value;
                        // When switching modes, clamp existing value or reset to min
                        _updateValue(currentMin);
                      });
                    },
                  ),
                ),
              ],
            ),

            // Editable Box
            Container(
              width: 115,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: effectiveColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  if (isRupeeActive)
                    Text(
                      "₹",
                      style: TextStyle(
                        color: effectiveColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        color: effectiveColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                      onChanged: (text) {
                        final val = double.tryParse(text) ?? currentMin;
                        _updateValue(val);
                      },
                    ),
                  ),
                  if (!isRupeeActive)
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Text(
                        "%",
                        style: TextStyle(
                          color: effectiveColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),

        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3,
            activeTrackColor: effectiveColor, // Use effectiveColor
            inactiveTrackColor: Colors.grey.shade300,
            thumbColor: Colors.white,
            overlayColor: Colors.transparent,
            tickMarkShape: SliderTickMarkShape.noTickMark,

            // Use customThumb if provided, otherwise default to ImageSliderThumb
            thumbShape:
            widget.customThumb ??
                ImageSliderThumb(
                  thumbRadius: 15,
                  image: AssetImage(UImages.imp),
                ),
          ),
          child: Slider(
            value: _currentValue.clamp(currentMin, currentMax),
            min: currentMin,
            max: currentMax,
            divisions: isRupeeActive ? null : (widget.pMax - widget.pMin).toInt(),
            onChanged: (val) => _updateValue(val),
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
