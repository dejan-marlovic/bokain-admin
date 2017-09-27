// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';

@Component(
    selector: 'bo-associative-table',
    styleUrls: const ['associative_table_component.css'],
    templateUrl: 'associative_table_component.html',
    directives: const [CORE_DIRECTIVES, DataTableComponent, materialDirectives],
    pipes: const [PhrasePipe],
    visibility: Visibility.none
)
class AssociativeTableComponent implements OnChanges
{
  AssociativeTableComponent();

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("selectedIds"))
    {
      selectedModels.clear();
      unselectedModels = new Map.from(sourceModels);

      for (String id in selectedIds)
      {
        if (sourceModels.containsKey(id)) selectedModels[id] = sourceModels[id];
        unselectedModels.remove(id);
      }
    }
  }

  void onSelect(String id)
  {
    selectedModels[id] = sourceModels[id];
    unselectedModels.remove(id);
    selectedModels = new Map.from(selectedModels);
    unselectedModels = new Map.from(unselectedModels);
    _selectController.add(id);
  }

  void onUnSelect(String id)
  {
    unselectedModels[id] = sourceModels[id];
    selectedModels.remove(id);
    selectedModels = new Map.from(selectedModels);
    unselectedModels = new Map.from(unselectedModels);

    _unSelectController.add(id);
  }

  Map<String, FoModel> selectedModels = new Map();
  Map<String, FoModel> unselectedModels = new Map();

  @Input('sourceModels')
  Map<String, FoModel> sourceModels;

  @Input('selectedIds')
  List<String> selectedIds = new List();

  @Output('select')
  Stream<String> get selectOutput => _selectController.stream;

  @Output('unselect')
  Stream<String> get unselectOutput => _unSelectController.stream;

  final StreamController<String> _selectController = new StreamController();
  final StreamController<String> _unSelectController = new StreamController();
}
