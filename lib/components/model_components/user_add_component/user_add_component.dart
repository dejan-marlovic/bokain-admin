// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of model_add_component;

@Component(
    selector: 'bo-user-add',
    styleUrls: const ['../model_add_component/model_add_component.css', '../user_add_component/user_add_component.css'],
    templateUrl: '../user_add_component/user_add_component.html',
    directives: const [FORM_DIRECTIVES, materialDirectives],
    preserveWhitespace: false
)

class UserAddComponent extends ModelAddComponent
{
  UserAddComponent(PhraseService phrase, CustomerService customer_service, FormBuilder form_builder, Router router, this._userService)
      : super(phrase, customer_service, form_builder, router)
  {
    form = _formBuilder.group(User.controlsConfig);
  }

  Future pushIfValid() async
  {
    if (await validateUniqueFields(_user) == true)
    {
      String userError = await _userService.create(user.email, form.controls["password"].value, true);
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

  User get user => _user;

  String alertMessage;
  String alertTitle;

  UserService get userService => _userService;

  final User _user = new User();
  final UserService _userService;
}
