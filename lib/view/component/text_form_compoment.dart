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
        cursorColor: Theme.of(context).colorScheme.onSecondary,
        style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.onSecondary,
              width: 2,
            ),
            borderRadius: const BorderRadius.all(Radius.circular(18)),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.onPrimary),
            borderRadius: const BorderRadius.all(Radius.circular(18)),
          ),
          prefixIcon: widget.perfixIcon != null
              ? Icon(
                  widget.perfixIcon,
                  color: Theme.of(context).colorScheme.outline,
                )
              : null,
          isDense: true,
          label: Text(widget.label),
          labelStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
        controller: widget.controller,
        keyboardType: widget.inputType,
        maxLength: widget.maxLength == 0 ? null : widget.maxLength,
      ),
    );
  }
}
