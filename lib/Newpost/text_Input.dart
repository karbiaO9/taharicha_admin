import 'package:flutter/material.dart';
import 'package:taharicha_admin/palatte.dart';

class TextInput extends StatefulWidget {
  const TextInput({
    Key? key,
    required this.icon,
    required this.hint,
    required this.inputType,
    required this.inputAction,
    required this.textController,
    required this.onChanged,
  }) : super(key: key);

  final IconData icon;
  final String hint;
  final TextInputType inputType;
  final TextInputAction inputAction;
  final TextEditingController textController;
  final Function(String) onChanged;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.5),
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(30),
        ),
        child: TextField(
          controller: widget.textController,
          onChanged: (String value) {
            widget.onChanged(value);
          },
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 10),
            border: InputBorder.none,
            hintText: widget.hint,
            prefixIcon: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                widget.icon,
                color: Colors.black,
              ),
            ),
            hintStyle: kBodyText,
          ),
          style: kBodyText,
          keyboardType: widget.inputType,
          textInputAction: widget.inputAction,
        ),
      ),
    );
  }
}
