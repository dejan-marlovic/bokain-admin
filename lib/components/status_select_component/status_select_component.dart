// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:async' show Stream, StreamController;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_admin/components/status_select_component/status_model.dart';

@Component(
    selector: 'bo-status-select',
    styleUrls: const ['status_select_component.css'],
    templateUrl: 'status_select_component.html',
    directives: const [CORE_DIRECTIVES, FoSelectComponent, materialDirectives],
    pipes: const [PhrasePipe]
)
class StatusSelectComponent implements OnDestroy
{
  StatusSelectComponent(this._phraseService) :
        options = [new Status(_phraseService.get('active'), "1"), new Status(_phraseService.get('frozen'), '2'), new Status(_phraseService.get('disabled'), '3')]
  {
    _model = options.first;
  }

  @override
  void ngOnDestroy()
  {
    _onStatusChangeStream.close();
  }

  Status get model => _model;

  void set model(Status model)
  {
    _onStatusChangeStream.add(model.name);
  }

  final List<Status> options;
  final PhraseService _phraseService;
  final StreamController<String> _onStatusChangeStream = new StreamController();
  Status _model;

  @Input('status')
  void set status(String value)
  {
    _model = options.firstWhere((s) => s.name == _phraseService.get(value));
  }

  @Output('statusChange')
  Stream<String> get statusChange => _onStatusChangeStream.stream;
}
