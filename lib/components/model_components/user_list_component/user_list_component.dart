// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of model_list_component;

@Component(
    selector: 'bo-user-list',
    styleUrls: const ['../model_list_component/model_list_component.css', '../user_list_component/user_list_component.css'],
    templateUrl: '../user_list_component/user_list_component.html',
    directives: const [ROUTER_DIRECTIVES, materialDirectives],
    pipes: const [],
    preserveWhitespace: false
)

class UserListComponent extends ModelListComponent
{
  UserListComponent(PhraseService phrase, CustomerService customer_service, this._userService)
  : super(phrase, customer_service)
  {
  }

  Map<String, User> get userMap => (modelService.modelMap as Map<String, User>);

  UserService get userService => _userService;

  final UserService _userService;
}
