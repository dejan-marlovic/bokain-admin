// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart' show BoValidators, Salon, SalonService;
import 'package:bokain_admin/components/model_components/model_detail_component_base.dart';

@Component(
    selector: 'bo-salon-details',
    templateUrl: 'salon_details_component.html',
    styleUrls: const ['salon_details_component.css'],
    directives: const [CORE_DIRECTIVES, formDirectives, materialDirectives, FoImageFileComponent, LowercaseDirective, UppercaseDirective],
    pipes: const [PhrasePipe]
)

class SalonDetailsComponent extends ModelDetailComponentBase implements OnChanges
{
  SalonDetailsComponent(this.salonService) : super();

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("salon"))
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
    if (source.isEmpty && salon.logoUrls.containsKey(company))
    {
      salon.logoUrls.remove(company);
      salonService.removeImage(salon.name, company);
    }
    else salon.logoUrls[company] = await salonService.uploadImage(salon.name, company, source);

    /**
     * Save unless new salon
     */
//    if (salon.id != null) salonService.set(salon.id, salon);
  }

  Salon get salon => model;

  final SalonService salonService;

  @Input('salon')
  void set salon(Salon s) { model = s; }
}
