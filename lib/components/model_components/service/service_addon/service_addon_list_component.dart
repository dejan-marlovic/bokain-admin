// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of list_component_base;

@Component(
    selector: 'bo-service-addon-list',
    styleUrls: const ['../service/service_addon/service_addon_list_component.css'],
    templateUrl: '../service/service_addon/service_addon_list_component.html',
    directives: const [CORE_DIRECTIVES, DataTableComponent, FoModalComponent, materialDirectives, ServiceAddonAddComponent, ServiceAddonEditComponent],
    pipes: const [PhrasePipe]
)
class ServiceAddonListComponent extends ListComponentBase
{
  ServiceAddonListComponent(ServiceAddonService service) : super(service);
}
