// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of details_component_base;

@Component(
    selector: 'bo-service-details',
    templateUrl: '../service/service/service_details_component.html',
    styleUrls: const ['../service/service/service_details_component.css'],
    directives: const [CORE_DIRECTIVES, dColorPickerComponent, formDirectives, materialDirectives, NgIf, LowercaseDirective, StatusSelectComponent, UppercaseDirective],
    pipes: const [PhrasePipe],
    changeDetection: ChangeDetectionStrategy.OnPush
)

class ServiceDetailsComponent extends DetailsComponentBase implements OnChanges
{
  ServiceDetailsComponent(ServiceService service_service) : super(service_service);

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("model"))
    {
      final FormBuilder formBuilder = new FormBuilder();
      form = formBuilder.group({
          "name" :
          [
            service.name,
            Validators.compose(
                [
                  FoValidators.required("enter_a_name"),
                  FoValidators.alphaNumeric,
                  Validators.maxLength(64),
                  BoValidators.unique("name", "salon_with_this_name_already_exists", serviceService, service)
                ])
          ],
          "category" : [service.category, Validators.compose([FoValidators.required("enter_a_category"), Validators.maxLength(64)])],
          "description" : [service.description, Validators.maxLength(600)],
          "duration" : [service.durationMinutesStr, Validators.compose([FoValidators.required("enter_a_duration"), FoValidators.numeric])],
          "after_margin" : [service.afterMarginMinutesStr, Validators.compose([FoValidators.required("enter_a_margin"), FoValidators.numeric])],
          "price" : [service.priceStr, Validators.compose([FoValidators.required("enter_a_price"), FoValidators.numeric])]
        });
    }
  }

  Service get service => model;
  ServiceService get serviceService => _service;

}
