import 'package:flutter/material.dart';
import 'package:jsonformat/models/json_manager.dart';

class PropertyWrapItemWidget extends StatelessWidget {
  final JsonProperty property;

  PropertyWrapItemWidget(this.property);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 26,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: const Color(0xfff4f5f6),
        ),
        alignment: Alignment.center,
        child: StatefulBuilder(
          builder: ((context, setState) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Checkbox(
                    value: optional,
                    onChanged: (value) {
                      setState(() {
                        valueOption = value ?? true;
                      });
                    }),
                Text(
                  showName,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff333333)),
                )
              ],
            );
          }),
        ));
  }

  String get showName {
    switch (property) {
      case JsonProperty.num:
        return '数字';
      case JsonProperty.string:
        return '字符串';
      case JsonProperty.bool:
        return '布尔';
      case JsonProperty.array:
        return '数组';
      case JsonProperty.map:
        return '字典';
      case JsonProperty.object:
        return '对象';
      default:
        return '未知类型';
    }
  }

  bool get optional {
    switch (property) {
      case JsonProperty.num:
        return JSONManager().numOptional;
      case JsonProperty.string:
        return JSONManager().stringOptional;
      case JsonProperty.bool:
        return JSONManager().boolOptional;
      case JsonProperty.array:
        return JSONManager().arrayOptional;
      case JsonProperty.map:
        return JSONManager().mapOptional;
      case JsonProperty.object:
        return JSONManager().objectOptional;
      default:
        return true;
    }
  }

  set valueOption(bool value) {
    switch (property) {
      case JsonProperty.num:
        JSONManager().numOptional = value;
        break;
      case JsonProperty.string:
        JSONManager().stringOptional = value;
        break;
      case JsonProperty.bool:
        JSONManager().boolOptional = value;
        break;
      case JsonProperty.array:
        JSONManager().arrayOptional = value;
        break;
      case JsonProperty.map:
        JSONManager().mapOptional = value;
        break;
      case JsonProperty.object:
        JSONManager().objectOptional = value;
        break;
    }
  }
}
