// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2/common.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/model/model_service.dart' show UserService;

@Component(
  selector: 'bo-login',
  styleUrls: const ['login_component.css'],
  templateUrl: 'login_component.html',
  directives: const [FORM_DIRECTIVES, materialDirectives],
  viewBindings: const [FORM_BINDINGS],
  preserveWhitespace: false
)
class LoginComponent
{
  LoginComponent(this._formBuilder, this.phrase, this.userService)
  {
    form = _formBuilder.group
      (
        {
          "email":[null, Validators.compose([Validators.required])],
          "password":[null, Validators.compose([Validators.required])]
        }
    );
  }

  Future onLogin() async
  {
    loginErrorMessage = await userService.login(form.controls["email"].value, form.controls["password"].value);
  }


  String loginErrorMessage;
  final PhraseService phrase;
  final UserService userService;
  final FormBuilder _formBuilder;
  ControlGroup form;
}
