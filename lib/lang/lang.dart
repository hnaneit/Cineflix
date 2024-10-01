import 'dart:core';

Map<String, String> _vi = {
  "appname": "Multi Language in Flutter",
  "hello": "Xin chào",
  "pushedtime": "Bạn đã ấn nút này bao nhiêu lần:",
};

Map<String, String> _en = {
  "appname": "Multi Language in Flutter",
  "hello": "Hello",
  "pushedtime": "You have pushed the button this many times:",
};

String currentLanguage = "vi";

String lang(String key, String defaultString) {
  if (currentLanguage == "en") return _en[key] ?? defaultString;
  return _vi[key] ?? defaultString;
}
