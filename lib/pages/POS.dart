
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart'; // Assurez-vous d'importer la bibliothèque




class TokenPage extends StatefulWidget {
  String? tokenUrl;
  @override
  _TokenPageState createState() => _TokenPageState();
}
class _TokenPageState extends State<TokenPage> {
  String? tokenUrl;
  late InAppWebViewController _webViewController;

  // Fonction pour générer un identifiant utilisateur aléatoire
  int generateRandomUserId() {
    var rng = Random();
    return rng.nextInt(10000);  // Génère un user_id entre 0 et 9999
  }

// Fonction pour appeler l'API et obtenir le token
  Future<String?> generateToken() async {

    final int userId = generateRandomUserId();  // Générer un user_id aléatoire
    final String apiUrl = 'http://192.168.11.164:8017/pos/generate_token/$userId';  // API avec user_id

    // Afficher l'URL dans le terminal
    print('URL de la requête : $apiUrl');
    print('==================== 2');

 
    try {
      final response = await http.Client().get(Uri.parse(apiUrl),headers: {"Content-Type": "application/x-www-form-urlencoded"});

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        // Vérifier si la réponse contient un token_url
        if (responseData.containsKey('token_url')) {
          return responseData['token_url'];  // Retourner l'URL générée
        } else {
          return 'Erreur : Pas de token_url dans la réponse';
        }
      } else {
        return 'Erreur : Code de statut ${response.statusCode}';
      }
    } catch (e) {
      return 'Erreur lors de la requête : $e';
    }
 

    //return apiUrl;
  }


  // Fonction pour récupérer l'URL du token et l'afficher
  void fetchToken() async {
    final result = await generateToken();
    print('==================== generateToken : $result');

    if (result != null && result.startsWith('http')) {
      // Mettre à jour l'URL ou afficher une erreur
      setState(() {
        tokenUrl = result;  // Mettre à jour l'URL
      });
      print('==================== tokenUrl : $tokenUrl');

      // Charger l'URL générée dans la WebView
    //  loadUrlInWebView(tokenUrl!);
    } else {
      print("Erreur lors de la génération du token : $result");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Générer ______Token'),
      ),
      body: Center(
        child: tokenUrl == null
            ? ElevatedButton(
          onPressed: fetchToken,
          child: Text('Générer Token et Accéder à l\'URL'),
        )
            : tokenUrl!.startsWith('http')
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('URL du Token :'),
            SizedBox(height: 10),
            Text(
              tokenUrl!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            ElevatedButton(
              onPressed: () async {
                print('=khass url lanch hnaya tokenUrl : $tokenUrl');

                if (tokenUrl != null && tokenUrl!.isNotEmpty) {
                  // Ouvrir l'URL dans le navigateur
                  //await _launchURL(tokenUrl!);
                } else {
                  print('Aucune URL valide trouvée.');
                }
              },
              child: Text('Fetch Token'),
            )

          ],
        )
            : Text('Erreur : $tokenUrl'),  // Afficher l'erreur si ce n'est pas une URL valide
      ),
    );
  }
}