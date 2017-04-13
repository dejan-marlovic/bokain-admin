library model_service;

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:bokain_admin/services/calendar_service.dart';
import 'package:bokain_models/bokain_models.dart' show Booking, Customer, Day, EditableModel, Increment, ModelBase, Room, Salon, Service, ServiceAddon, User;

part 'booking_service.dart';
part 'customer_service.dart';
part 'salon_service.dart';
part 'service_service.dart';
part 'service_addon_service.dart';
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
  }

  Map<String, Map<String, dynamic>> findDataByProperty(String property, dynamic value)
  {
    Map<String, Map<String, dynamic>> output = new Map();
    _data.values.where((row) => row[property] == value).toList(growable: false);
    return output;
  }

  Future<String> push(ModelBase model) async
  {
    _loading = true;
    model.created = new DateTime.now();
    if (model is EditableModel) model.addedBy = firebase.auth().currentUser.uid;

    firebase.ThenableReference ref = await _ref.push(model.encoded);
    _loading = false;

    return ref.key;
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
    await _ref.child('$id').set(model.encoded);
    _loading = false;
  }

  Future remove(String id) async
  {
    try
    {
      _loading = true;
      await _ref.child('$id').remove();
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

  ModelBase getModel(String id) => _data.containsKey(id) ? createModelInstance(_data[id]) : null;

  List<ModelBase> getModels(List<String> ids)
  {
    List<ModelBase> models = new List();
    _data.keys.where((ids.contains)).forEach((id) => models.add(createModelInstance(_data[id])));
    return models;
  }

  Map<String, Map<String, dynamic>> getRows(List<String> ids, [bool as_table = false])
  {
    Map<String, Map<String, dynamic>> output = new Map();
    if (as_table == true) _tableData.keys.where((ids.contains)).forEach((id) => output[id] = _tableData[id]);
    else _data.keys.where((ids.contains)).forEach((id) => output[id] = _data[id]);
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

  ModelBase createModelInstance(Map<String, dynamic> data);

  final String _name;
  firebase.Database _db;
  firebase.DatabaseReference _ref;
  Map<String, Map<String, dynamic>> _data = new Map();
  Map<String, Map<String, String>> _tableData = new Map();
  String _selectedModelId;
  EditableModel _selectedModel;
  bool _loading = false;


  String searchKeywords = "";
}