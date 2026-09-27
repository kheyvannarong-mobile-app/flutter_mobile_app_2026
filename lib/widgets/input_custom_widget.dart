import 'package:flutter/material.dart';

class InputCustomWidgets extends StatefulWidget {
  final String? labelText;
  final String? hintText;
  final String? errorValidate;
  final TextEditingController? controller;
  final Widget? prefixIcon;
  final bool isPassword; // បន្ថែមអថេរនេះដើម្បីប្រាប់ថាជាប្រអប់ Password

  const InputCustomWidgets({
    super.key,
    this.labelText,
    this.hintText,
    this.errorValidate,
    this.controller,
    this.prefixIcon,
    this.isPassword = false, // លំនាំដើមគឺមិនមែន Password ទេ
  });

  @override
  State<InputCustomWidgets> createState() => _InputCustomWidgetsState();
}

class _InputCustomWidgetsState extends State<InputCustomWidgets> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    // ប្រសិនបើវាជាប្រអប់ Password នោះឲ្យវាលាក់អក្សរពីដំបូង
    _obscureText = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.next,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return widget.errorValidate ?? 'Please enter a value';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: widget.hintText,
        labelText: widget.labelText,
        labelStyle: TextStyle(
          color: Colors.grey[700],
          fontWeight: FontWeight.w500,
        ),
        hintStyle: TextStyle(color: Colors.grey[400]),
        prefixIcon: widget.prefixIcon ?? const Icon(Icons.person_outline, color: Colors.cyan),

        // ត្រង់នេះជាអ្នកកំណត់រូបភ្នែក និងដំណើរការចុចបិទ/បើក
        suffixIcon: widget.isPassword
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText; // ឆ្លាស់គ្នាពី ពិត ទៅ មិនពិត
            });
          },
        )
            : null, // បើមិនមែន Password ទេ មិនបាច់បង្ហាញរូបភ្នែកឡើយ

        filled: true,
        fillColor: Colors.grey[50],
        contentPadding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 20.0),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.cyan, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2.0),
        ),
      ),
    );
  }
}