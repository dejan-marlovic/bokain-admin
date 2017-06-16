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
    directives: const
    [
      FORM_DIRECTIVES,
      materialDirectives,
      FoModalComponent,
      FoSelectComponent,
      LowercaseDirective,
      StatusSelectComponent,
      UppercaseDirective
    ],
    pipes: const [PhrasePipe]
)

class CustomerDetailsComponent extends ModelDetailComponentBase implements OnChanges
{
  CustomerDetailsComponent(
      FormBuilder form_builder,
      this.countryService,
      this.customerService,
      this.languageService,
      this.skinTypeService,
      this.userService)
  : super();

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("customer"))
    {
      form = new ControlGroup(
      {
        "firstname" : new Control(customer.firstname,
            Validators.compose([BoValidators.required, BoValidators.isName, Validators.maxLength(64)])),
        "lastname" : new Control(customer.lastname,
            Validators.compose([BoValidators.required, BoValidators.isName, Validators.maxLength(64)])),
        "street" : new Control(customer.street,
            Validators.compose([BoValidators.required, Validators.minLength(4), Validators.maxLength(64)])),
        "care_of" : new Control(customer.careOf, null),
        "postal_code" : new Control(customer.postalCode,
            Validators.compose([BoValidators.required, BoValidators.isAlphaNumeric, Validators.minLength(2), Validators.maxLength(20)])),
        "city" : new Control(customer.city,
            Validators.compose([BoValidators.required, Validators.maxLength(64)])),
        "comments_internal" : new Control(customer.commentsInternal,
            Validators.maxLength(8000)),
        "comments_external" : new Control(customer.commentsExternal,
            Validators.maxLength(8000)),
        "email" : new Control(customer.email,
            Validators.compose([BoValidators.required, Validators.maxLength(100),
            BoValidators.unique("email", "_customer_with_this_email_already_exists", customerService, customer)])),
        "phone" : new Control(customer.phone,
            Validators.compose([BoValidators.required, BoValidators.isPhoneNumber, Validators.maxLength(32),
            BoValidators.unique("phone", "_customer_with_this_phone_already_exists", customerService, customer)])),
        "social_number" : new Control(customer.socialNumber,
            Validators.compose([BoValidators.required, Validators.minLength(12), Validators.maxLength(12),
            BoValidators.isSwedishSocialSecurityNumber,
            BoValidators.unique("social_number", "_customer_with_this_social_number_already_exists", customerService, customer)]))
      });
    }
  }

  fetchDetails() async
  {
    try
    {
      errorMessage = null;
      Map<String, String> details = await customerService.fetchDetails(customer.socialNumber);
      details.remove(details.values.where((value) => value == null || value.isEmpty));

      details.forEach((property, value)
      {
        if (value != null && value.isNotEmpty) customer.data[property] = value;
      });

    } on FormatException
    {
      errorMessage = "ssn_error_could_not_fetch";
    }
  }

  Customer get customer => model;

  String errorMessage;
  final CountryService countryService;
  final CustomerService customerService;
  final LanguageService languageService;
  final SkinTypeService skinTypeService;
  final UserService userService;

  @Input('customer')
  void set customer(Customer c) { model = c; }

  @Input('showComments')
  bool showComments = true;
}
