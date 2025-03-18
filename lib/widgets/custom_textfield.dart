import 'package:diop_mouhamed_l3gl_examen/enum/textfield_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final TextFieldType type;
  final FormFieldValidator<String>? validator;
  final TextInputFormatter? formatter;
  final bool filled;
  final IconData? prefixIcon;
  final double borderRadius;
  final int maxLines;
  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.type = TextFieldType.normal,
    this.validator,
    this.formatter,
    this.filled = true,
    this.prefixIcon,
    this.borderRadius = 15,  this.maxLines = 1,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isHidden = true;
  int textLength = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final fillColor = isDark ? Color(0xFF2A2A2A) : Colors.grey.shade200;

    final borderColor = isDark ? Colors.grey.shade800 : Colors.white;

    final focusedBorderColor =
        isDark ? theme.colorScheme.primary : Colors.grey.shade400;

    final hintColor = isDark ? Colors.grey.shade400 : Colors.grey.shade500;

    return TextFormField(
      maxLines: widget.maxLines,
      controller: widget.controller,
      validator: widget.validator,
      obscureText: widget.type == TextFieldType.password && isHidden,
      inputFormatters: widget.formatter != null ? [widget.formatter!] : null,
      style: TextStyle(color: isDark ? Colors.white : Colors.black87),
      onChanged:
          widget.type == TextFieldType.password
              ? (value) => setState(() => textLength = value.length)
              : null,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: TextStyle(color: hintColor),
        filled: widget.filled,
        fillColor: widget.filled ? fillColor : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(color: borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            color: widget.filled ? borderColor : theme.colorScheme.outline,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide(
            color:
                widget.filled ? focusedBorderColor : theme.colorScheme.primary,
          ),
        ),
        suffixIcon: _buildSuffixIcon(isDark),
        prefixIcon:
            Icon(
              widget.prefixIcon,
              size: MediaQuery.of(context).size.width * 0.05,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
            ) ??
            null,
      ),
    );
  }

  Widget? _buildSuffixIcon(bool isDark) {
    if (widget.type == TextFieldType.password && textLength > 0) {
      return IconButton(
        onPressed: () => setState(() => isHidden = !isHidden),
        icon: Icon(
          isHidden ? CupertinoIcons.eye : CupertinoIcons.eye_slash,
          size: MediaQuery.of(context).size.width * 0.05,
          color: isDark ? Colors.grey.shade400 : Colors.grey.shade700,
        ),
      );
    }
    return null;
  }
}
