library model_service;

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:bokain_models/bokain_models.dart';

part 'customer_service.dart';
part 'user_service.dart';

abstract class ModelService
{
  ModelService(this._name)
  {
    _db = firebase.database();
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

  Future<String> push(Model model) async
  {
    _loading = true;
    model.created = new DateTime.now().toIso8601String();
    model.addedBy = firebase.auth().currentUser.uid;

    await _db.ref('$_name').push(model.properties);
    _loading = false;

    /// TODO return string with error if found

    return null;
  }

  Future set() async
  {
    _loading = true;
    await _db.ref('$_name/$selectedModelId').set(modelMap[selectedModelId].properties);
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

  void _onChildAdded(firebase.QueryEvent e)
  {
    _setModel(e.snapshot.key, e.snapshot.val());
  }

  void _onChildChanged(firebase.QueryEvent e)
  {
    _setModel(e.snapshot.key, e.snapshot.val());
  }

  void _onChildRemoved(firebase.QueryEvent e)
  {
    _models.remove(e.snapshot.key);
  }


  void _setModel(String key, Map<String, dynamic> data);

  final String _name;
  firebase.Database _db;
  firebase.DatabaseReference _ref;
  Map<String, Model> _models;

  String selectedModelId;

  bool _loading = false;
}