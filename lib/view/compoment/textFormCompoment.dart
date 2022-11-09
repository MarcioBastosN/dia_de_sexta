import 'package:flutter/material.dart';

class TextFormCompoment extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType inputType;
  final int maxLength;
  final IconData? perfixIcon;

  const TextFormCompoment({
    super.key,
    required this.controller,
    required this.label,
    required this.inputType,
    this.perfixIcon,
    this.maxLength = 0,
  });

  @override
  State<TextFormCompoment> createState() => _TextFormCompomentState();
}

class _TextFormCompomentState extends State<TextFormCompoment> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: TextFormField(
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon:
              widget.perfixIcon != null ? Icon(widget.perfixIcon) : null,
          isDense: true,
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
          label: Text(widget.label),
          labelStyle: const TextStyle(
            color: Colors.white60,
          ),
        ),
        controller: widget.controller,
        keyboardType: widget.inputType,
        maxLength: widget.maxLength == 0 ? null : widget.maxLength,
      ),
    );
  }
}
