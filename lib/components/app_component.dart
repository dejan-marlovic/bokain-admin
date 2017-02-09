// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/common.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_admin/components/calendar_component/calendar_component.dart';
import 'package:bokain_admin/components/confirm_popup_component/confirm_popup_component.dart';
import 'package:bokain_admin/components/dashboard_component/dashboard_component.dart';
import 'package:bokain_admin/components/login_component/login_component.dart';
import 'package:bokain_admin/components/model_components/customer/customer_add_component.dart';
import 'package:bokain_admin/components/model_components/customer/customer_edit_component.dart';
import 'package:bokain_admin/components/model_components/customer/customer_list_component.dart';
//import 'package:bokain_admin/components/model_components/salon/salon_add_component.dart';
import 'package:bokain_admin/components/model_components/user/user_add_component.dart';
import 'package:bokain_admin/components/model_components/user/user_edit_component.dart';
import 'package:bokain_admin/components/model_components/user/user_list_component.dart';
import 'package:bokain_admin/components/sidebar_component/sidebar_component.dart';
import 'package:bokain_admin/services/confirm_popup_service.dart';
import 'package:bokain_admin/services/editable_model/editable_model_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
  selector: 'bo-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [ROUTER_DIRECTIVES, ConfirmPopupComponent, LoginComponent, SidebarComponent],
  providers: const [FORM_PROVIDERS, materialProviders, ConfirmPopupService, CustomerService, PhraseService, UserService],
  preserveWhitespace: false
)
@RouteConfig(const
[
  const Route(path:'/dashboard', name:'Dashboard', component: DashboardComponent, useAsDefault: false),
  const Route(path:'/index.html', name:'Calendar', component: CalendarComponent, useAsDefault: true),
  const Route(path:'/customer-add', name:'CustomerAdd', component: CustomerAddComponent, useAsDefault: false),
  const Route(path:'/customer-edit', name: 'CustomerEdit', component: CustomerEditComponent, useAsDefault: false),
  const Route(path:'/customer-list', name:'CustomerList', component: CustomerListComponent, useAsDefault: false),
  const Route(path:'/user-add', name:'UserAdd', component: UserAddComponent),
  const Route(path:'/user-edit', name:'UserEdit', component: UserEditComponent),
  const Route(path:'/user-list', name:'UserList', component: UserListComponent),
])
class AppComponent
{
  AppComponent(this.phrase, this.userService)
  {
    //temp
    userService.login("patrick.minogue@gmail.com", "lok13rum");



  }


  final PhraseService phrase;
  final UserService userService;
}
