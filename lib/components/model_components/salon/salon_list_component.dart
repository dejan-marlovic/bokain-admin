// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_admin/services/editable_model/editable_model_service.dart' show SalonService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-salon-list',
    styleUrls: const ['salon_list_component.css'],
    templateUrl: 'salon_list_component.html',
    directives: const [ROUTER_DIRECTIVES, materialDirectives, DataTableComponent],
    preserveWhitespace: false
)

class SalonListComponent
{
  SalonListComponent(this._router, this.phrase, this.salonService)
  {
  }

  void onRowClick(String event)
  {
    salonService.selectedModel = salonService.getModel(event);
    _router.navigate(['SalonEdit']);
  }

  final Router _router;
  final SalonService salonService;
  final PhraseService phrase;
}