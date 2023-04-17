import 'package:atividade2/blocs/colors.dart';
import 'package:flutter/material.dart';

abstract class ThemeState{
  MaterialColor color;
  bool photo;
  ThemeState({
    required this.color,
    required this.photo,
  });
}

class ThemeLight extends ThemeState{
  ThemeLight() : super(photo: true, color: corLight);
}

class ThemeDark extends ThemeState{
  ThemeDark() : super(photo: false, color: corDark);
}