import 'package:buscador_gifs/Pages/home_page.dart';
import 'package:flutter/material.dart';

void main(){
  runApp(
    MaterialApp(
      home: HomePage(),
      // Colocando no texto
      theme: ThemeData(
          inputDecorationTheme: InputDecorationTheme(
            //Configurando a cor das bordas das caixas de texto de entrada
            enabledBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
            OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          )
      ),
    )
  );
}


