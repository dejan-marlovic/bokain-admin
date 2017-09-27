// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of edit_component_base;

@Component(
    selector: 'bo-service-addon-edit',
    styleUrls: const ['../service/service_addon/service_addon_edit_component.css'],
    templateUrl: '../service/service_addon/service_addon_edit_component.html',
    directives: const [AssociativeTableComponent, CORE_DIRECTIVES, materialDirectives, ServiceAddonDetailsComponent],
    pipes: const [PhrasePipe]
)
class ServiceAddonEditComponent extends EditComponentBase
{
  ServiceAddonEditComponent(OutputService output_service, this.serviceService, ServiceAddonService service_addon_service) : super(service_addon_service, output_service);

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

  ServiceAddonService get serviceAddonService => _service;
  ServiceAddon get serviceAddon => model;

  final ServiceService serviceService;
}
