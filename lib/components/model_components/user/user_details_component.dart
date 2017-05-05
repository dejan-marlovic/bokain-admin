// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show LowercaseDirective, UppercaseDirective;
import 'package:bokain_models/bokain_models.dart' show BoValidators, UserService, PhraseService, User;
import 'package:bokain_admin/components/model_components/model_detail_component_base.dart';

@Component(
    selector: 'bo-user-details',
    templateUrl: 'user_details_component.html',
    styleUrls: const ['user_details_component.css'],
    providers: const [],
    directives: const [FORM_DIRECTIVES, materialDirectives, LowercaseDirective, UppercaseDirective],
    preserveWhitespace: false
)

class UserDetailsComponent extends ModelDetailComponentBase
{
  UserDetailsComponent(this.userService, FormBuilder form_builder, PhraseService phrase) : super(form_builder, phrase)
  {
    BoValidators.service = userService;
    BoValidators.currentModelId = user?.id;
    form = formBuilder.group(_controlsConfig);
  }

  @Input('user')
  void set user(User u)
  {
    model = u;
  }
  
  User get user => model;

  final UserService userService;
  final Map<String, dynamic> _controlsConfig =
  {
    "city" : [null, Validators.compose([Validators.required, Validators.maxLength(64)])],
    "country" : ["sv", Validators.required],
    "email" : [null, Validators.compose([Validators.required, Validators.maxLength(100), BoValidators.unique("email", "_user_with_this_email_already_exists")])],
    "firstname" : [null, Validators.compose([Validators.required, BoValidators.isName, Validators.maxLength(64)])],
    "lastname" : [null, Validators.compose([Validators.required, BoValidators.isName, Validators.maxLength(64)])],
    "phone" : [null, Validators.compose([Validators.required, BoValidators.isPhoneNumber, Validators.maxLength(32), BoValidators.unique("phone", "_user_with_this_phone_already_exists")])],
    "postal_code" : [null, Validators.compose([Validators.required, BoValidators.isAlphaNumeric, Validators.minLength(2), Validators.maxLength(20)])],
    "social_number" : [null, Validators.compose([Validators.required, Validators.minLength(12), Validators.maxLength(12), BoValidators.isSwedishSocialSecurityNumber, BoValidators.unique("social_number", "_user_with_this_social_number_already_exists")])],
    "street" : [null, Validators.compose([Validators.required, Validators.minLength(4), Validators.maxLength(64)])],
    "status" : ["active", Validators.required],
    "password" : [null, Validators.compose([Validators.required, Validators.minLength(6), Validators.maxLength(64)])],
    "booking_rank" : ["0", Validators.compose([Validators.required, BoValidators.isNumeric])]
  };
}
