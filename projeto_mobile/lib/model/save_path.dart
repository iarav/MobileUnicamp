import 'package:shared_preferences/shared_preferences.dart';

class SavePath {
  SavePath();

  static void changePath(String path) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_route', path);
  }
}