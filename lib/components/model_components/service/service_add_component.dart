// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library service_add_component;

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Service;
import 'package:bokain_admin/components/model_components/service/service_details_component.dart';
import 'package:bokain_admin/services/model/model_service.dart' show ServiceService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-service-add',
    styleUrls: const ['service_add_component.css'],
    templateUrl: 'service_add_component.html',
    directives: const [materialDirectives, ServiceDetailsComponent],
    preserveWhitespace: false
)
class ServiceAddComponent
{
  ServiceAddComponent(this.service, this.phrase, this._router)
  {
    service.selectedModelId = null;
    model = new Service();
    model.status = "active";
  }

  Future pushIfValid() async
  {
    await service.push(model);
    _router.navigate(['ServiceList']);
  }

  Service model;
  final ServiceService service;
  final PhraseService phrase;
  final Router _router;


}
