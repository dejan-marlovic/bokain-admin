// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future, Stream, StreamController;
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/model_components/service/service_details_component.dart';
import 'package:bokain_admin/components/associative_table_component/associative_table_component.dart';

@Component(
    selector: 'bo-service-edit',
    styleUrls: const ['service_edit_component.css'],
    templateUrl: 'service_edit_component.html',
    directives: const [AssociativeTableComponent, CORE_DIRECTIVES, materialDirectives, ServiceDetailsComponent],
    pipes: const [PhrasePipe]
)

class ServiceEditComponent implements OnDestroy
{
  ServiceEditComponent(this.serviceService, this.addonService);

  void ngOnDestroy()
  {
    _onSaveController.close();
  }

  Future save() async
  {
    await serviceService.set(service.id, service);
    _onSaveController.add(service.id);
  }

  Future cancel() async
  {
    service = await serviceService.fetch(service?.id, force: true);
    serviceService.streamedModels[service.id] = service;
  }

  Future addServiceAddon(String id) async
  {
    if (!service.serviceAddonIds.contains(id))
    {
      service.serviceAddonIds.add(id);
      await serviceService.patchServiceAddons(service);
    }

    ServiceAddon addon = addonService.get(id);
    if (addon != null && !addon.serviceIds.contains(service.id))
    {
      addon.serviceIds.add(service.id);
      await addonService.patchServices(addon);
    }
  }

  Future removeServiceAddon(String id) async
  {
    service.serviceAddonIds.remove(id);
    await serviceService.patchServiceAddons(service);

    ServiceAddon addon = addonService.get(id);
    if (addon != null)
    {
      addon.serviceIds.remove(service.id);
      await addonService.patchServices(addon);
    }
  }

  final ServiceService serviceService;
  final ServiceAddonService addonService;
  final StreamController<String> _onSaveController = new StreamController();

  @Input('model')
  Service service;

  @Output('save')
  Stream<String> get onSave => _onSaveController.stream;
}
