// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show LowercaseDirective, UppercaseDirective, FoSelectComponent;
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/model_components/model_detail_component_base.dart';
import 'package:bokain_admin/components/status_select_component/status_select_component.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';


@Component(
    selector: 'bo-customer-details',
    templateUrl: 'customer_details_component.html',
    styleUrls: const ['customer_details_component.css'],
    directives: const [FORM_DIRECTIVES, materialDirectives, FoSelectComponent, LowercaseDirective, StatusSelectComponent, UppercaseDirective],
    providers: const [CountryService, Customer, LanguageService, SkinTypeService],
    pipes: const [PhrasePipe],
    changeDetection: ChangeDetectionStrategy.OnPush,
)

class CustomerDetailsComponent extends ModelDetailComponentBase
{
  CustomerDetailsComponent(this.countryService, this.customerService, this.languageService, this.skinTypeService, this.userService, FormBuilder form_builder, PhraseService phrase)
  : super(form_builder, phrase)
  {
    BoValidators.service = customerService;
    form = formBuilder.group(_controlsConfig);
  }

  @Input('customer')
  void set customer(Customer c)
  {
    model = c;
    BoValidators.currentModelId = c?.id;
  }

  @Input('showComments')
  bool showComments = true;

  Customer get customer => model;

  Country get selectedCountry => countryService.getModel(customer.country);
  Language get selectedLanguage => languageService.getModel(customer.language);
  SkinType get selectedSkinType => skinTypeService.getModel(customer.skinType);
  User get selectedUser => userService.getModel(customer.belongsTo);

  void set selectedCountry(Country value) { customer.country = value?.id; }
  void set selectedLanguage(Language value) { customer.language = value?.id; }
  void set selectedSkinType(SkinType value) { customer.skinType = value?.id; }
  void set selectedUser(User value) { customer.belongsTo = value?.id; }

  final CountryService countryService;
  final CustomerService customerService;
  final LanguageService languageService;
  final SkinTypeService skinTypeService;
  final UserService userService;

  final Map<String, dynamic> _controlsConfig =
  {
    "email":[null, Validators.compose([BoValidators.required, Validators.maxLength(100), BoValidators.unique("email", "_customer_with_this_email_already_exists")])],
    "phone":[null, Validators.compose([BoValidators.required, BoValidators.isPhoneNumber, Validators.maxLength(32), BoValidators.unique("phone", "_customer_with_this_phone_already_exists")])],
    "social_number":[null, Validators.compose([BoValidators.required, Validators.minLength(12), Validators.maxLength(12), BoValidators.isSwedishSocialSecurityNumber, BoValidators.unique("social_number", "_customer_with_this_social_number_already_exists")])],
    "firstname":[null, Validators.compose([BoValidators.required, BoValidators.isName, Validators.maxLength(64)])],
    "lastname":[null, Validators.compose([BoValidators.required, BoValidators.isName, Validators.maxLength(64)])],
    "street":[null, Validators.compose([BoValidators.required, Validators.minLength(4), Validators.maxLength(64)])],
    "postal_code":[null, Validators.compose([BoValidators.required, BoValidators.isAlphaNumeric, Validators.minLength(2), Validators.maxLength(20)])],
    "city":[null, Validators.compose([BoValidators.required, Validators.maxLength(64)])],
    "comments_internal" : [null, Validators.maxLength(8000)],
    "comments_external" : [null, Validators.maxLength(8000)],
    "send_email" : [true]
  };
}
