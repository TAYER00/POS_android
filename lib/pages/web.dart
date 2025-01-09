import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:url_launcher/url_launcher.dart';



class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  late InAppWebViewController _webViewController;
  late InAppWebView _webView;







  Future<void> _launchUrl() async {
    // Affichage d'un message dans la console
    print("Lancement de l'URL...");

    const url = 'http://www.google.com';

    // Vérification si l'URL peut être lancée
    if (await canLaunch(url)) {
      print("URL valide, ouverture dans le navigateur...");
      await launch(url);  // Ouvrir le lien dans un navigateur externe
    } else {
      // Afficher un message d'erreur dans la console si l'URL ne peut pas être lancée
      print("Erreur: Impossible de lancer l'URL.");
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: <Widget>[
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri("http://www.google.com"),  // Utilisation d'un autre site
              ), // URLRequest
              onWebViewCreated: (InAppWebViewController controller) {
                _webViewController = controller;
              },
              onLoadStart: (InAppWebViewController controller, WebUri? url) {
                print("Page started loading: $url");
              },
              onLoadStop: (InAppWebViewController controller, WebUri? url) {
                print("Page finished loading: $url");
              },
              onProgressChanged: (InAppWebViewController controller, int progress) {
                print("Loading progress: $progress%");
              },
            ), // InAppWebView
          ) // Expanded
        ], // <Widget>[]
      ), // Column
      floatingActionButton: FloatingActionButton(
        onPressed: _launchUrl,
        child: const Icon(Icons.open_in_browser),
      ),
    );
  }



}