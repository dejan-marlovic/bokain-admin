// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future;
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';

@Component(
  selector: 'bo-login',
  styleUrls: const ['login_component.css'],
  templateUrl: 'login_component.html',
  directives: const [FORM_DIRECTIVES, materialDirectives],
  pipes: const [PhrasePipe]
)
class LoginComponent
{
  LoginComponent(this._formBuilder, this.userService)
  {
    form = _formBuilder.group
      (
        {
          "email":[null, Validators.compose([FoValidators.required])],
          "password":[null, Validators.compose([FoValidators.required])]
        }
    );
  }

  Future onLogin() async
  {
    loginErrorMessage = await userService.login(form.controls["email"].value, form.controls["password"].value);
  }


  String loginErrorMessage;
  final UserService userService;
  final FormBuilder _formBuilder;
  ControlGroup form;
}
