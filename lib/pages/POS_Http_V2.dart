import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

class TokenPage_V2 extends StatefulWidget {
  @override
  _TokenPage_V2State createState() => _TokenPage_V2State();
}

class _TokenPage_V2State extends State<TokenPage_V2> {
  String? tokenUrl; // Variable pour stocker l'URL du token
  WebViewController _controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted) // Définir le mode JavaScript de la WebView
    ..loadRequest(Uri.parse('https://flutter.dev')); // Charger une URL par défaut

  bool isLoading = false; // Variable pour gérer l'état de chargement

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
    setState(() {
      isLoading = true; // Commence le chargement
    });

    final result = await generateToken(); // Appeler la fonction pour générer le token
    print('==================== generateToken : $result'); // Afficher le résultat de la génération

    // Créer un nouveau contrôleur WebView avec l'URL reçue
    if (result != null && result.startsWith('http')) {
      setState(() {
        tokenUrl = result;  // Mettre à jour l'URL du token
        isLoading = false;  // Fin du chargement
      });

      // Créer un nouveau contrôleur WebView
      _controller = WebViewController()
        ..setJavaScriptMode(JavaScriptMode.unrestricted)
        ..loadRequest(Uri.parse(result), headers: {
          'Accept': 'text/html,application/xhtml+xml,application/xml',
          'Access-Control-Allow-Origin': '*'
        }); // Charger l'URL du token dans le WebView
    } else {
      setState(() {
        isLoading = false; // Fin du chargement
      });
      print("Erreur lors de la génération du token : $result"); // Afficher une erreur si le résultat n'est pas valide
    }
  }

  @override
  void initState() {
    super.initState();
    // Initialiser WebView (nécessaire si vous l'utilisez dans une première page)
    WebViewPlatform.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/az.jpg'), // Chemin de l'image de fond
            fit: BoxFit.cover, // L'image couvre toute la surface de l'écran
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // Centrer les éléments verticalement
          children: [
            // Si l'on est en train de charger, afficher l'indicateur de chargement
            if (isLoading)
              Center(
                child: CircularProgressIndicator(), // Afficher un indicateur de chargement
              )
            // Si tokenUrl est null, afficher le bouton pour générer un token
            else if (tokenUrl == null)
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter, // Placer le bouton en bas
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: fetchToken, // Appeler fetchToken quand le bouton est pressé
                      child: Text(
                        'Générer Token et Accéder à l\'URL',
                        style: TextStyle(color: Colors.white), // Texte en blanc
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent, // Fond transparent pour le bouton
                        disabledForegroundColor: Colors.transparent.withOpacity(0.38), disabledBackgroundColor: Colors.transparent.withOpacity(0.12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0), // Bordure avec coins arrondis
                        ),
                        side: BorderSide(color: Colors.white, width: 2), // Bordure blanche
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 40), // Espacement du bouton
                      ),
                    ),
                  ),
                ),
              )
            // Si tokenUrl est valide et commence par http, afficher la WebView
            else if (tokenUrl!.startsWith('http'))
                Expanded(
                  child: WebViewWidget(controller: _controller),
                )
              // Si l'URL est incorrecte, afficher un message d'erreur
              else
                Center(child: Text('Erreur : $tokenUrl')),
          ],
        ),
      ),
    );
  }
  }

