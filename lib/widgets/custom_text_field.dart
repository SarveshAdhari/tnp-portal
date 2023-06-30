import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField(this.label,{super.key, required this.cont, required this.obscure, this.placeholder, required this.keyboard});

  final String label;
  final TextEditingController cont;
  final bool obscure;
  final String? placeholder;
  final TextInputType keyboard;
  
  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField>{

  @override
  void dispose(){
    // widget.cont.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
      child: TextFormField(
        obscureText: widget.obscure,
        controller: widget.cont,
        initialValue: widget.placeholder != '' ? widget.placeholder : '',
        decoration: InputDecoration(
          border: const UnderlineInputBorder(),
          labelText: widget.label,
        ),
        keyboardType: widget.keyboard,
      ),
    );
  }
}
