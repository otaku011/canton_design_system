import 'package:canton_design_system/canton_design_system.dart';

class CantonTextInput extends StatelessWidget {
  final TextInputType textInputType;
  final String hintText, labelText;
  final Widget prefixIcon, suffixIcon;
  final FocusNode focusNode;
  final bool obscureText, isTextFormField;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final double containerWidth;
  final int maxLines;
  final EdgeInsets containerPadding;
  final BorderRadius radius;
  final BorderSide border;
  final Color containerColor;

  const CantonTextInput({
    this.textInputType,
    this.containerColor,
    this.hintText,
    this.isTextFormField,
    this.labelText,
    this.prefixIcon,
    this.maxLines,
    this.border,
    this.radius,
    this.suffixIcon,
    this.focusNode,
    this.onChanged,
    this.obscureText,
    this.controller,
    this.containerWidth,
    this.containerPadding,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    Widget _labelTextWidget() {
      if (labelText != null) {
        return Column(
          children: [
            Text(
              labelText,
              style: Theme.of(context).inputDecorationTheme.labelStyle,
            ),
            SizedBox(height: 7.0),
          ],
        );
      } else {
        return Container();
      }
    }

    Widget _prefixIconWidget() {
      if (prefixIcon != null) {
        return Padding(
          padding: containerPadding ?? const EdgeInsets.all(19),
          child: prefixIcon,
        );
      } else {
        return null;
      }
    }

    Widget _suffixIconWidget() {
      if (suffixIcon != null) {
        return Padding(
          padding: containerPadding ?? const EdgeInsets.all(19),
          child: suffixIcon,
        );
      } else {
        return null;
      }
    }

    Widget _textInputFormField() {
      return TextFormField(
        obscureText: obscureText,
        controller: controller,
        onChanged: onChanged,
        focusNode: focusNode,
        maxLines: maxLines ?? 1,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          /// To change height of Text Field, add contentPadding,
          /// Use EdgeInsets.all,
          /// and change it from 23 to something else.
          /// 23 for height 65, 18 for height 50.
          contentPadding: containerPadding ?? EdgeInsets.all(18),
          hintText: hintText,
          prefixIcon: _prefixIconWidget(),
          suffixIcon: _suffixIconWidget(),
          fillColor: containerColor,
          enabledBorder: SquircleInputBorder(
            radius: radius,
            side: BorderSide(width: 1.5),
          ),
          focusedBorder: SquircleInputBorder(
            radius: radius,
            side: BorderSide(width: 1.5),
          ),
        ),
      );
    }

    Widget _textInputField() {
      return TextField(
        obscureText: false,
        onChanged: onChanged,
        maxLines: maxLines ?? 1,
        focusNode: focusNode,
        cursorColor: Theme.of(context).primaryColor,
        decoration: InputDecoration(
          /// To change height of Text Field, add contentPadding,
          /// Use EdgeInsets.all,
          /// and change it from 23 to something else.
          /// 23 for height 65, 18 for height 50. WARNING: This can change if you have prefix Icon
          fillColor: containerColor,
          contentPadding: containerPadding ?? EdgeInsets.all(18),
          hintText: hintText,
          prefixIcon: _prefixIconWidget(),
          suffixIcon: _suffixIconWidget(),
          enabledBorder: SquircleInputBorder(
            radius: radius,
            side: BorderSide(width: 1.5),
          ),
          focusedBorder: SquircleInputBorder(
            radius: radius,
            side: BorderSide(width: 1.5),
          ),
        ),
      );
    }

    Widget textInput() {
      if (isTextFormField) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _textInputFormField(),
        );
      } else {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: _textInputField(),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labelTextWidget(),
        Container(
          width: containerWidth ?? size.width,
          child: textInput(),
        ),
      ],
    );
  }
}
