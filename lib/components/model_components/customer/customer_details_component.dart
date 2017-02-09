// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library customer_details_component;

import 'package:angular2/core.dart';
import 'package:angular2/common.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show FoValidators, LowercaseDirective, UppercaseDirective;
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/services/editable_model/editable_model_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-customer-details',
    templateUrl: 'customer_details_component.html',
    styleUrls: const ['customer_details_component.css'],
    providers: const [],
    directives: const [FORM_DIRECTIVES, materialDirectives, LowercaseDirective, UppercaseDirective],
    viewBindings: const [FORM_BINDINGS],
    changeDetection: ChangeDetectionStrategy.OnPush,
    preserveWhitespace: false
)

class CustomerDetailsComponent
{
  CustomerDetailsComponent(this.phrase, this._userService, this.customerService, this._formBuilder)
  {
    form = _formBuilder.group(_controlsConfig);
  }

  void validateUniqueField(String input_name)
  {
    Iterable<Customer> matches = customerService.findByProperty(input_name, form.controls[input_name].value);
    if (matches.length > 1 || (matches.length == 1 && matches.first != customer))
    {
      form.controls[input_name].setErrors({"material-input-error" : phrase.get(["_unique_database_value_exists"])});
    }
  }

  Map<String, User> get userMap => _userService.modelMap;

  @Input('customer')
  Customer customer;

  ControlGroup form;
  final FormBuilder _formBuilder;
  final UserService _userService;
  final CustomerService customerService;
  final PhraseService phrase;

  static final Map<String, dynamic> _controlsConfig =
  {
    "email":[null, Validators.compose([Validators.required, Validators.maxLength(100)])],
    "phone":[null, Validators.compose([Validators.required, FoValidators.isPhoneNumber, Validators.maxLength(32)])],
    "social_number":[null, Validators.compose([Validators.required, Validators.minLength(12), Validators.maxLength(12), FoValidators.isNumeric])],
    "firstname":[null, Validators.compose([Validators.required, FoValidators.isName, Validators.maxLength(64)])],
    "lastname":[null, Validators.compose([Validators.required, FoValidators.isName, Validators.maxLength(64)])],
    "street":[null, Validators.compose([Validators.required, Validators.minLength(4), Validators.maxLength(64)])],
    "postal_code":[null, Validators.compose([Validators.required, FoValidators.isAlphaNumeric, Validators.minLength(2), Validators.maxLength(20)])],
    "city":[null, Validators.compose([Validators.required, Validators.maxLength(64)])],
    "comments_internal" : [null, Validators.maxLength(8000)],
    "comments_external" : [null, Validators.maxLength(8000)],
    "country" : ["sv", Validators.required],
    "skin_type" : ["acne", Validators.required],
    "belongs_to" : [null, Validators.required],
    "status" : ["active", Validators.required],
    "language" : ["sv", Validators.required],
    "send_email" : [true]
  };
}
