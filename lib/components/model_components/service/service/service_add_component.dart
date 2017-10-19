// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of add_component_base;

@Component(
    selector: 'bo-service-add',
    styleUrls: const ['../service/service/service_add_component.css'],
    templateUrl: '../service/service/service_add_component.html',
    directives: const [CORE_DIRECTIVES, materialDirectives, ServiceDetailsComponent],
    pipes: const [PhrasePipe]
)
class ServiceAddComponent extends AddComponentBase<Service>
{
  ServiceAddComponent(OutputService output_service, ServiceService service_service) : super(service_service, output_service);

  Service get service => model;
  ServiceService get serviceService => _service;
}
