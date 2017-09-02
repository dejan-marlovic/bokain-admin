// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/model_components/service/service_add_component.dart';
import 'package:bokain_admin/components/model_components/service/service_edit_component.dart';

@Component(
    selector: 'bo-service-list',
    styleUrls: const ['service_list_component.css'],
    templateUrl: 'service_list_component.html',
    directives: const [CORE_DIRECTIVES, DataTableComponent, FoModalComponent, materialDirectives, ServiceAddComponent, ServiceEditComponent],
    pipes: const [PhrasePipe]
)

class ServiceListComponent
{
  ServiceListComponent(this.serviceService);

  void openService(String event)
  {
    selectedService = serviceService.get(event);
    editServiceVisible = true;
  }

  bool addServiceVisible = false;
  bool editServiceVisible = false;
  Service selectedService;
  final ServiceService serviceService;
}
