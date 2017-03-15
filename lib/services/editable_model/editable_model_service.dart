library editable_model_service;

import 'dart:async';
import 'dart:collection' show LinkedHashMap;
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

  void updateFilter()
  {
    _filteredData.clear();
    if (searchKeywords.isEmpty) _data.forEach((String key, Map<String, dynamic> d) => _filteredData[key] = getModel(key).toTable);
    else
    {
      List<String> keywordList = searchKeywords.split(" ");
      _data.forEach((String key, Map<String, dynamic> d)
      {
        EditableModel model = createModelInstance(d);
        if (keywordList.where(model.matchesKeyword).length == keywordList.length) _filteredData[key] = model.toTable;
      });
    }
  }

  void onSort(Map<String, String> event)
  {
    String sortColumn = event["column"];
    String sortOrder = event["order"];

    int sortFn(Map<String, String> a, Map<String, String> b, String column, String order)
    {
      try
      {
        num numA = num.parse(a[column]);
        num numB = num.parse(b[column]);
        return (order == "ASC") ? (numA - numB).toInt() : (numB - numA).toInt();
      }
      on FormatException
      {
        return (order == "ASC") ? a[column].compareTo(b[column]) : b[column].compareTo(a[column]);
      }
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

  Map<String, Map<String, dynamic>> findDataByProperty(String property, dynamic value)
  {
    Map<String, Map<String, dynamic>> output = new Map();
    _data.keys.where((row) => row[property] == value).toList(growable: false);
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

  Future set() async
  {
    _loading = true;
    await _db.ref('$_name/$_selectedModelId').set(_selectedModel.encoded);
    updateFilter();
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

  LinkedHashMap<String, Map<String, String>> get filteredData => _filteredData;
  Map<String, Map<String, String>> get data => _data;

  bool get isLoading => _loading;

  EditableModel get selectedModel => _selectedModel;

  EditableModel getModel(String id) => _data.containsKey(id) ? createModelInstance(_data[id]) : null;

  List<EditableModel> getModels(List<String> ids)
  {
    List<EditableModel> models = new List();
    _data.keys.where((ids.contains)).forEach((id) => models.add(createModelInstance(_data[id])));
    return models;
  }

  Map<String, Map<String, String>> getRows(List<String> ids)
  {
    Map<String, Map<String, String>> output = new Map();
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
    updateFilter();
  }

  void _onChildChanged(firebase.QueryEvent e)
  {
    _data[e.snapshot.key] = e.snapshot.val();
  }

  void _onChildRemoved(firebase.QueryEvent e)
  {
    _data.remove(e.snapshot.key);
  }

  EditableModel createModelInstance(Map<String, String> data);

  final String _name;
  firebase.Database _db;
  Map<String, Map<String, String>> _data = new Map();
  LinkedHashMap<String, Map<String, String>> _filteredData = new LinkedHashMap();
  String _selectedModelId;
  EditableModel _selectedModel;
  bool _loading = false;

  String searchKeywords = "";
}