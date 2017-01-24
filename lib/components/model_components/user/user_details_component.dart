// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library user_details_component;

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2/common.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show FoValidators;
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/services/model_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-user-details',
    templateUrl: 'user_details_component.html',
    styleUrls: const ['user_details_component.css'],
    providers: const [],
    directives: const [FORM_DIRECTIVES, materialDirectives],
    viewBindings: const [FORM_BINDINGS],
    preserveWhitespace: false
)

class UserDetailsComponent
{
  UserDetailsComponent(this.phrase, this.userService, this._formBuilder)
  {
    Map<String, dynamic> controlsConfig =
    {
      "city":[null, Validators.compose([Validators.required, Validators.maxLength(64)])],
      "country" : ["sv", Validators.required],
      "email":[null, Validators.compose([Validators.required, Validators.maxLength(100)])],
      "firstname":[null, Validators.compose([Validators.required, FoValidators.isName, Validators.maxLength(64)])],
      "lastname":[null, Validators.compose([Validators.required, FoValidators.isName, Validators.maxLength(64)])],
      "phone":[null, Validators.compose([Validators.required, FoValidators.isPhoneNumber, Validators.maxLength(32)])],
      "postal_code":[null, Validators.compose([Validators.required, FoValidators.isAlphaNumeric, Validators.minLength(2), Validators.maxLength(20)])],
      "social_number":[null, Validators.compose([Validators.required, Validators.minLength(12), Validators.maxLength(12), FoValidators.isNumeric])],
      "street":[null, Validators.compose([Validators.required, Validators.minLength(4), Validators.maxLength(64)])],
      "status" : ["active", Validators.required],
      "password" : [null, Validators.compose([Validators.required, Validators.minLength(6), Validators.maxLength(64)])]
    };

    form = _formBuilder.group(controlsConfig);
  }

  void validateUniqueField(String input_id)
  {
    User match = userService.findByProperty(input_id, form.controls[input_id].value);
    if (match != null && match != user)
    {
      form.controls[input_id].setErrors({"material-input-error" : phrase.get(["_unique_database_value_exists"])});
    }
  }

  @Input('user')
  User user;

  ControlGroup form;
  final FormBuilder _formBuilder;
  final UserService userService;
  final PhraseService phrase;
}
