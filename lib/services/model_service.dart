library model_service;

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart';
import 'package:bokain_models/bokain_models.dart';

part 'customer_service.dart';

abstract class ModelService
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

  Model findByProperty(String key, String value)
  {
    return modelMap.values.firstWhere((model) => model.properties[key] == value, orElse: () => null);
  }

  Future push(Model model) async
  {
    _loading = true;
    model.created = new DateTime.now().toIso8601String();
    model.addedBy = auth().currentUser.uid;

    await _db.ref('$_name').push(model.properties);
    _loading = false;
  }

  Future set(String id, Model model) async
  {
    _loading = true;
    await _db.ref('$_name/$id').set(model.properties);
    _loading = false;
  }

  Future remove(Model model) async
  {
    try
    {
      String id = _models.keys.elementAt(_models.values.toList(growable: false).indexOf(model));
      _loading = true;
      await _db.ref('$_name/$id').remove();
      _loading = false;
    }
    on RangeError catch (e, s)
    {
      print(e);
      print(s);
    }
  }

  Map<String, Model> get modelMap => _models;

  bool get isLoading => _loading;

  Future _fetchAll() async
  {
    /// TODO change this to onValue.first
    _loading = true;
    _models = new Map();
    await _ref.once('value');
    _loading = false;
  }

  void _onChildAdded(QueryEvent e)
  {
    _addModelToList(e.snapshot.key, e.snapshot.val());
  }

  void _onChildChanged(QueryEvent e)
  {
    print("OnChildChanged");
    print(e.snapshot.val());
  }

  void _onChildRemoved(QueryEvent e)
  {
    _models.remove(e.snapshot.key);
  }

  void _addModelToList(String key, Map<String, dynamic> data)
  {
    switch (_name)
    {
      case "customers":
        _models[key] = new Customer.parse(data);
        break;

      default:
        break;
    }
  }

  final String _name;
  Database _db;
  DatabaseReference _ref;
  Map<String, Model> _models;

  bool _loading = false;
}