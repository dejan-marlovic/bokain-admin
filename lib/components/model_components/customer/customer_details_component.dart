// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library customer_details_component;

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2/common.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/services/model_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-customer-details',
    templateUrl: 'details_component.html',
    styleUrls: const ['details_component.css'],
    providers: const [],
    directives: const [FORM_DIRECTIVES, materialDirectives],
    viewBindings: const [FORM_BINDINGS],
    preserveWhitespace: false
)

class CustomerDetailsComponent
{
  CustomerDetailsComponent(this.phrase, this._userService, this.customerService, this._formBuilder)
  {
    form = _formBuilder.group(Customer.controlsConfig);
  }

  Future<bool> validateUniqueFields(Model model) async
  {
    for (String unique_field in model.uniqueFields)
    {
      Control control = form.controls[unique_field];
      if (control != null)
      {
        if (customerService.findByProperty(unique_field, control.value) != null)
        {
          control.setErrors({"material-input-error" : phrase.get(["_unique_database_value_exists"])});
          return false;
        }
      }
    }
    return true;
  }

  Map<String, User> get userMap => _userService.modelMap;

  @Input('customer')
  Customer customer;

  ControlGroup form;
  final FormBuilder _formBuilder;
  final UserService _userService;
  final CustomerService customerService;
  final PhraseService phrase;
}
