library editable_model_service;

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:bokain_models/bokain_models.dart' show EditableModel, Customer, Salon, User;

part 'customer_service.dart';
part 'salon_service.dart';
part 'user_service.dart';

abstract class EditableModelService
{
  EditableModelService(this._name)
  {
    _db = firebase.database();
    final firebase.DatabaseReference ref = _db.ref(_name);
    ref.onChildAdded.listen(_onChildAdded);
    ref.onChildChanged.listen(_onChildChanged);
    ref.onChildRemoved.listen(_onChildRemoved);
  }

  Iterable<EditableModel> findByProperty(String property, String value)
  {
    return modelMap.values.where((model) => model.properties[property] == value);
  }

  Future<String> push(EditableModel model) async
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
    await _db.ref('$_name/${getId(selectedModel)}').set(selectedModel.properties);
    _loading = false;
  }

  Future remove(EditableModel model) async
  {
    try
    {
      _loading = true;
      await _db.ref('$_name/${getId(model)}').remove();
      _loading = false;
    }
    on RangeError catch (e, s)
    {
      print(e);
      print(s);
    }
  }

  Map<String, EditableModel> get modelMap => _modelMap;

  bool get isLoading => _loading;

  EditableModel get selectedModel => (_selectedModelId == null) ? null : _modelMap[_selectedModelId];

  void set selectedModel(EditableModel model)
  {
    if (_modelMap.containsValue(model))
    {
      _selectedModelId = getId(model);
      _modelMap[_selectedModelId] = model;
    }
    else if (model == null) _selectedModelId = null;
    else _modelMap[_selectedModelId] = model;
  }

  String getId(EditableModel model)
  {
    return _modelMap.keys.elementAt(_modelMap.values.toList(growable: false).indexOf(model));
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
    _modelMap.remove(e.snapshot.key);
  }

  void _setModel(String key, Map<String, dynamic> data);

  final String _name;
  firebase.Database _db;
  Map<String, EditableModel> _modelMap = new Map();
  Map<String, String> _customErrors = new Map();
  String _selectedModelId;
  bool _loading = false;
}