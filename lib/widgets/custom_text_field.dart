import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../configs/font_size.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final double textFontSize;
  final TextEditingController controller;
  final bool obscureText;
  final bool isNumber;
  final bool readOnly;
  final IconData prefixIcon;
  final TextInputAction? textInputAction;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;

  const CustomTextField({
    super.key,
    required this.labelText,
    required this.textFontSize,
    required this.controller,
    this.obscureText = false,
    this.isNumber = false,
    this.readOnly = false,       // ✅ thêm
    required this.prefixIcon,
    this.textInputAction,
    this.validator,
    this.onChanged,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      readOnly: widget.readOnly,
      onChanged: widget.readOnly ? null : widget.onChanged,
      style: _buildTextStyle(widget.textFontSize),
      textInputAction: widget.textInputAction,
      keyboardType: widget.isNumber ? TextInputType.number : TextInputType.text,
      validator: widget.validator,
      decoration: _buildInputDecoration(),
    );
  }

  TextStyle _buildTextStyle(double textFontSize) {
    return TextStyle(
      color: widget.readOnly ? Colors.black45 : Colors.black,
      fontSize: textFontSize,
      fontWeight: FontWeight.normal,
    );
  }

  InputDecoration _buildInputDecoration() {
    return InputDecoration(
      labelText: widget.labelText,
      labelStyle: TextStyle(
        color: Colors.black.withOpacity(0.7),
        fontSize: AppFontSize.bodyLarge,
      ),
      // ✅ readOnly thì border xám, không có focusedBorder đặc biệt
      enabledBorder: _buildBorder(
        widget.readOnly ? Colors.black26 : Colors.black,
      ),
      focusedBorder: _buildBorder(
        widget.readOnly ? Colors.black26 : const Color(0xFF8360c3),
        width: widget.readOnly ? 1.0 : 2.0,
        radius: widget.readOnly ? 4.0 : 12.0,
      ),
      errorBorder: _buildBorder(Colors.red),
      focusedErrorBorder: _buildBorder(Colors.red, width: 2.0),
      fillColor: widget.readOnly ? Colors.grey[100] : Colors.white, // ✅ nền xám nhẹ khi readOnly
      filled: true,
      contentPadding: const EdgeInsets.all(20),
      prefixIcon: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: FaIcon(
          widget.prefixIcon,
          size: 20,
          color: Colors.black.withOpacity(widget.readOnly ? 0.3 : 0.6), // ✅ icon mờ hơn khi readOnly
        ),
      ),
      prefixIconConstraints: const BoxConstraints(minWidth: 20, minHeight: 20),
      suffixIcon: widget.obscureText ? _buildVisibilityIcon() : null,
    );
  }

  OutlineInputBorder _buildBorder(Color color, {double width = 1.0, double radius = 4.0}) {
    return OutlineInputBorder(
      borderSide: BorderSide(color: color, width: width),
      borderRadius: BorderRadius.circular(radius),
    );
  }

  Widget _buildVisibilityIcon() {
    return IconButton(
      icon: Icon(
        _obscureText ? Icons.visibility_off : Icons.visibility,
        color: Colors.black.withOpacity(0.6),
      ),
      onPressed: _toggleObscureText,
    );
  }

  void _toggleObscureText() {
    setState(() => _obscureText = !_obscureText);
  }
}