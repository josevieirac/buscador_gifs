import 'package:buscador_gifs/http/client.dart';
import 'package:buscador_gifs/util/debounce.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';

import 'gif_page.dart';

//Classe de definição da home page
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // Definindo atributos da classe
  CLientHttp _client = CLientHttp(); //Cliente HTTP para consumir API do Giphy
  TextEditingController _controller = TextEditingController();  //Controlador do campo de texto de busca
  Debouncer _debouncer = Debouncer(500);  //Bouncer para controlar a requisição apenas quando o usuário parar de digitar
  int _offSet = 0;  //OffSet para controlar os itens axibidos por página
  late Map _data; //Dados a serem exibidos no grid de visualização

  // Construindo a tela principal
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Padding(
          padding: EdgeInsets.all(60),
          child: Image.network("https://developers.giphy.com/static/img/dev-logo-lg.gif"), // Carregando imagem da internet e colocando no cabeçalho da página
        )
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
              padding: EdgeInsets.all(12),
              child: TextField( // Configurando a caixa de texto de busca
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Pesquise aqui...",
                  labelStyle: TextStyle(color: Colors.white70),
                  alignLabelWithHint: true,
                  border: OutlineInputBorder()
                ),
                style: TextStyle(color: Colors.white, fontSize: 20,),
                textAlign: TextAlign.center,
                onChanged: (value){ // Configurando função para efetuar a busca na API e modificar a tela
                  //Espera enquanto o usuário digita para poder executar a busca
                  _debouncer.run(() {
                    setState(() {
                      _offSet = 0; // Resetando offSet
                      _createBodyHome(); //Criando body da home com os gifs da busca
                    });
                  });
                },
              )
          ),
          //Criando body da home com os gifs trend
          _createBodyHome(),
        ],
      ),
    );
  }

  // Método que constroi o grid com os Gif na home
  Widget _createBodyHome(){
    return Expanded(
        child: FutureBuilder(
          future: _controller.text.isEmpty ?
              _client.getTrends(20).then((value) => _data = value):
              _client.getSearch(_controller.text, _offSet).then((value) => _data = value),
          builder: (context, snapshot){
            //Seletor para escolher o que exibir baseado no resultado da busca
            switch(snapshot.connectionState){
              case ConnectionState.waiting:
              case ConnectionState.none:
                return Container(
                  alignment: Alignment.center,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 5,
                  ),
                );
              default:
                if(snapshot.hasError){
                  return Container(
                    child: Center(
                      child: Text(
                        "Erro na inicialização, reinicie o app!",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                } else{
                  return _createGifTable(context,snapshot); // Função que exibe os gifs pesquisados
                }
            }
          },
        )
    );
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){
    return GridView.builder(
        itemCount: 20,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (context, index){
          // Cria botão para pesquisar mais caso seja o último gif quando há uma busca
          if(_controller.text.isNotEmpty && index == 19){
            return GestureDetector(
              onTap: (){
                setState(() {
                  _offSet += 19;
                });
              },
              child: Container(
                height: 300,
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white,size: 70,),
                    Text(
                      "Mostrar mais...",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    )
                  ],
                ),
              ),
            );
          } else {
            // Desenha o gif na página
            return GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (_) => GifPage(_data["data"][index])));
              },
              onLongPress: (){
                Share.share(_data["data"][index]["images"]["fixed_height"]["url"]);
              },
              child: FadeInImage.memoryNetwork( // Exibe a imagem de uma forma mais amena
                placeholder: kTransparentImage,
                image: _data["data"][index]["images"]["fixed_height"]["url"],
                height: 300,
                fit: BoxFit.cover,
              ),
            );
          }
        }
    );
  }
}
