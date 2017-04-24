library model_service;

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart' show SelectionOptions, OptionGroup;
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

    modelOptions = new SelectionOptions([_optionGroup]);
  }

  Map<String, Map<String, dynamic>> findDataByProperty(String property, dynamic value)
  {
    Map<String, Map<String, dynamic>> output = new Map();
    _models.values.where((model) => model.data[property] == value).toList(growable: false);
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

  Map<String, ModelBase> get models => _models;

  bool get isLoading => _loading;

  EditableModel get selectedModel => _selectedModel;

  String get selectedModelId => _selectedModelId;

  ModelBase getModel(String id) => _models.containsKey(id) ? _models[id] : null;

  Iterable<ModelBase> getModels(List<String> ids) => _models.values.where((model) => ids.contains(model.id));//_models.keys.where((ids.contains)).toList(growable: false).map((id) => _models[id]);

  Map<String, Map<String, dynamic>> getRows([List<String> ids = null, bool as_table = false])
  {
    Map<String, Map<String, dynamic>> output = new Map();

    if (ids == null)
    {
      if (as_table == true) _models.keys.forEach((id) => output[id] = _models[id].toTable);
      else _models.keys.forEach((id) => output[id] = _models[id].data);
    }
    else
    {
      if (as_table == true) _models.keys.where((ids.contains)).forEach((id) => output[id] = _models[id].toTable);
      else _models.keys.where((ids.contains)).forEach((id) => output[id] = _models[id].data);
    }
    return output;
  }

  void set selectedModel(EditableModel model)
  {
    _selectedModel = model;
    _selectedModelId = _models.keys.firstWhere((id) => _models[id] == model, orElse: () => null);
  }

  void set selectedModelId(String id)
  {
    _selectedModelId = id;
    _selectedModel = (_selectedModelId != null && _models.containsKey(id)) ? _models[id] : null;
  }

  void _onChildAdded(firebase.QueryEvent e)
  {
    ModelBase model = createModelInstance(e.snapshot.key, e.snapshot.val());
    _models[e.snapshot.key] = model;
    _optionGroup.add(model);
    modelOptions = new SelectionOptions([_optionGroup]);
  }

  void _onChildChanged(firebase.QueryEvent e)
  {
    ModelBase model = createModelInstance(e.snapshot.key, e.snapshot.val());
    _models[e.snapshot.key] = model;
    _optionGroup.removeWhere((m) => m.id == e.snapshot.key);
    _optionGroup.add(model);
    modelOptions = new SelectionOptions([_optionGroup]);
  }

  void _onChildRemoved(firebase.QueryEvent e)
  {
    _models.remove(e.snapshot.key);
    _optionGroup.removeWhere((m) => m.id == e.snapshot.key);
    modelOptions = new SelectionOptions([_optionGroup]);
  }

  ModelBase createModelInstance(String id, Map<String, dynamic> data);

  final String _name;
  firebase.Database _db;
  firebase.DatabaseReference _ref;
  String _selectedModelId;
  EditableModel _selectedModel;
  bool _loading = false;

  Map<String, ModelBase> _models = new Map();
  OptionGroup<ModelBase> _optionGroup = new OptionGroup([]);
  SelectionOptions<ModelBase> modelOptions;
}