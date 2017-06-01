// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show LowercaseDirective, UppercaseDirective, FoModalComponent, FoSelectComponent;
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/model_components/model_detail_component_base.dart';
import 'package:bokain_admin/components/status_select_component/status_select_component.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';


@Component(
    selector: 'bo-customer-details',
    templateUrl: 'customer_details_component.html',
    styleUrls: const ['customer_details_component.css'],
    directives: const [FORM_DIRECTIVES, materialDirectives, FoModalComponent, FoSelectComponent, LowercaseDirective, StatusSelectComponent, UppercaseDirective],
    providers: const [CountryService, Customer, LanguageService, SkinTypeService],
    pipes: const [PhrasePipe],
    changeDetection: ChangeDetectionStrategy.Default,
)

class CustomerDetailsComponent extends ModelDetailComponentBase
{
  CustomerDetailsComponent(this.countryService, this.customerService, this.languageService, this.skinTypeService, this.userService, FormBuilder form_builder, PhraseService phrase)
  : super(form_builder, phrase)
  {
    form = formBuilder.group(_controlsConfig);
    _updateUniqueControls();
  }

  fetchDetails() async
  {
    try
    {
      errorMessage = null;
      Map<String, String> details = await customerService.fetchDetails(customer.socialNumber);
      details.remove(details.values.where((value) => value == null || value.isEmpty));

      if (details.containsKey("firstname") && customer.firstname == null || customer.firstname.isEmpty) customer.firstname = details["firstname"];
      if (details.containsKey("lastname") && customer.lastname == null || customer.lastname.isEmpty) customer.lastname = details["lastname"];
      if (details.containsKey("care_of") && customer.careOf == null || customer.careOf.isEmpty) customer.careOf = details["care_of"];
      if (details.containsKey("street") && customer.street == null || customer.street.isEmpty) customer.street = details["street"];
      if (details.containsKey("postal_code") && customer.postalCode == null || customer.postalCode.isEmpty) customer.postalCode = details["postal_code"];
      if (details.containsKey("city") && customer.city == null || customer.city.isEmpty) customer.city = details["city"];
      if (details.containsKey("email") && customer.email == null || customer.email.isEmpty) customer.email = details["email"];
      if (details.containsKey("phone") && customer.phone == null || customer.phone.isEmpty) customer.phone = details["phone"];
    } on FormatException
    {
      errorMessage = "ssn_error_could_not_fetch";
    }
  }

  void _updateUniqueControls()
  {
    form.controls["email"] = new Control("", Validators.compose(
        [
          BoValidators.required,
          Validators.maxLength(100),
          BoValidators.unique("email", "_customer_with_this_email_already_exists", customerService, customer)
        ]));
    form.controls["phone"] = new Control("", Validators.compose(
        [
          BoValidators.required,
          BoValidators.isPhoneNumber,
          Validators.maxLength(32),
          BoValidators.unique("phone", "_customer_with_this_phone_already_exists", customerService, customer)
        ]));
    form.controls["social_number"] = new Control("", Validators.compose(
        [BoValidators.required,
        Validators.minLength(12),
        Validators.maxLength(12),
        BoValidators.isSwedishSocialSecurityNumber,
        BoValidators.unique("social_number", "_customer_with_this_social_number_already_exists", customerService, customer)
        ]));
  }

  bool get socialNumberValid => form.controls["social_number"].valid;

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

  String errorMessage;

  final Map<String, dynamic> _controlsConfig =
  {
    "firstname":[null, Validators.compose([BoValidators.required, BoValidators.isName, Validators.maxLength(64)])],
    "lastname":[null, Validators.compose([BoValidators.required, BoValidators.isName, Validators.maxLength(64)])],
    "street":[null, Validators.compose([BoValidators.required, Validators.minLength(4), Validators.maxLength(64)])],
    "postal_code":[null, Validators.compose([BoValidators.required, BoValidators.isAlphaNumeric, Validators.minLength(2), Validators.maxLength(20)])],
    "city":[null, Validators.compose([BoValidators.required, Validators.maxLength(64)])],
    "comments_internal" : [null, Validators.maxLength(8000)],
    "comments_external" : [null, Validators.maxLength(8000)],
  };

  @Input('customer')
  void set customer(Customer c)
  {
    model = c;
    _updateUniqueControls();
  }

  @Input('showComments')
  bool showComments = true;
}
