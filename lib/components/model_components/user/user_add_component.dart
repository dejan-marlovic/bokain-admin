// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:angular2/core.dart';
import 'package:angular2/common.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_models/bokain_models.dart' show User;
import 'package:bokain_admin/components/model_components/user/user_details_component.dart';
import 'package:bokain_admin/services/model_service.dart' show UserService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-user-add',
    styleUrls: const ['user_add_component.css'],
    templateUrl: 'user_add_component.html',
    directives: const [FORM_DIRECTIVES, UserDetailsComponent, materialDirectives],
    viewBindings: const [FORM_BINDINGS],
    preserveWhitespace: false
)

class UserAddComponent
{
  UserAddComponent(this.phrase, this._router, this.userService);

  Future pushIfValid() async
  {
    String userError = await userService.push(user);
    if (userError == null) _router.navigate(['UserList']);
    else
    {
      alertTitle = phrase.get(["error_occured"]);
      alertMessage = phrase.get(["_$userError"]);
    }
  }

  User user = new User();

  String alertMessage;
  String alertTitle;

  final UserService userService;

  final PhraseService phrase;
  final Router _router;

}
