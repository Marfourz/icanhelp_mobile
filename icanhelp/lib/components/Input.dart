

import 'package:flutter/material.dart';

class InputField extends StatefulWidget {

  final String label;
  final bool isPassword;
  bool _showPassword = false;
  final FormFieldValidator<String?
  >? validator;
  final TextInputType keyboardType;
  final controller;

  InputField({super.key, required this.label, this.isPassword = false,  this.keyboardType = TextInputType.text,this.controller= null, this.validator});

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {


  Widget suffixIcon(){
      if(widget._showPassword) {
        return Icon(Icons.visibility_outlined);
      }
      else {
         return Icon(Icons.visibility_off);
      }
      
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        
        padding: EdgeInsets.symmetric( horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Color.fromRGBO(0, 0, 0, .2)),
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
        child: 
        TextFormField(

          obscureText: widget.isPassword && !widget._showPassword,
          keyboardType: widget.keyboardType,
          validator: widget.validator,
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.label,
            border: InputBorder.none,
            suffixIcon: widget.isPassword ? IconButton(onPressed: (){
              setState(() {
                widget._showPassword = !widget._showPassword;
              });
              
            }, icon: suffixIcon()) : null
       ,
          ),
        ),
      ),
    );
  }
}