// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show LowercaseDirective;
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/model_components/model_detail_component_base.dart';
import 'package:bokain_admin/components/status_select_component/status_select_component.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';

@Component(
    selector: 'bo-user-details',
    templateUrl: 'user_details_component.html',
    styleUrls: const ['user_details_component.css'],
    directives: const [FORM_DIRECTIVES, materialDirectives, LowercaseDirective, StatusSelectComponent],
    providers: const [CountryService, LanguageService],
    pipes: const [PhrasePipe]
)

class UserDetailsComponent extends ModelDetailComponentBase
{
  UserDetailsComponent(this.countryService, this.userService, FormBuilder form_builder, PhraseService phrase) : super(form_builder, phrase)
  {
    form = formBuilder.group(_controlsConfig);
    _updateUniqueControls();
  }

  @Input('user')
  void set user(User usr)
  {
    model = usr;
    _updateUniqueControls();
  }
  
  User get user => model;
  Country get selectedCountry => countryService.getModel(user.country);

  void set selectedCountry(Country value) { user.country = value?.id; }

  void _updateUniqueControls()
  {
    form.controls["email"] = new Control("", Validators.compose(
        [
          BoValidators.required,
          Validators.maxLength(100),
          BoValidators.unique("email", "_user_with_this_email_already_exists", userService, user)
        ]));
    form.controls["phone"] = new Control("", Validators.compose(
        [
          BoValidators.required,
          BoValidators.isPhoneNumber,
          Validators.maxLength(32),
          BoValidators.unique("phone", "_user_with_this_phone_already_exists", userService, user)
        ]));
    form.controls["social_number"] = new Control("", Validators.compose(
        [
          BoValidators.required,
          Validators.minLength(12),
          Validators.maxLength(12),
          BoValidators.isSwedishSocialSecurityNumber,
          BoValidators.unique("social_number", "_user_with_this_social_number_already_exists", userService, user)
        ]));
  }

  final CountryService countryService;
  final UserService userService;
  final Map<String, dynamic> _controlsConfig =
  {
    "city" : [null, Validators.compose([BoValidators.required, Validators.maxLength(64)])],
    "country" : ["sv", Validators.required],
    "firstname" : [null, Validators.compose([BoValidators.required, BoValidators.isName, Validators.maxLength(64)])],
    "lastname" : [null, Validators.compose([BoValidators.required, BoValidators.isName, Validators.maxLength(64)])],
    "postal_code" : [null, Validators.compose([BoValidators.required, BoValidators.isAlphaNumeric, Validators.minLength(2), Validators.maxLength(20)])],
    "street" : [null, Validators.compose([BoValidators.required, Validators.minLength(4), Validators.maxLength(64)])],
    "password" : [null, Validators.compose([BoValidators.required, Validators.minLength(6), Validators.maxLength(64)])],
    "booking_rank" : ["0", Validators.compose([BoValidators.required, BoValidators.isNumeric])]
  };
}
