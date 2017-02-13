// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library salon_details_component;

import 'package:angular2/core.dart';
import 'package:angular2/common.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show FoValidators, LowercaseDirective, UppercaseDirective;
import 'package:bokain_models/bokain_models.dart' show Salon;
import 'package:bokain_admin/services/editable_model/editable_model_service.dart' show SalonService;
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/components/model_components/model_detail_component_base.dart';

@Component(
    selector: 'bo-salon-details',
    templateUrl: 'salon_details_component.html',
    styleUrls: const ['salon_details_component.css'],
    providers: const [],
    directives: const [FORM_DIRECTIVES, materialDirectives, LowercaseDirective, UppercaseDirective],
    viewBindings: const [FORM_BINDINGS],
    changeDetection: ChangeDetectionStrategy.OnPush,
    preserveWhitespace: false
)

class SalonDetailsComponent extends ModelDetailComponentBase
{
  SalonDetailsComponent(this.salonService, FormBuilder form_builder, PhraseService phrase) : super(salonService, form_builder, phrase)
  {
    form = formBuilder.group(_controlsConfig);
  }

  Map<String, Salon> get salonMap => salonService.modelMap;

  @Input('salon')
  void set salon(Salon s)
  {
    model = s;
  }

  Salon get salon => model;

  final SalonService salonService;
  final Map<String, dynamic> _controlsConfig =
  {
    "name":[null, Validators.compose([Validators.required, FoValidators.isName, Validators.maxLength(64)])],
    "email":[null, Validators.compose([Validators.required, Validators.maxLength(100)])],
    "phone":[null, Validators.compose([Validators.required, FoValidators.isPhoneNumber, Validators.maxLength(32)])],
    "street":[null, Validators.compose([Validators.required, Validators.minLength(4), Validators.maxLength(64)])],
    "postal_code":[null, Validators.compose([Validators.required, FoValidators.isAlphaNumeric, Validators.minLength(2), Validators.maxLength(20)])],
    "city":[null, Validators.compose([Validators.required, Validators.maxLength(64)])],
    "status" : ["active", Validators.required]
  };
}
