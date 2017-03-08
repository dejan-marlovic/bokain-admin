// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_admin/services/editable_model/editable_model_service.dart' show ServiceService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-service-list',
    styleUrls: const ['service_list_component.css'],
    templateUrl: 'service_list_component.html',
    directives: const [ROUTER_DIRECTIVES, materialDirectives, DataTableComponent],
    preserveWhitespace: false
)

class ServiceListComponent
{
  ServiceListComponent(this._router, this.phrase, this.service)
  {
  }

  void onRowClick(String event)
  {
    service.selectedModel = service.getModel(event);
    _router.navigate(['ServiceEdit']);
  }

  final Router _router;
  final ServiceService service;
  final PhraseService phrase;
}
