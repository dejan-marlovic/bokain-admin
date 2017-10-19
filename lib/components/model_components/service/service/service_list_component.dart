// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of list_component_base;

@Component(
    selector: 'bo-service-list',
    styleUrls: const ['../service/service/service_list_component.css'],
    templateUrl: '../service/service/service_list_component.html',
    directives: const [CORE_DIRECTIVES, DataTableComponent, FoModalComponent, materialDirectives, ServiceAddComponent, ServiceEditComponent],
    pipes: const [PhrasePipe]
)
class ServiceListComponent extends ListComponentBase<Service>
{
  ServiceListComponent(ServiceService service) : super(service);
}
