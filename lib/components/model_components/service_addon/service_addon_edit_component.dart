// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/associative_table_component/associative_table_component.dart';
import 'package:bokain_admin/components/model_components/service_addon/service_addon_details_component.dart';

@Component(
    selector: 'bo-service-addon-edit',
    styleUrls: const ['service_addon_edit_component.css'],
    templateUrl: 'service_addon_edit_component.html',
    directives: const [AssociativeTableComponent, CORE_DIRECTIVES, materialDirectives, ServiceAddonDetailsComponent],
    pipes: const [PhrasePipe]
)

class ServiceAddonEditComponent implements OnDestroy
{
  ServiceAddonEditComponent(this.serviceService, this.serviceAddonService);

  void ngOnDestroy()
  {
    _onSaveController.close();
  }

  Future save() async
  {
    await serviceAddonService.set(serviceAddon.id, serviceAddon);
    _onSaveController.add(serviceAddon.id);
  }

  Future cancel() async
  {
    serviceAddon = await serviceAddonService.fetch(serviceAddon?.id, force: true);
    serviceAddonService.streamedModels[serviceAddon.id] = serviceAddon;
  }

  Future addService(String id) async
  {
    if (!serviceAddon.serviceIds.contains(id))
    {
      serviceAddon.serviceIds.add(id);
      await serviceAddonService.patchServices(serviceAddon);
    }

    Service service = serviceService.get(id);
    if (service != null && !service.serviceAddonIds.contains(serviceAddon.id))
    {
      service.serviceAddonIds.add(serviceAddon.id);
      await serviceService.patchServiceAddons(service);
    }
  }

  Future removeService(String id) async
  {
    serviceAddon.serviceIds.remove(id);
    await serviceAddonService.patchServices(serviceAddon);

    Service service = serviceService.get(id);
    if (service != null)
    {
      service.serviceAddonIds.remove(serviceAddon.id);
      await serviceService.patchServiceAddons(service);
    }
  }

  final ServiceService serviceService;
  final ServiceAddonService serviceAddonService;
  final StreamController<String> _onSaveController = new StreamController();

  @Input('serviceAddon')
  ServiceAddon serviceAddon;

  @Output('save')
  Stream<String> get onSaveOutput => _onSaveController.stream;
}
