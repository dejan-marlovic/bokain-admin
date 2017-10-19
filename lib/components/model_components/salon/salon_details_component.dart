// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of details_component_base;

@Component(
    selector: 'bo-salon-details',
    templateUrl: '../salon/salon_details_component.html',
    styleUrls: const ['../salon/salon_details_component.css'],
    directives: const [CORE_DIRECTIVES, formDirectives, materialDirectives, FoImageFileComponent, LowercaseDirective, StatusSelectComponent, UppercaseDirective],
    pipes: const [PhrasePipe]
)

class SalonDetailsComponent extends DetailsComponentBase<Salon> implements OnChanges
{
  SalonDetailsComponent(SalonService salon_service) : super(salon_service);

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("model"))
    {
      form = new ControlGroup(
      {
        "name" : new Control(salon.name,
        Validators.compose(
        [
          FoValidators.required("enter_a_name"),
          FoValidators.alpha,
          Validators.maxLength(64),
          BoValidators.unique("name", "salon_with_this_name_already_exists", salonService, salon)
        ])),
        "email" : new Control(salon.email, Validators.compose([FoValidators.required("enter_an_email"), Validators.maxLength(100)])),
        "phone" : new Control(salon.phone, Validators.compose([FoValidators.required("enter_a_phone"), FoValidators.phoneNumber, Validators.maxLength(32)])),
        "street" : new Control(salon.street, Validators.compose([FoValidators.required("enter_a_street"), Validators.minLength(4), Validators.maxLength(64)])),
        "postal_code" : new Control(salon.postalCode, Validators.compose([FoValidators.required("enter_a_postal_code"), FoValidators.alphaNumeric, Validators.minLength(2), Validators.maxLength(20)])),
        "city" : new Control(salon.city, Validators.compose([FoValidators.required("enter_a_city"), Validators.maxLength(64)]))
      });
    }
  }

  /**
   * Company can be either 'as' or 'ssc'
   */
  Future onLogoSourceChange(String source, String company) async
  {
    if (source.isEmpty && salon.logoUrls.containsKey(company)) salon.logoUrls.remove(company);
    else salon.logoUrls[company] = await salonService.uploadImage(salon.name, company, source);
  }

  Salon get salon => model;
  SalonService get salonService => _service;
}
