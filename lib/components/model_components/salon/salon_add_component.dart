// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
library salon_add_component;

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show Salon;
import 'package:bokain_admin/components/model_components/salon/salon_details_component.dart';
import 'package:bokain_admin/services/editable_model/editable_model_service.dart' show SalonService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-salon-add',
    styleUrls: const ['salon_add_component.css'],
    templateUrl: 'salon_add_component.html',
    directives: const [materialDirectives, SalonDetailsComponent],
    preserveWhitespace: false
)
class SalonAddComponent
{
  SalonAddComponent(this.salonService, this.phrase, this._router)
  {
    salonService.selectedModelId = null;
    salon = new Salon();
    salon.status = "active";
  }

  Future pushIfValid() async
  {
    await salonService.push(salon);
    _router.navigate(['SalonList']);
  }

  Salon salon;
  final SalonService salonService;
  final PhraseService phrase;
  final Router _router;


}
