import 'package:eccmobile/component/app_colors.dart';
import 'package:eccmobile/util/resource/resource.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class InputForm extends StatefulWidget {
  final TextEditingController controller;
  final bool enable;
  final bool readOnly;
  final String label;
  bool obscureText;
  final bool isPassword;
  FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final GestureTapCallback? onTap;
  final Widget? suffixIcon;
  final int? maxLines;
  final String? hintText;

  InputForm(this.controller, {required this.label, this.hintText, this.enable=true, this.suffixIcon, this.obscureText=false, this.isPassword=false, this.validator, this.inputFormatters, this.keyboardType, this.onTap, this.readOnly=false, this.maxLines=1});

  @override
  _InputFormState createState() => _InputFormState();
}

class _InputFormState extends State<InputForm> {
  bool obscureTextIcon = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: Dimensions.PADDING_SIZE_DEFAULT,
      ),
      child: TextFormField(
        validator: widget.validator,
        controller: widget.controller,
        enabled: widget.enable,
        onTap: widget.onTap,
        readOnly: widget.readOnly,
        obscureText: widget.obscureText,
        inputFormatters: widget.inputFormatters,
        textCapitalization: TextCapitalization.words,
        keyboardType: widget.keyboardType,
        maxLines: widget.maxLines,
        decoration: InputDecoration(
          fillColor: Colors.white,
          filled: true,
          errorStyle: const TextStyle(color: Colors.red),
          hintStyle: TextStyle(
            color: AppColors.quillGrey,
            fontSize: Dimensions.FONT_SIZE_SMALL
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 0.0),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.grey, width: 0.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.red, width: 0.0),
          ),
          suffixIcon: (widget.suffixIcon != null) ? widget.suffixIcon : (widget.isPassword) ? IconButton(
            icon: Icon(
              widget.obscureText ? Icons.visibility : Icons.visibility_off,
              color: AppColors.cadmiumOrange,
              size: Dimensions.ICON_SIZE_SMALL,
            ),
            onPressed: () {
              setState(() {
                widget.obscureText = !widget.obscureText;
              });
            },
          ) : null,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.cadmiumOrange, width: 0.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: AppColors.cadmiumOrange, width: 0.0),
          ),
          labelStyle: TextStyle(fontSize: Dimensions.FONT_SIZE_DEFAULT, color: AppColors.cadmiumOrange),
          labelText: widget.label,
          contentPadding: const EdgeInsets.only(left: Dimensions.PADDING_SIZE_SMALL, top: Dimensions.PADDING_SIZE_SMALL),
          hintText: widget.hintText,
        ),
        style: const TextStyle(fontSize: Dimensions.FONT_SIZE_DEFAULT),
      ),
    );
  }
}

class DropdownForm extends StatelessWidget {
  final String value;
  final List<DropdownMenuItem<String>> items;
  final String label;
  final Function(String value) onChangedValue;

  DropdownForm({
    required this.value,
    required this.items,
    required this.label,
    required this.onChangedValue
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: Dimensions.PADDING_SIZE_DEFAULT),
      child: DropdownButtonFormField<String>(
        value: value,
        items: items,
        validator: (value) {
          if (value != null) {
            if (value.isEmpty) {
              return "${label} field is required.";
            } else {
              return null;
            }
          }
        },
        style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: Dimensions.FONT_SIZE_DEFAULT,
            color: AppColors.black
        ),
        decoration: InputDecoration(
            fillColor: Colors.white,
            filled: true,
            labelStyle: TextStyle(
                fontSize: Dimensions.FONT_SIZE_DEFAULT,
                color: AppColors.cadmiumOrange),
            contentPadding: const EdgeInsets.only(
                left: Dimensions.PADDING_SIZE_SMALL,
                right: Dimensions.PADDING_SIZE_DEFAULT),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide:
              const BorderSide(color: Colors.red, width: 0.0),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                  color: AppColors.cadmiumOrange, width: 0.0),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.r),
              borderSide: BorderSide(
                  color: AppColors.cadmiumOrange, width: 0.0),
            ),
            labelText: '${label}',
            hintText: '${label}'
        ),
        onChanged: (value) {
          onChangedValue(value!);
        },
      ),
    );
  }
}
