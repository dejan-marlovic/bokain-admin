// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/core.dart';
import 'package:angular2/common.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:bokain_admin/components/dashboard_component/dashboard_component.dart';
import 'package:bokain_admin/components/login_component/login_component.dart';
import 'package:bokain_admin/components/model_add_component/model_add_component.dart';
import 'package:bokain_admin/components/model_list_component/model_list_component.dart';
import 'package:bokain_admin/components/sidebar_component/sidebar_component.dart';
import 'package:bokain_admin/services/model_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';
import 'package:bokain_admin/services/user_service.dart';

@Component(
  selector: 'bo-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [ROUTER_DIRECTIVES, LoginComponent, SidebarComponent],
  providers: const [FORM_PROVIDERS, materialProviders, CustomerService, PhraseService, UserService],
  preserveWhitespace: false
)

@RouteConfig(const
[
  const Route(path:'/dashboard', name:'Dashboard', component: DashboardComponent, useAsDefault: true),
  const Route(path:'/customer-list', name:'CustomerList', component: CustomerListComponent),
  const Route(path:'/customer-add', name:'CustomerAdd', component: CustomerAddComponent),
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
