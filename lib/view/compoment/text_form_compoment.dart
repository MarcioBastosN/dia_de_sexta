import 'package:flutter/material.dart';

class TextFormCompoment extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType inputType;
  final int maxLength;
  final IconData? perfixIcon;
  final void Function()? submit;
  final FocusNode? focus;

  const TextFormCompoment({
    super.key,
    required this.controller,
    required this.label,
    required this.inputType,
    this.perfixIcon,
    this.maxLength = 0,
    this.submit,
    this.focus,
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
        onEditingComplete: widget.submit,
        focusNode: widget.focus,
        cursorColor: Colors.white,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              color: Colors.cyan,
              width: 2,
            ),
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(18)),
          ),
          prefixIcon: widget.perfixIcon != null
              ? Icon(
                  widget.perfixIcon,
                  color: Colors.white60,
                )
              : null,
          isDense: true,
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
