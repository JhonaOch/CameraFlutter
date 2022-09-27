

bool isNumeric(String valor){

  if(valor.isEmpty) return false;
  final n = num.tryParse(valor);

  return (n == null) ? false:true;


}




