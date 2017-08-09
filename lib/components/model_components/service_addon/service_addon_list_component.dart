// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent, FoModalComponent;
import 'package:bokain_models/bokain_models.dart' show PhrasePipe, ServiceAddon, ServiceAddonService;
import 'package:bokain_admin/components/model_components/service_addon/service_addon_add_component.dart';
import 'package:bokain_admin/components/model_components/service_addon/service_addon_edit_component.dart';

@Component(
    selector: 'bo-service-addon-list',
    styleUrls: const ['service_addon_list_component.css'],
    templateUrl: 'service_addon_list_component.html',
    directives: const [materialDirectives, DataTableComponent, FoModalComponent, ServiceAddonAddComponent, ServiceAddonEditComponent],
    pipes: const [PhrasePipe]
)

class ServiceAddonListComponent
{
  ServiceAddonListComponent(this.serviceAddonService);

  void openServiceAddon(String event)
  {
    selectedServiceAddon = serviceAddonService.getModel(event);
    editServiceAddonVisible = true;
  }

  bool addServiceAddonVisible = false;
  bool editServiceAddonVisible = false;
  ServiceAddon selectedServiceAddon;
  final ServiceAddonService serviceAddonService;
}
