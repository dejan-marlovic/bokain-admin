// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show PhraseService;
import 'package:fo_components/fo_components.dart' show DataTableComponent, DataTableModel;

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

  Map<String, DataTableModel> get selectedModels
  {
    Map<String, DataTableModel> output = new Map();
    for (String key in sourceModels?.keys?.where(selectedIds.contains))
    {
      output[key] = sourceModels[key];
    }
    return output;
  }

  Map<String, DataTableModel> get unselectedModels
  {
    Map<String, DataTableModel> output = new Map();
    for (String key in sourceModels?.keys?.where((k) => !selectedIds.contains(k)))
    {
      output[key] = sourceModels[key];
    }
    return output;
  }

  final PhraseService phrase;

  @Input('sourceModels')
  Map<String, DataTableModel> sourceModels;

  @Input('selectedIds')
  List<String> selectedIds = new List();

  @Output('fo-select')
  Stream<String> get foSelect => foSelectController.stream;

  @Output('fo-unselect')
  Stream<String> get foUnselect => foUnselectController.stream;

  final StreamController<String> foUnselectController = new StreamController();
  final StreamController<String> foSelectController = new StreamController();
}
