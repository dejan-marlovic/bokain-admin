// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show PhrasePipe;

@Component(
    selector: 'bo-schedule-selection-mode',
    styleUrls: const ['schedule_selection_mode_component.css'],
    templateUrl: 'schedule_selection_mode_component.html',
    directives: const [materialDirectives],
    pipes: const [PhrasePipe]
)
class ScheduleSelectionModeComponent implements OnDestroy
{
  ScheduleSelectionModeComponent();

  void ngOnDestroy()
  {
    _onStateChangeController.close();
  }

  String get state => _state;

  void set state(String value)
  {
    _state = value;
    _onStateChangeController.add(_state);
  }

  @Input('disabled')
  bool disabled = true;

  @Input('state')
  void set stateExternal(String value)
  {
    _state = value;
  }

  String _state = "open";

  @Output('stateChange')
  Stream<String> get onStateChangeOutput => _onStateChangeController.stream;

  StreamController<String> _onStateChangeController = new StreamController();

}
