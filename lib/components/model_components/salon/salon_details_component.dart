// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart' show BoValidators, Salon, SalonService;
import 'package:bokain_admin/components/model_components/model_detail_component_base.dart';

@Component(
    selector: 'bo-salon-details',
    templateUrl: 'salon_details_component.html',
    styleUrls: const ['salon_details_component.css'],
    directives: const [FORM_DIRECTIVES, materialDirectives, FoImageFileComponent, LowercaseDirective, UppercaseDirective],
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
          BoValidators.required,
          BoValidators.isName,
          Validators.maxLength(64),
          BoValidators.unique("name", "_salon_with_this_name_already_exists", salonService, salon)
        ])),
        "email" : new Control(salon.email, Validators.compose([BoValidators.required, Validators.maxLength(100)])),
        "phone" : new Control(salon.phone, Validators.compose([BoValidators.required, BoValidators.isPhoneNumber, Validators.maxLength(32)])),
        "street" : new Control(salon.street, Validators.compose([BoValidators.required, Validators.minLength(4), Validators.maxLength(64)])),
        "postal_code" : new Control(salon.postalCode, Validators.compose([BoValidators.required, BoValidators.isAlphaNumeric, Validators.minLength(2), Validators.maxLength(20)])),
        "city" : new Control(salon.city, Validators.compose([BoValidators.required, Validators.maxLength(64)]))
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
