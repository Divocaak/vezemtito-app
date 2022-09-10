import 'package:flutter/material.dart';

class MainButton extends StatelessWidget {
  const MainButton(
      {Key? key,
      required Color bgColor,
      Color? textColor,
      Color? borderColor,
      required String label,
      required Function onTap})
      : _bgColor = bgColor,
        _textColor = textColor ?? Colors.white,
        _borderColor = borderColor ?? Colors.white,
        _label = label,
        _onTap = onTap,
        super(key: key);

  final Color _bgColor;
  final Color _textColor;
  final Color _borderColor;
  final String _label;
  final Function _onTap;

  @override
  Widget build(BuildContext context) => ElevatedButton(
      style: ButtonStyle(
          elevation: MaterialStateProperty.all<double>(0),
          backgroundColor: MaterialStateProperty.all(_bgColor),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
              side: BorderSide(color: _borderColor),
              borderRadius: BorderRadius.circular(50)))),
      onPressed: () => _onTap(),
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Text(_label,
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                  color: _textColor))));
}
