import 'package:flutter/material.dart';

import 'package:webview/pages/POS.dart';
import 'package:webview/pages/POS_Http_V2.dart';
import 'package:webview/pages/POS_http.dart';
import 'package:webview/pages/location.dart';
import 'package:webview/pages/web.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TokenPage_V2(),
    ),
  );
}
