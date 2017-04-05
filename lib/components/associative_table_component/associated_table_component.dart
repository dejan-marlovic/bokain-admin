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

  Map<String, Map<String, String>> get selectedData
  {
    Map<String, Map<String, String>> output = new Map();
    for (String key in sourceData?.keys?.where(selectedIds.contains))
    {
      output[key] = sourceData[key];
    }
    return output;
  }

  Map<String, Map<String, String>> get unselectedData
  {
    Map<String, Map<String, String>> output = new Map();
    for (String key in sourceData?.keys?.where((k) => !selectedIds.contains(k)))
    {
      output[key] = sourceData[key];
    }
    return output;
  }

  final PhraseService phrase;

  @Input('sourceData')
  Map<String, Map<String, String>> sourceData;

  @Input('selectedIds')
  List<String> selectedIds = new List();

  @Output('fo-select')
  final EventEmitter<String> foSelect = new EventEmitter();

  @Output('fo-unselect')
  final EventEmitter<String> foUnselect = new EventEmitter();
}
