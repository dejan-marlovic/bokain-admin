// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of add_component_base;

@Component(
    selector: 'bo-service-addon-add',
    styleUrls: const ['../service/service_addon/service_addon_add_component.css'],
    templateUrl: '../service/service_addon/service_addon_add_component.html',
    directives: const [CORE_DIRECTIVES, materialDirectives, ServiceAddonDetailsComponent],
    pipes : const [PhrasePipe]
)
class ServiceAddonAddComponent extends AddComponentBase
{
  ServiceAddonAddComponent(OutputService output_service, ServiceAddonService service_addon_service) : super(service_addon_service, output_service);

  ServiceAddon get serviceAddon => model;

  ServiceAddonService get serviceAddonService => _service;
}
