// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show DataTableComponent;
import 'package:bokain_admin/components/bo_modal_component/bo_modal_component.dart';
import 'package:bokain_admin/components/model_components/service/service_add_component.dart';
import 'package:bokain_admin/components/model_components/service/service_edit_component.dart';
import 'package:bokain_models/bokain_models.dart' show Service;
import 'package:bokain_admin/services/model/model_service.dart' show ServiceService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-service-list',
    styleUrls: const ['service_list_component.css'],
    templateUrl: 'service_list_component.html',
    directives: const [materialDirectives, BoModalComponent, DataTableComponent, ServiceAddComponent, ServiceEditComponent],
    preserveWhitespace: false
)

class ServiceListComponent
{
  ServiceListComponent(this.phrase, this.serviceService);

  void onRowClick(String event)
  {
    selectedService = serviceService.getModel(event);
    editServiceVisible = true;
  }

  bool addServiceVisible = false;
  bool editServiceVisible = false;
  Service selectedService;
  final ServiceService serviceService;
  final PhraseService phrase;
}
