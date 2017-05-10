// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_models/bokain_models.dart' show ServiceAddonService, PhraseService, ServiceAddon;
import 'package:bokain_admin/components/bo_modal_component/bo_modal_component.dart';
import 'package:bokain_admin/components/model_components/service_addon/service_addon_add_component.dart';
import 'package:bokain_admin/components/model_components/service_addon/service_addon_edit_component.dart';

@Component(
    selector: 'bo-service-addon-list',
    styleUrls: const ['service_addon_list_component.css'],
    templateUrl: 'service_addon_list_component.html',
    directives: const [materialDirectives, BoModalComponent, DataTableComponent, ServiceAddonAddComponent, ServiceAddonEditComponent],
    preserveWhitespace: false
)

class ServiceAddonListComponent
{
  ServiceAddonListComponent(this.phrase, this.serviceAddonService);

  void onRowClick(String event)
  {
    selectedServiceAddon = serviceAddonService.getModel(event);
    editServiceAddonVisible = true;
  }

  bool addServiceAddonVisible = false;
  bool editServiceAddonVisible = false;
  ServiceAddon selectedServiceAddon;
  final ServiceAddonService serviceAddonService;
  final PhraseService phrase;
}
