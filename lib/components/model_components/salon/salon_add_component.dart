// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of add_component_base;

@Component(
    selector: 'bo-salon-add',
    styleUrls: const ['../salon/salon_add_component.css'],
    templateUrl: '../salon/salon_add_component.html',
    directives: const [CORE_DIRECTIVES, SalonDetailsComponent, materialDirectives],
    pipes: const [PhrasePipe],
)
class SalonAddComponent extends AddComponentBase<Salon>
{
  SalonAddComponent(SalonService salon_service, OutputService output_service) : super(salon_service, output_service);

  Salon get salon => model;
  SalonService get salonService => _service;
}
