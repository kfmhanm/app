import 'package:flutter/material.dart';

class DotsWidget extends StatefulWidget {
  const DotsWidget({super.key, required this.index, required this.sliderIndex});

  final int index;
  final int sliderIndex;

  @override
  State<DotsWidget> createState() => _DotsWidgetState();
}

class _DotsWidgetState extends State<DotsWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 1),
          color: widget.sliderIndex != widget.index
              ? Colors.transparent
              : Colors.white),
      margin: const EdgeInsets.only(right: 5),
      height: widget.sliderIndex == widget.index ? 14 : 12,
      curve: Curves.easeIn,
      width: widget.sliderIndex == widget.index ? 14 : 12,
    );
  }
}
