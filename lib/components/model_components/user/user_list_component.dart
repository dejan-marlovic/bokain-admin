// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of list_component_base;

@Component(
    selector: 'bo-user-list',
    styleUrls: const ['../user/user_list_component.css'],
    templateUrl: '../user/user_list_component.html',
    directives: const [CORE_DIRECTIVES, DataTableComponent, FoModalComponent, materialDirectives, UserAddComponent, UserEditComponent],
    pipes: const [PhrasePipe]
)
class UserListComponent extends ListComponentBase
{
  UserListComponent(UserService service) : super(service);
}
