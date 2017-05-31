// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show LowercaseDirective, UppercaseDirective;
import 'package:bokain_models/bokain_models.dart' show BoValidators, SalonService, PhraseService, Salon;
import 'package:bokain_admin/components/model_components/model_detail_component_base.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';

@Component(
    selector: 'bo-salon-details',
    templateUrl: 'salon_details_component.html',
    styleUrls: const ['salon_details_component.css'],
    directives: const [FORM_DIRECTIVES, materialDirectives, LowercaseDirective, UppercaseDirective],
    pipes: const [PhrasePipe],
    changeDetection: ChangeDetectionStrategy.OnPush,
)

class SalonDetailsComponent extends ModelDetailComponentBase
{
  SalonDetailsComponent(this.salonService, FormBuilder form_builder, PhraseService phrase) : super(form_builder, phrase)
  {
    form = formBuilder.group(_controlsConfig);
    _updateUniqueControls();
  }

  void _updateUniqueControls()
  {
    form.controls["name"] = new Control("", Validators.compose(
        [
          BoValidators.required,
          BoValidators.isName,
          Validators.maxLength(64),
          BoValidators.unique("name", "_salon_with_this_name_already_exists", salonService, salon)
        ]));
  }

  Salon get salon => model;

  final SalonService salonService;
  final Map<String, dynamic> _controlsConfig =
  {
    "email":[null, Validators.compose([BoValidators.required, Validators.maxLength(100)])],
    "phone":[null, Validators.compose([BoValidators.required, BoValidators.isPhoneNumber, Validators.maxLength(32)])],
    "street":[null, Validators.compose([BoValidators.required, Validators.minLength(4), Validators.maxLength(64)])],
    "postal_code":[null, Validators.compose([BoValidators.required, BoValidators.isAlphaNumeric, Validators.minLength(2), Validators.maxLength(20)])],
    "city":[null, Validators.compose([BoValidators.required, Validators.maxLength(64)])],
    "status" : ["active", Validators.required]
  };

  @Input('salon')
  void set salon(Salon s)
  {
    model = s;
    _updateUniqueControls();
  }
}
