// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
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
    _filteredDataUpper.clear();

    if (upperKeywords.isEmpty)
    {
      for (String key in sourceData.keys.where(selectedIds.contains))
      {
        _filteredDataUpper[key] = sourceData[key];
      }
    }
    else
    {
      for (String key in sourceData.keys.where(selectedIds.contains))
      {
        if (_find(upperKeywords.split(" "), sourceData[key])) _filteredDataUpper[key] = sourceData[key];
      }
    }

    return _filteredDataUpper;
  }

  Map<String, Map<String, String>> get filteredDataLower
  {
    _filteredDataLower.clear();

    if (lowerKeywords.isEmpty)
    {
      for (String key in sourceData.keys.where((v) => !selectedIds.contains(v)))
      {
        _filteredDataLower[key] = sourceData[key];
      }
    }
    else
    {
      for (String key in sourceData.keys.where((v) => !selectedIds.contains(v)))
      {
        if (_find(lowerKeywords.split(" "), sourceData[key])) _filteredDataLower[key] = sourceData[key];
      }
    }
    return _filteredDataLower;
  }

  void select(String id)
  {
    foSelect.emit(id);
  }

  void unselect(String id)
  {
    foUnselect.emit(id);
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

  Map<String, Map<String, String>> _filteredDataUpper = new Map();
  Map<String, Map<String, String>> _filteredDataLower = new Map();

  String upperKeywords = "", lowerKeywords = "";
}
