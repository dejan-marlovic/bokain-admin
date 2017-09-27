// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of details_component_base;

@Component(
    selector: 'bo-service-addon-details',
    templateUrl: '../service/service_addon/service_addon_details_component.html',
    styleUrls: const ['../service/service_addon/service_addon_details_component.css'],
    directives: const [CORE_DIRECTIVES, formDirectives, materialDirectives, materialNumberInputDirectives, LowercaseDirective, StatusSelectComponent, UppercaseDirective],
    pipes: const [PhrasePipe]
)
class ServiceAddonDetailsComponent extends DetailsComponentBase implements OnChanges
{
  ServiceAddonDetailsComponent(ServiceAddonService service) : super(service);

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("model"))
    {
      form = new ControlGroup(
      {
        "name" : new Control(serviceAddon.name,
        Validators.compose(
          [
            FoValidators.required("enter_a_name"),
            Validators.maxLength(64),
            BoValidators.unique("name", "service_addon_with_this_name_already_exists", serviceAddonService, serviceAddon)
          ])),
        "description" : new Control(serviceAddon.description, Validators.compose([Validators.maxLength(600)])),
        "duration_minutes" : new Control(serviceAddon.durationMinutesStr, Validators.compose(
            [FoValidators.required("enter_a_duration"), FoValidators.numeric])),
        "price" : new Control(serviceAddon.priceStr, Validators.compose(
            [FoValidators.required("enter_a_price"), FoValidators.numeric]))
      });
    }
  }

  ServiceAddon get serviceAddon => model;
  ServiceAddonService get serviceAddonService => _service;
}
