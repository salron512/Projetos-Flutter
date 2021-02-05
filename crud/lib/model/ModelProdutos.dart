class ModelProdutos{
  int  id;
  String nome;
  String preco;
  String marca;

  ModelProdutos(this.nome, this.preco, this.marca);

  ModelProdutos.fromMap (Map map){
    this.id = map["id"];
    this.nome = map["nome"];
    this.preco = map["preco"];
    this.marca = map ["marca"];
  }
  Map toMap(){
    Map<String, dynamic> map ={
      "nome": this.nome,
      "preco": this.preco,
      "marca": this.marca
    };
    if(this.id !=null) {
      map["id"] = this.id;
    }
    return map;
  }
}