import 'string_extension_json.dart';

class JSONRepair {
  String? repair(String? badJson) {
    bool isJSON = badJson.isJSON;
    if (isJSON) return badJson;
    // TODO:
    String? ret = badJson;
    
    return ret;
  }
}
