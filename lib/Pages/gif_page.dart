import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class GifPage extends StatelessWidget {
  // Difinindo atributo da classe
  late final Map _data;

  //Definindo construtor da classe
  GifPage(Map data){
    this._data = data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_data["title"],
        style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: (){
                Share.share(_data["images"]["fixed_height"]["url"]);
              },
              icon: Icon(
                Icons.share,
                color: Colors.white,
              ))
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_data["images"]["fixed_height"]["url"]),
      ),
    );
  }
}
