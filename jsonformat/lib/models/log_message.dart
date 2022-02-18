import 'package:flutter/material.dart';

enum LogLevel {
  debug,
  normal,
  warn,
  error,
}

/// 日志输出端口
class LogMessage {
  const LogMessage(this.message, {this.level = LogLevel.normal});

  final String message;
  final LogLevel level;

  @override
  bool operator ==(other) {
    if (other is! LogMessage) {
      return false;
    }
    return message == other.message && level == other.level;
  }

  @override
  int get hashCode {
    var ret = 0;
    ret += message.hashCode;
    ret += level.hashCode;
    return ret;
  }
}

/// 日志写入类
class LogManager with ChangeNotifier {
  LogManager._instance();
  static final LogManager _manager = LogManager._instance();
  factory LogManager() => _manager;

  /// 最近的一条日志
  LogMessage? lastMessage;

  void writeMessage(String text) {
    write(LogMessage(text));
  }

  /// 写日志
  void write(LogMessage message) {
    if (lastMessage != null && lastMessage == message) {
      return;
    }
    lastMessage = message;
    updateMessageShow();
  }

  bool hasMessage() {
    return lastMessage != null;
  }

  void cleanMessage() {
    lastMessage = null;
    updateMessageShow();
  }

  void updateMessageShow() {
    notifyListeners();
  }
}

class LogMessageWidget extends StatefulWidget {
  final String defaultMessage;

  const LogMessageWidget(this.defaultMessage, {Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return LogMessageState();
  }
}

class LogMessageState extends State<LogMessageWidget> {
  @override
  Widget build(BuildContext context) {
    Widget current;

    String message = widget.defaultMessage;
    if (LogManager().hasMessage()) {
      message = LogManager().lastMessage!.message;
    }
    current = Text(
      message,
      style: const TextStyle(
        color: Colors.white, 
        fontSize: 16,
        overflow: TextOverflow.ellipsis
        ),
      maxLines: 1,
    );

    if (LogManager().hasMessage()) {
        LogMessage message = LogManager().lastMessage!;

        List<Widget> children = [Flexible(child: current)];
        if (message.level == LogLevel.warn) {
          children.insert(0, const Icon(Icons.warning, color: Colors.white,));
        }
        if (message.level == LogLevel.error) {
          children.insert(0, const Icon(Icons.error, color: Colors.white,));
        }
        if (children.length > 1) {
          children.insert(1, const SizedBox(width: 6,));
        }
        current = Row(
          mainAxisAlignment: MainAxisAlignment.start,
            children: children
          );
    }

    LogManager().addListener(() {
      setState(() {});
    });

    return current;
  }
}
