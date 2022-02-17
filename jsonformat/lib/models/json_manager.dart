
import 'package:jsonformat/models/json_file.dart';

/// json管理类（单利）
class JSONManager {
  JSONManager._instance();
  static final JSONManager _manager = JSONManager._instance();
  factory JSONManager() => _manager;

  JSONFile? _file;

  void setFile(JSONFile? file) => _file = file;

  JSONFile? get file => _file;

  void deleteFile() => _file = null;

}
