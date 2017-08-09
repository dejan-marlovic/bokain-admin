// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent, FoModalComponent;
import 'package:bokain_models/bokain_models.dart' show PhrasePipe, Salon, SalonService;
import 'package:bokain_admin/components/model_components/salon/salon_add_component.dart';
import 'package:bokain_admin/components/model_components/salon/salon_edit_component.dart';

@Component(
    selector: 'bo-salon-list',
    styleUrls: const ['salon_list_component.css'],
    templateUrl: 'salon_list_component.html',
    directives: const [materialDirectives, DataTableComponent, FoModalComponent, SalonAddComponent, SalonEditComponent],
    pipes: const [PhrasePipe]
)

class SalonListComponent
{
  SalonListComponent(this.salonService);

  void openSalon(String event)
  {
    selectedSalon = salonService.getModel(event);
    editSalonVisible = true;
  }

  Salon selectedSalon;
  bool addSalonVisible = false;
  bool editSalonVisible = false;

  final SalonService salonService;
}
