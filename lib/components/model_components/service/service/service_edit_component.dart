// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of edit_component_base;

@Component(
    selector: 'bo-service-edit',
    styleUrls: const ['../service/service/service_edit_component.css'],
    templateUrl: '../service/service/service_edit_component.html',
    directives: const [AssociativeTableComponent, CORE_DIRECTIVES, materialDirectives, ServiceDetailsComponent],
    pipes: const [PhrasePipe]
)

class ServiceEditComponent extends EditComponentBase
{
  ServiceEditComponent(this.addonService, OutputService output_service, ServiceService service_service) : super(service_service, output_service);

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

  ServiceService get serviceService => _service;
  Service get service => model;

  final ServiceAddonService addonService;
}
