// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_models/bokain_models.dart' show SalonService, PhraseService, Salon;
import 'package:bokain_admin/components/bo_modal_component/bo_modal_component.dart';
import 'package:bokain_admin/components/model_components/salon/salon_add_component.dart';
import 'package:bokain_admin/components/model_components/salon/salon_edit_component.dart';

@Component(
    selector: 'bo-salon-list',
    styleUrls: const ['salon_list_component.css'],
    templateUrl: 'salon_list_component.html',
    directives: const [materialDirectives, BoModalComponent, DataTableComponent, SalonAddComponent, SalonEditComponent],
    preserveWhitespace: false
)

class SalonListComponent
{
  SalonListComponent(this.phrase, this.salonService);

  void onRowClick(String event)
  {
    selectedSalon = salonService.getModel(event);
    editSalonVisible = true;
  }

  Salon selectedSalon;
  bool addSalonVisible = false;
  bool editSalonVisible = false;

  final SalonService salonService;
  final PhraseService phrase;
}
