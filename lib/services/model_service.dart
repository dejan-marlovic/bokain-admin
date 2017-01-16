library model_service;

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart';
import 'package:bokain_models/bokain_models.dart';

part 'customer_service.dart';

class ModelService
{
  ModelService(this._name)
  {
    _db = database();
    _ref = _db.ref(_name);
    _ref.onChildAdded.listen(_onChildAdded);
    _ref.onChildChanged.listen(_onChildChanged);
    _ref.onChildRemoved.listen(_onChildRemoved);

    _fetchAll();
  }

  Future push(Model model) async
  {
    await _db.ref('$_name').push(model.properties);
  }

  Future set(Model model) async
  {
    await _db.ref('$_name/${model.id}').set(model.properties);
  }

  Future remove(String id) async
  {
    print(id);
    await _db.ref('$_name/$id').remove();
  }

  List<Model> get models => _models;

  Future _fetchAll() async
  {
    _models = new List();
    await _ref.once('value');
  }

  void _onChildAdded(QueryEvent e)
  {
    _addModel(e.snapshot.val());
  }

  void _onChildChanged(QueryEvent e)
  {
    print("OnChildChanged");
    print(e.snapshot.val());
  }

  void _onChildRemoved(QueryEvent e)
  {
    _models.removeWhere((model) => model.id.compareTo(e.snapshot.val()["id"]) == 0);
  }

  void _addModel(Map<String, dynamic> data)
  {
    switch (_name)
    {
      case "customers":
        _models.add(new Customer.parse(data));
        break;

      default:
        break;
    }
  }

  final String _name;
  Database _db;
  DatabaseReference _ref;
  List<Model> _models;
}