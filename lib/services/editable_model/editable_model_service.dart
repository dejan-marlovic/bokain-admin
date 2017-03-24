library editable_model_service;

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:bokain_models/bokain_models.dart' show EditableModel, Customer, Room, Salon, Service, User;

part 'customer_service.dart';
part 'salon_service.dart';
part 'service_service.dart';
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

  Map<String, Map<String, dynamic>> findDataByProperty(String property, dynamic value)
  {
    Map<String, Map<String, dynamic>> output = new Map();
    _data.values.where((row) => row[property] == value).toList(growable: false);
    return output;
  }

  Future<String> push(EditableModel model) async
  {
    _loading = true;
    model.created = new DateTime.now();
    model.addedBy = firebase.auth().currentUser.uid;

    await _db.ref('$_name').push(model.encoded);
    _loading = false;

    /// TODO return string with error if found

    return null;
  }

  Future selectedSet() async
  {
    _loading = true;
    await _db.ref('$_name/$_selectedModelId').set(_selectedModel.encoded);
    _loading = false;
  }

  Future set(String id, EditableModel model) async
  {
    _loading = true;
    await _db.ref('$_name/$id').set(model.encoded);
    _loading = false;
  }

  Future remove(String id) async
  {
    try
    {
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

  Map<String, Map<String, String>> get tableData => _tableData;
  Map<String, Map<String, String>> get data => _data;

  bool get isLoading => _loading;

  EditableModel get selectedModel => _selectedModel;

  String get selectedModelId => _selectedModelId;

  EditableModel getModel(String id) => _data.containsKey(id) ? createModelInstance(_data[id]) : null;

  List<EditableModel> getModels(List<String> ids)
  {
    List<EditableModel> models = new List();
    _data.keys.where((ids.contains)).forEach((id) => models.add(createModelInstance(_data[id])));
    return models;
  }

  Map<String, Map<String, dynamic>> getRows(List<String> ids)
  {
    Map<String, Map<String, dynamic>> output = new Map();
    _data.keys.where((ids.contains)).forEach((id) => output[id] = _data[id]);
    return output;
  }

  void set selectedModel(EditableModel model)
  {
    _selectedModel = model;
  }

  void set selectedModelId(String id)
  {
    _selectedModelId = id;
    _selectedModel = (_selectedModelId == null || !_data.containsKey(id)) ? null : createModelInstance(_data[id]);
  }

  void _onChildAdded(firebase.QueryEvent e)
  {
    _data[e.snapshot.key] = e.snapshot.val();
    _tableData[e.snapshot.key] = createModelInstance(e.snapshot.val()).toTable;
  }

  void _onChildChanged(firebase.QueryEvent e)
  {
    _data[e.snapshot.key] = e.snapshot.val();
    _tableData[e.snapshot.key] = createModelInstance(e.snapshot.val()).toTable;
  }

  void _onChildRemoved(firebase.QueryEvent e)
  {
    _data.remove(e.snapshot.key);
    _tableData.remove(e.snapshot.key);
  }

  EditableModel createModelInstance(Map<String, dynamic> data);

  final String _name;
  firebase.Database _db;
  Map<String, Map<String, dynamic>> _data = new Map();
  Map<String, Map<String, String>> _tableData = new Map();
  String _selectedModelId;
  EditableModel _selectedModel;
  bool _loading = false;

  String searchKeywords = "";
}