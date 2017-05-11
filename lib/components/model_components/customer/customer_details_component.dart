// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show LowercaseDirective, UppercaseDirective;
import 'package:bokain_models/bokain_models.dart' show BoValidators, PhraseService, UserService, CustomerService, Customer;
import 'package:bokain_admin/components/model_components/model_detail_component_base.dart';
import 'package:bokain_admin/components/status_select_component/status_select_component.dart';


@Component(
    selector: 'bo-customer-details',
    templateUrl: 'customer_details_component.html',
    styleUrls: const ['customer_details_component.css'],
    directives: const [FORM_DIRECTIVES, materialDirectives, LowercaseDirective, StatusSelectComponent, UppercaseDirective],
    providers: const [],
    changeDetection: ChangeDetectionStrategy.OnPush,
    preserveWhitespace: false
)

class CustomerDetailsComponent extends ModelDetailComponentBase
{
  CustomerDetailsComponent(this.userService, this.customerService, FormBuilder form_builder, PhraseService phrase)
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

  final UserService userService;
  final CustomerService customerService;

  final Map<String, dynamic> _controlsConfig =
  {
    "email":[null, Validators.compose([Validators.required, Validators.maxLength(100), BoValidators.unique("email", "_customer_with_this_email_already_exists")])],
    "phone":[null, Validators.compose([Validators.required, BoValidators.isPhoneNumber, Validators.maxLength(32), BoValidators.unique("phone", "_customer_with_this_phone_already_exists")])],
    "social_number":[null, Validators.compose([Validators.required, Validators.minLength(12), Validators.maxLength(12), BoValidators.isSwedishSocialSecurityNumber, BoValidators.unique("social_number", "_customer_with_this_social_number_already_exists")])],
    "firstname":[null, Validators.compose([Validators.required, BoValidators.isName, Validators.maxLength(64)])],
    "lastname":[null, Validators.compose([Validators.required, BoValidators.isName, Validators.maxLength(64)])],
    "street":[null, Validators.compose([Validators.required, Validators.minLength(4), Validators.maxLength(64)])],
    "postal_code":[null, Validators.compose([Validators.required, BoValidators.isAlphaNumeric, Validators.minLength(2), Validators.maxLength(20)])],
    "city":[null, Validators.compose([Validators.required, Validators.maxLength(64)])],
    "comments_internal" : [null, Validators.maxLength(8000)],
    "comments_external" : [null, Validators.maxLength(8000)],
    "country" : ["sv", Validators.required],
    "skin_type" : ["acne", Validators.required],
    "belongs_to" : [null],
    "language" : ["sv", Validators.required],
    "send_email" : [true]
  };
}
