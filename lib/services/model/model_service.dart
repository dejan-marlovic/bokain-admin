library model_service;

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart' show SelectionOptions, OptionGroup;
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

  Future set(String id, ModelBase model) async
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

  List<ModelBase> getModelObjects({List<String> ids : null, bool include_disabled : false})
  {
    List<ModelBase> output = (ids == null) ? new List.from(_models.values) : _models.values.where((m) => ids.contains(m.id)).toList(growable: !include_disabled);
    if (include_disabled == false)
    {
      output.removeWhere((model) => model.data.containsKey("status") && model.data["status"] != "active");
    }
    return output;
  }

  bool get isLoading => _loading;

  ModelBase getModel(String id) => _models.containsKey(id) ? _models[id] : null;

  List<String> get modelIds => _models.keys.toList(growable: false);

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
    int index = _optionGroup.indexOf(_optionGroup.firstWhere((m) => m.id == e.snapshot.key));
    _optionGroup.removeAt(index);
    _optionGroup.insert(index, model);

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
  bool _loading = false;

  Map<String, ModelBase> _models = new Map();
  OptionGroup<ModelBase> _optionGroup = new OptionGroup([]);
  SelectionOptions<ModelBase> modelOptions;
}