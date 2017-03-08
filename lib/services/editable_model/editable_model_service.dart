library editable_model_service;

import 'dart:async';
import 'dart:collection' show LinkedHashMap;
import 'package:angular2/core.dart';
import 'package:firebase/firebase.dart' as firebase;
import 'package:bokain_models/bokain_models.dart' show EditableModel, Customer, Salon, Service, User;

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

  void updateFilter()
  {
    _filteredData.clear();
    if (searchKeywords.isEmpty)
    {
      _modelMap.forEach((String key, EditableModel model) => _filteredData[key] = model.toTable);
      return;
    }

    List<String> keywordList = searchKeywords.split(" ");
    _modelMap.forEach((String key, EditableModel model)
    {
      if (keywordList.where(model.matchesKeyword).length == keywordList.length)
      {
        _filteredData[key] = model.toTable;
      }
    });
  }

  void onSort(Map<String, String> event)
  {
    String sortColumn = event["column"];
    String sortOrder = event["order"];

    int sortFn(Map<String, String> a, Map<String, String> b, String column, String order)
    {
      return (order == "ASC") ? a[column].compareTo(b[column]) : b[column].compareTo(a[column]);
    }
    LinkedHashMap<String, Map<String, String>> bufferMap = new LinkedHashMap();
    List<Map<String, String>> values = _filteredData.values.toList(growable: false);
    values.sort((Map<String, String> a, Map<String, String> b) => sortFn(a, b, sortColumn, sortOrder));

    for (Map<String, String> value in values)
    {
      bufferMap[_filteredData.keys.firstWhere((key) => _filteredData[key] == value)] = value;
    }
    _filteredData = bufferMap;
  }

  Iterable<EditableModel> findByProperty(String property, dynamic value) => modelMap.values.where((model) => model.data[property] == value);

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

  Future set() async
  {
    _loading = true;
    await _db.ref('$_name/${getId(selectedModel)}').set(selectedModel.encoded);
    updateFilter();
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

  LinkedHashMap<String, Map<String, String>> get filteredData => _filteredData;
  Map<String, EditableModel> get modelMap => _modelMap;

  bool get isLoading => _loading;

  EditableModel get selectedModel => (_selectedModelId == null) ? null : _modelMap[_selectedModelId];

  String getId(EditableModel model)
  {
    return _modelMap.keys.elementAt(_modelMap.values.toList(growable: false).indexOf(model));
  }

  EditableModel getModel(String id)
  {
    return _modelMap.containsKey(id) ? _modelMap[id] : null;
  }

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

  void _onChildAdded(firebase.QueryEvent e)
  {
    _createModelInstance(e.snapshot.key, e.snapshot.val());
    updateFilter();
  }

  void _onChildChanged(firebase.QueryEvent e)
  {
    _createModelInstance(e.snapshot.key, e.snapshot.val());
  }

  void _onChildRemoved(firebase.QueryEvent e)
  {
    _modelMap.remove(e.snapshot.key);
  }

  void _createModelInstance(String key, Map<String, String> data);

  final String _name;
  firebase.Database _db;
  Map<String, EditableModel> _modelMap = new Map();
  LinkedHashMap<String, Map<String, String>> _filteredData = new LinkedHashMap();
  String _selectedModelId;
  bool _loading = false;

  String searchKeywords = "";
}