class ModelClientes {
  int id;
  String nome;
  String endereco;
  String telefone;


  ModelClientes( this.nome, this.endereco, this.telefone);

  ModelClientes.fromMap (Map map){
    this.id = map["id"];
    this.nome = map["nome"];
    this.endereco = map["endereco"];
    this.telefone = map ["telefone"];
  }
  Map toMap(){
    Map<String, dynamic> map ={
      "nome": this.nome,
      "endereco": this.endereco,
      "telefone": this.telefone
    };
    if(this.id !=null) {
      map["id"] = this.id;
    }
    return map;
  }
}