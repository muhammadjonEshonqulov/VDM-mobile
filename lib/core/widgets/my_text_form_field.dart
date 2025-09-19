import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vdm/core/widgets/text_widgets.dart';

class MyTextFormField extends StatelessWidget {
  const MyTextFormField({
    super.key,
    this.controller,
    this.focusNode,
    this.initialValue,
    this.validator,
    this.onChanged,
    this.onTap,
    this.keyboardType,
    this.inputFormatters,
    this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly,
    this.obscureText,
    this.multiline,
    this.maxLength,
    this.isMaxLengthVisible,
    this.isRequired,
    this.isEnabled,
    this.isCapitalized,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String? initialValue;
  final String? Function(String? value)? validator;
  final void Function(String value)? onChanged;
  final void Function()? onTap;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final String? labelText;
  final String? hintText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool? readOnly;
  final int? maxLength;
  final bool? obscureText;
  final bool? multiline;
  final bool? isMaxLengthVisible;
  final bool? isRequired;
  final bool? isEnabled;
  final bool? isCapitalized;

  @override
  Widget build(BuildContext context) {
    const double borderRadius = 8;

    return TextFormField(
      controller: controller,
      initialValue: initialValue,
      focusNode: focusNode,
      validator:
          validator ??
          (val) {
            if (val == null) {
              return isRequired == true && val?.isEmpty == true ? hintText : null;
            }
            return null;
          },
      onChanged: onChanged,
      onTap: onTap,
      enabled: isEnabled ?? true,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      readOnly: readOnly ?? false,
      textCapitalization: isCapitalized == true ? TextCapitalization.characters : TextCapitalization.none,
      obscureText: obscureText ?? false,
      maxLength: maxLength,
      maxLines: multiline != true ? 1 : null,
      style: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Inter'),
      textInputAction: multiline != true ? TextInputAction.done : TextInputAction.newline,
      decoration: InputDecoration(
        labelStyle: TextStyle(color: Theme.of(context).colorScheme.tertiary, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Inter'),
        label: Row(
          children: [
            Flexible(child: text14Px(labelText ?? '', color: Theme.of(context).colorScheme.onTertiary, maxLines: 2)),
            isRequired != true ? const Text('') : const Text(' *', style: TextStyle(color: Colors.red)),
          ],
        ),
        hintText: hintText,
        prefixIcon: prefixIcon,
        hintStyle: TextStyle(color: Theme.of(context).colorScheme.onTertiary, fontSize: 16, fontWeight: FontWeight.w400, fontFamily: 'Inter'),
        counterText: isMaxLengthVisible != true ? '' : null,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(width: 1.5, color: Colors.black54),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(width: 1.5, color: Colors.black54),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(width: 1.5, color: Colors.black54),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(width: 1.5, color: Colors.blue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(width: 1.5, color: Colors.red),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(width: 1.5, color: Colors.red),
        ),
      ),
    );
  }
}
