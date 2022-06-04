import 'dart:async';
import 'dart:ui';

//Classe para implementar o debouncer para ser utilizado no campo de busca
class Debouncer {
  late Timer _debounce;
  late int milliseconds;

  // Construtor da classe
  Debouncer(int milliseconds){
    this.milliseconds = milliseconds;
    this._debounce = Timer(Duration(milliseconds: milliseconds), () {});
  }

  //Método principal
  run(VoidCallback action) {
    if (_debounce.isActive) _debounce.cancel();
    _debounce = Timer(Duration(milliseconds: milliseconds), action);
  }

}