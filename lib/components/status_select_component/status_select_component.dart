// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:async' show Stream, StreamController;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import '../status_select_component/status_model.dart';

@Component(
    selector: 'bo-status-select',
    styleUrls: const ['status_select_component.css'],
    templateUrl: 'status_select_component.html',
    directives: const [CORE_DIRECTIVES, FoSelectComponent, materialDirectives],
    pipes: const [PhrasePipe]
)
class StatusSelectComponent implements OnDestroy
{
  StatusSelectComponent(PhraseService ps) : options = new StringSelectionOptions(
  [
    new Status(ps.get('active'), "active"),
    new Status(ps.get('frozen'), 'frozen'),
    new Status(ps.get('disabled'), 'disabled')
  ])
  {
    _model = options.optionsList.first;
  }

  @override
  void ngOnDestroy()
  {
    _onStatusChangeStream.close();
  }

  Status get model => _model;

  void set model(Status model)
  {
    _onStatusChangeStream.add(model.id);
  }

  final StringSelectionOptions<Status> options;
  final StreamController<String> _onStatusChangeStream = new StreamController();
  Status _model;

  @Input('status')
  void set status(String value)
  {
    _model = options.optionsList.firstWhere((s) => s.id == value);
  }

  @Output('statusChange')
  Stream<String> get statusChange => _onStatusChangeStream.stream;
}
