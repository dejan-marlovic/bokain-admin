// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of list_component_base;

@Component(
    selector: 'bo-salon-list',
    styleUrls: const ['../salon/salon_list_component.css'],
    templateUrl: '../salon/salon_list_component.html',
    directives: const [CORE_DIRECTIVES, DataTableComponent, FoModalComponent, materialDirectives, SalonAddComponent, SalonEditComponent],
    pipes: const [PhrasePipe]
)
class SalonListComponent extends ListComponentBase<Salon>
{
  SalonListComponent(SalonService service) : super(service);
}
