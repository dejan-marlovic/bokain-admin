library model_service;
import 'dart:async';
import 'package:firebase/firebase.dart';
import 'package:bokain_models/bokain_models.dart';

class ModelService
{
  ModelService(this._name)
  {
    _db = database();
    _ref = _db.ref(_name);
  }

  Future<List<Model>> fetchAll() async
  {
    List<Model> modelList = new List();
    QueryEvent e = await _ref.once('value');
    Map<String, Map<String, dynamic>> table = e.snapshot.val();
    table.forEach((String key, Map<String, dynamic> data)
    {
      print(_name);
      data["id"] = key;
      switch (_name)
      {
        case "customers":
          modelList.add(new Customer.parse(data));
          break;

        default:
          break;
      }
    });
    return modelList;
  }

  Future writeData(Model model) async
  {
    _db.ref('$_name/${model.id}').set(model.properties);
  }

  final String _name;
  Database _db;
  DatabaseReference _ref;
}