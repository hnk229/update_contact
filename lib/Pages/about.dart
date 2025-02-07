import 'package:flutter/material.dart';
import 'package:update_contact/Theme/theme.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenHeight = screenSize.height;
    var screenWidth = screenSize.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColorScheme.primary,
        iconTheme: IconThemeData(color: lightColorScheme.onPrimary),
        title: Text(
          "À propos",
          style: TextStyle(
            color: lightColorScheme.onPrimary,
            fontSize: screenWidth * 0.045,
            ),
        ),
      ),
      backgroundColor: lightColorScheme.onPrimary,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: screenWidth * 0.02,
          vertical: screenHeight * 0.02
        ),
        child: Column(
          children: [
            Text("À propos de l'application",
            style: TextStyle(
              fontSize: screenWidth * 0.05,
              fontWeight: FontWeight.bold,
              color: lightColorScheme.surface 
            ),
            ),
            SizedBox(height: screenHeight * 0.01,),
            const Divider(),
            SizedBox(height: screenHeight * 0.01,),
            RichText(
          text: TextSpan(
            style: TextStyle(fontSize: screenWidth * 0.045, color: Colors.black.withOpacity(0.7)),
            children: const [
              TextSpan(
                text: 'PAC Contact a été développée par ',
              ),
              TextSpan(
                text: 'le Port Autonome de Cotonou ',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: ' pour faciliter la mise à jour des contacts téléphoniques au nouveau format béninois 01XXXXXXXX.\n\n',
              ),
              TextSpan(
                text: 'Pour toute question ou suggestion, vous pouvez me contacter à l\'adresse suivante :\n\n',
              ),
              TextSpan(
                text: 'Email : ',
              ),
              TextSpan(
                text: 'services@pac.bj\n\n',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(
                text: 'Développeur : HOUENOUKPO Ulrich | houenoukpoulrich2@gmail.com\n\n\n',
              ),
              TextSpan(
                text: '© 2024 Port Autonome de Cotonou. Tous droits réservés.',

              ),

              
            ],
          ),
        ),
          ],),
      ),
    );
  }
}