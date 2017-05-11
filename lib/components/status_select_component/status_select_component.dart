// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'dart:async' show Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:bokain_models/bokain_models.dart' show PhraseService;

@Component(
    selector: 'bo-status-select',
    styleUrls: const ['status_select_component.css'],
    templateUrl: 'status_select_component.html',
    directives: const [materialDirectives],
    preserveWhitespace: false
)
class StatusSelectComponent implements OnDestroy
{
  StatusSelectComponent(this.phrase);

  @override
  void ngOnDestroy()
  {
    _onStatusChangeStream.close();
  }

  void onChange(String value)
  {
    status = value;
    _onStatusChangeStream.add(value);
  }

  final PhraseService phrase;

  @Input('status')
  String status;

  @Output('statusChange')
  Stream<String> get statusChange => _onStatusChangeStream.stream;

  final List<String> options = ['active', 'frozen', 'disabled'];
  final StreamController<String> _onStatusChangeStream = new StreamController();
}
