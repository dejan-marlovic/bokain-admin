// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_admin/services/model/model_service.dart' show ServiceAddonService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-service-addon-list',
    styleUrls: const ['service_addon_list_component.css'],
    templateUrl: 'service_addon_list_component.html',
    directives: const [ROUTER_DIRECTIVES, materialDirectives, DataTableComponent],
    preserveWhitespace: false
)

class ServiceAddonListComponent
{
  ServiceAddonListComponent(this._router, this.phrase, this.service)
  {
  }

  void onRowClick(String event)
  {
    service.selectedModel = service.getModel(event);
    _router.navigate(['ServiceAddonEdit']);
  }

  final Router _router;
  final ServiceAddonService service;
  final PhraseService phrase;
}
