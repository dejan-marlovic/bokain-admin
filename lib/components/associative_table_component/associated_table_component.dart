// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:collection' show LinkedHashMap;
import 'package:angular2/core.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-associative-table',
    styleUrls: const ['associative_table_component.css'],
    templateUrl: 'associative_table_component.html',
    directives: const [materialDirectives, DataTableComponent],
    preserveWhitespace: false
)
class AssociativeTableComponent
{
  AssociativeTableComponent(this.phrase)
  {
  }

  Map<String, Map<String, String>> get filteredDataUpper
  {
    return _filterAndSort(_upperSortColumn, _upperSortOrder, upperKeywords, sourceData, true);
  }

  Map<String, Map<String, String>> get filteredDataLower
  {
    return _filterAndSort(_lowerSortColumn, _lowerSortOrder, lowerKeywords, sourceData, false);

    /*
    _filteredDataLower.clear();
    if (lowerKeywords.isEmpty)
    {
      for (String key in _sourceData.keys.where((v) => !selectedIds.contains(v)))
      {
        _filteredDataLower[key] = _sourceData[key];
      }
    }
    else
    {
      for (String key in _sourceData.keys.where((v) => !selectedIds.contains(v)))
      {
        if (_find(lowerKeywords.split(" "), _sourceData[key])) _filteredDataLower[key] = _sourceData[key];
      }
    }
    _filteredDataLower = _filterAndSort(_lowerSortColumn, _lowerSortOrder, _filteredDataLower);
    return _filteredDataLower;
    */
  }

  void select(String id)
  {
    foSelect.emit(id);
  }

  void unselect(String id)
  {
    foUnselect.emit(id);
  }

  void sortUpper(Map<String, String> e)
  {
    _upperSortOrder = e["order"];
    _upperSortColumn = e["column"];
  }

  void sortLower(Map<String, String> e)
  {
    _lowerSortOrder = e["order"];
    _lowerSortColumn = e["column"];
  }

  Map<String, Map<String, String>> _filterAndSort(String column, String order, String keywords, Map<String, Map<String, String>> data, bool upper)
  {
    if (data == null || data.isEmpty) return data;
    if (column.isEmpty) column = data.values.first.keys.first;
    Map<String, Map<String, String>> filteredData = new Map();

    if (upper)
    {
      if (keywords.isEmpty)
      {
        for (String key in sourceData.keys.where(selectedIds.contains))
        {
          filteredData[key] = sourceData[key];
        }
      }
      else
      {
        for (String key in sourceData.keys.where(selectedIds.contains))
        {
          if (_find(keywords.split(" "), sourceData[key]))
          {
            filteredData[key] = sourceData[key];
          }
        }
      }
    }
    else
    {
      if (keywords.isEmpty)
      {
        for (String key in sourceData.keys.where((v) => !selectedIds.contains(v)))
        {
          filteredData[key] = sourceData[key];
        }
      }
      else
      {
        for (String key in sourceData.keys.where((v) => !selectedIds.contains(v)))
        {
          if (_find(keywords.split(" "), sourceData[key]))
          {
            filteredData[key] = sourceData[key];
          }
        }
      }
    }

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
    List<Map<String, String>> values = filteredData.values.toList(growable: false);
    values.sort((Map<String, String> a, Map<String, String> b) => sortFn(a, b, column, order));
    for (Map<String, String> value in values)
    {
      bufferMap[data.keys.firstWhere((key) => filteredData[key] == value)] = value;
    }

    return bufferMap;
  }

  bool _find(List<String> needles, Map<String, String> haystack)
  {
    for (String needle in needles.where((v) => v.isNotEmpty && v != ""))
    {
      if (haystack.values.where((v) => v.toLowerCase().contains(needle.toLowerCase())).isNotEmpty) return true;
    }
    return false;
  }

  final PhraseService phrase;

  @Input('sourceData')
  Map<String, Map<String, String>> sourceData;

  @Input('selectedIds')
  List<String> selectedIds;

  @Output('fo-select')
  final EventEmitter<String> foSelect = new EventEmitter();

  @Output('fo-unselect')
  final EventEmitter<String> foUnselect = new EventEmitter();

  String upperKeywords = "", lowerKeywords = "";

  String _upperSortColumn = "";
  String _lowerSortColumn = "";
  String _upperSortOrder = "ASC";
  String _lowerSortOrder = "ASC";
}
