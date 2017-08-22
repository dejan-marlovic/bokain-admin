// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';

@Component(
    selector: 'bo-associative-table',
    styleUrls: const ['associative_table_component.css'],
    templateUrl: 'associative_table_component.html',
    directives: const [materialDirectives, DataTableComponent],
    pipes: const [PhrasePipe]
)
class AssociativeTableComponent
{
  AssociativeTableComponent();

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

  @Input('sourceModels')
  Map<String, DataTableModel> sourceModels;

  @Input('selectedIds')
  List<String> selectedIds = new List();

  @Output('select')
  Stream<String> get selectOutput => selectController.stream;

  @Output('unselect')
  Stream<String> get unselectOutput => unSelectController.stream;

  final StreamController<String> selectController = new StreamController();
  final StreamController<String> unSelectController = new StreamController();
}
