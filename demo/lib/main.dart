import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MaterialApp(
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  _realizaPagamento() async {
    var url = Uri.parse("https://api.pagar.me/1/transactions/");
//"ak_live_Km1jt6ZkY3RnXEf4imoenyC5hYK3mD"
    var corpo = json.encode(
      {
     "api_key": "ak_live_Km1jt6ZkY3RnXEf4imoenyC5hYK3mD",
    "amount": 21000,
    "card_number": "4111111111111111",
    "card_cvv": "123",
    "card_expiration_date": "0922",
    "card_holder_name": "Morpheus Fishburne",
    "customer": {
      "external_id": "#3311",
      "name": "Morpheus Fishburne",
      "type": "individual",
      "country": "br",
      "email": "mopheus@nabucodonozor.com",
      "documents": [
        {
          "type": "cpf",
          "number": "00000000000"
        }
      ],
      "phone_numbers": ["+5511999998888", "+5511888889999"],
      "birthday": "1965-01-01"
    },
    "billing": {
      "name": "Trinity Moss",
      "address": {
        "country": "br",
        "state": "sp",
        "city": "Cotia",
        "neighborhood": "Rio Cotia",
        "street": "Rua Matrix",
        "street_number": "9999",
        "zipcode": "06714360"
      }
    },
    "shipping": {
      "name": "Neo Reeves",
      "fee": 1000,
      "delivery_date": "2000-12-21",
      "expedited": true,
      "address": {
        "country": "br",
        "state": "sp",
        "city": "Cotia",
        "neighborhood": "Rio Cotia",
        "street": "Rua Matrix",
        "street_number": "9999",
        "zipcode": "06714360"
      }
    },
    "items": [
      {
        "id": "r123",
        "title": "Red pill",
        "unit_price": 10000,
        "quantity": 1,
        "tangible": true
      },
      {
        "id": "b123",
        "title": "Blue pill",
        "unit_price": 10000,
        "quantity": 1,
        "tangible": true
      }
    ]
}
    );

    http.Response response = await http.post(url,
        headers: {"content-type": 'application/json'},
        body: corpo);

    print("status code: " + response.statusCode.toString());
    print("status code: " + response.body.toString());

//print('Response status: ${response.statusCode.toString()}');
//print('Response body: ${response.body}');
  }

  @override
  void initState() {
    super.initState();
    _realizaPagamento();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("teste"),
      ),
      body: Center(
        child: Text("teste"),
      ),
    );
  }
}
