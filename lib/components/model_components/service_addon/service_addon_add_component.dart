// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show ServiceAddon;
import 'package:bokain_admin/components/model_components/service_addon/service_addon_details_component.dart';
import 'package:bokain_admin/services/model/model_service.dart' show ServiceAddonService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-service-addon-add',
    styleUrls: const ['service_addon_add_component.css'],
    templateUrl: 'service_addon_add_component.html',
    directives: const [materialDirectives, ServiceAddonDetailsComponent],
    preserveWhitespace: false
)
class ServiceAddonAddComponent
{
  ServiceAddonAddComponent(this.service, this.phrase, this._router)
  {
    service.selectedModelId = null;
    model = new ServiceAddon.empty();
    model.status = "active";
  }

  Future pushIfValid() async
  {
    await service.push(model);
    _router.navigate(['ServiceAddonList']);
  }

  ServiceAddon model;
  final ServiceAddonService service;
  final PhraseService phrase;
  final Router _router;
}
