import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';

class JSONFile {
  JSONFile(this.path, {this.mimeType, this.name});

  JSONFile.xfile(XFile file)
      : path = file.path,
        mimeType = file.mimeType,
        name = file.name;

  JSONFile.pickFile(PlatformFile file)
      : path = file.path ?? "",
        mimeType = null,
        name = file.name;

  final String path;
  final String? mimeType;
  String? name;
}

