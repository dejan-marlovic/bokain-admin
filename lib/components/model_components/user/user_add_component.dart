// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/common.dart';
import 'package:angular2/router.dart';
import 'package:bokain_models/bokain_models.dart' show User;
import 'package:bokain_admin/services/model_service.dart' show UserService;
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
    selector: 'bo-user-add',
    styleUrls: const ['../model_add_component/model_add_component.css', '../user_add_component/user_add_component.css'],
    templateUrl: '../user_add_component/user_add_component.html',
    directives: const [FORM_DIRECTIVES],
    viewBindings: const [FORM_BINDINGS],
    preserveWhitespace: false
)

class UserAddComponent
{
  UserAddComponent(this.phrase, this._formBuilder, this._router, this.userService)
  {
    form = _formBuilder.group(User.controlsConfig);
  }

  /*
  Future pushIfValid() async
  {
    if (await validateUniqueFields(_user))
    {
      String userError = await _userService.push(user);
      if (userError == null)
      {
        await modelService.push(user);
        router.navigate(['UserList']);
      }
      else
      {
        alertTitle = phrase.get(["error_occured"]);
        alertMessage = phrase.get(["_$userError"]);
      }
    }
  }
*/
  User get user => _user;

  String alertMessage;
  String alertTitle;

  final User _user = new User();
  final UserService userService;
  final FormBuilder _formBuilder;
  ControlGroup form;

  final PhraseService phrase;
  final Router _router;

}
