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
    dataUpper["test"] = new Map();
    dataUpper["test"]["hej"] = "banana";

    dataLower["aldkvad"] = new Map();
    dataLower["aldkvad"]["hej"] = "apple";
    dataLower["qqq"] = new Map();
    dataLower["qqq"]["hej"] = "orange";
  }

  void updateUpperFilter()
  {
    if (upperKeywords.isEmpty) filteredDataUpper = new Map.from(dataUpper);
    else
    {
      filteredDataUpper.clear();
      List<String> keywordList = upperKeywords.split(" ");
      dataUpper.forEach((String key, Map<String, String> value)
      {
        if (keywordList.where(value.containsValue).length == keywordList.length)
        {
          filteredDataUpper[key] = dataUpper[key];
        }
      });
    }
  }

  void updateLowerFilter()
  {
    if (lowerKeywords.isEmpty) filteredDataLower = new Map.from(dataLower);
    else
    {
      filteredDataLower.clear();
      List<String> keywordList = lowerKeywords.split(" ");
      dataLower.forEach((String key, Map<String, String> value)
      {
        if (keywordList.where(value.containsValue).length == keywordList.length)
        {
          filteredDataLower[key] = dataLower[key];
        }
      });
    }
  }

  void moveToLower(String id)
  {
    dataLower[id] = new Map.from(dataUpper[id]);
    dataUpper.remove(id);

    updateUpperFilter();
    updateLowerFilter();
  }

  moveToUpper(String id)
  {
    dataUpper[id] = new Map.from(dataLower[id]);
    dataLower.remove(id);

    updateUpperFilter();
    updateLowerFilter();
  }

  final PhraseService phrase;

  @Input('data-upper')
  Map<String, Map<String, String>> dataUpper = new Map();

  @Input('data-lower')
  Map<String, Map<String, String>> dataLower = new Map();

  Map<String, Map<String, String>> filteredDataUpper = new Map();
  Map<String, Map<String, String>> filteredDataLower = new Map();

  String upperKeywords = "", lowerKeywords = "";
}
