import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../boutton_lanch.dart'; // Importation des bibliothèques nécessaires

// Page principale pour afficher l'URL du token et la WebView
class TokenPage_url extends StatefulWidget {
  @override
  _TokenPage_urlState createState() => _TokenPage_urlState();
}

class _TokenPage_urlState extends State<TokenPage_url> {
  String? tokenUrl; // Variable pour stocker l'URL du token
  String? lien;

  WebViewController controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted) // Définir le mode JavaScript de la WebView
    ..loadRequest(Uri.parse('https://flutter.dev')); // Charger une URL par défaut





  // Fonction pour générer un identifiant utilisateur aléatoire
  int generateRandomUserId() {
    var rng = Random();
    return rng.nextInt(10000); // Génère un user_id aléatoire entre 0 et 9999
  }

  // Fonction pour appeler l'API et obtenir le token
  Future<String?> generateToken() async {
    final int userId = generateRandomUserId();  // Générer un user_id aléatoire
    final String apiUrl = 'http://192.168.11.164:8017/pos/generate_token/$userId';  // URL de l'API avec l'user_id

    print('URL de la requête : $apiUrl'); // Afficher l'URL de la requête
    print('==================== 2');

    try {
      // Faire une requête HTTP GET à l'API
      final response = await http.get(Uri.parse(apiUrl), headers: {"Content-Type": "application/x-www-form-urlencoded"});

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body); // Décoder la réponse JSON
        // Vérifier si la réponse contient un 'token_url'
        if (responseData.containsKey('token_url')) {
          return responseData['token_url'];  // Retourner l'URL du token
        } else {
          return 'Erreur : Pas de token_url dans la réponse';
        }
      } else {
        return 'Erreur : Code de statut ${response.statusCode}'; // Retourner une erreur en cas de mauvais code de statut
      }
    } catch (e) {
      return 'Erreur lors de la requête : $e'; // Retourner une erreur en cas d'exception
    }
  }

  // Fonction pour récupérer l'URL du token et l'afficher
  void fetchToken() async {
    final result = await generateToken(); // Appeler la fonction pour générer le token
    print('==================== generateToken : $result'); // Afficher le résultat de la génération
    lien = result;
    // Créer un nouveau contrôleur WebView
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(result!), headers: {
        'Accept': 'text/html,application/xhtml+xml,application/xml',
        'Access-Control-Allow-Origin': '*'
      }); // Charger une URL de test pour la WebView

    // Si l'URL est valide, mettre à jour le state et afficher l'URL du token
    if (result != null && result.startsWith('http')) {
                                                      setState(() {
                                                        tokenUrl = result;  // Mettre à jour l'URL du token
                                                      });
      print('==================== tokenUrl : $tokenUrl'); // Afficher l'URL du token
    } else {
      print("Erreur lors de la génération du token : $result"); // Afficher une erreur si le résultat n'est pas valide
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Column(
        children: [
          SizedBox(height: 50),
          // Si tokenUrl est null, afficher un bouton pour récupérer l'URL du token
          tokenUrl == null ? ElevatedButton(
                                            onPressed: fetchToken, // Appeler fetchToken quand le bouton est pressé
                                            child: Text('Générer Token et Accéder à l\'URL'),
                                          ) : tokenUrl!.startsWith('http')  ? Column( mainAxisAlignment: MainAxisAlignment.center,



            // children: [
            //   // Afficher l'URL du token
            //   Text('URL du Token :'),
            //   SizedBox(height: 10),
            //   Text(
            //     tokenUrl!,
            //     textAlign: TextAlign.center,
            //     style: TextStyle(fontSize: 16),
            //   ),
            //   // Bouton pour afficher l'URL dans la WebView
            //   ElevatedButton(
            //     onPressed: () {
            //       print('=khass url lanch hnaya tokenUrl : $tokenUrl');
            //       if (tokenUrl != null && tokenUrl!.isNotEmpty) {
            //         // Charger l'URL dans la WebView
            //         setState(() {});
            //       } else {
            //         print('Aucune URL valide trouvée.');
            //       }
            //     },
            //     child: Text('Afficher URL dans WebView'),
            //   ),
            // ],





          )
              : Text('Erreur : $tokenUrl'), // Afficher l'erreur si ce n'est pas une URL valide

          // Afficher la WebView si le tokenUrl est valide
          tokenUrl != null && tokenUrl!.startsWith('http')?Expanded(child: WebViewWidget(controller: controller)): Container(), // Si le tokenUrl n'est pas valide, ne pas afficher la WebView
        ],
      ),
    );
  }
}
