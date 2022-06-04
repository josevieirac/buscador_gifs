import 'package:http/http.dart' as http;
import 'dart:convert';

//Criando classe para requisições HTTP
class CLientHttp {

  // Método para buscar os GIFS trends
  Future<Map> getTrends(int n) async{
    // Definindo URL para requisição ma API
    var request = Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=E4qOWSyZhnX05YFPWqeLBxj7XXVHXog3&limit=$n&rating=g");

    // Realizando a requisição
    http.Response response = await http.get(request);

    // Convertendo para JSON
    var dados = json.decode(response.body);

    return dados;
  }

  Future<Map> getSearch(String word, int offset) async {
    // Definindo URL para requisição ma API
    var request = Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=E4qOWSyZhnX05YFPWqeLBxj7XXVHXog3&q=$word&limit=19&offset=$offset&rating=g&lang=pt");

    // Realizando a requisição
    http.Response response = await http.get(request);

    //Convertendo para JSON
    var dados = json.decode(response.body);

    return dados;
  }
}