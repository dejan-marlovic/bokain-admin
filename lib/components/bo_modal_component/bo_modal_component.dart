// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Stream, StreamController;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';


@Component(
    selector: 'bo-modal',
    styleUrls: const ['bo_modal_component.css'],
    templateUrl: 'bo_modal_component.html',
    directives: const [materialDirectives],
    preserveWhitespace: false
)
class BoModalComponent
{
  BoModalComponent();

  void close()
  {
    visible = false;
    onIsVisibleController.add(false);
  }

  @Input('visible')
  bool visible = false;

  @Input('title')
  String title = "";

  @Output('visibleChange')
  Stream<bool> get isVisible => onIsVisibleController.stream;


  final StreamController<bool> onIsVisibleController = new StreamController();
}
