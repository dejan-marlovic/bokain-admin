// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:d_components/d_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_admin/components/calendar_component/calendar_component.dart';
import 'package:bokain_admin/components/dashboard_component/dashboard_component.dart';
import 'package:bokain_admin/components/load_indicator_component/load_indicator_component.dart';
import 'package:bokain_admin/components/log_component/log_component.dart';
import 'package:bokain_admin/components/login_component/login_component.dart';
import 'package:bokain_admin/components/model_components/customer/customer_list_component.dart';
import 'package:bokain_admin/components/model_components/salon/salon_list_component.dart';
import 'package:bokain_admin/components/model_components/service/service_list_component.dart';
import 'package:bokain_admin/components/model_components/service_addon/service_addon_list_component.dart';
import 'package:bokain_admin/components/model_components/user/user_list_component.dart';

@Component(
  selector: 'bo-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const
  [
    CORE_DIRECTIVES,
    dNavbarComponent,
    LoadIndicatorComponent,
    LoginComponent,
    FoModalComponent,
    FoSidebarComponent,
    materialDirectives,
    ROUTER_DIRECTIVES
  ],
  providers: const
  [
    materialProviders,
    BookingService,
    CountryService,
    CustomerService,
    DayService,
    OutputService,
    LanguageService,
    SalonService,
    ServiceService,
    ServiceAddonService,
    MailerService,
    OutputService,
    PhraseService,
    SkinTypeService,
    UserService
  ],
  pipes: const [PhrasePipe]
)
@RouteConfig(const
[
  const Route(path:'/index.html', name:'Dashboard', component: DashboardComponent, useAsDefault: true),
  const Route(path:'/calendar', name:'Calendar', component: CalendarComponent),
  const Route(path:'/customers', name:'CustomerList', component: CustomerListComponent),
  const Route(path:'/log', name:'Log', component: LogComponent),
  const Route(path:'/salons', name:'SalonList', component: SalonListComponent),
  const Route(path:'/services', name:'ServiceList', component: ServiceListComponent),
  const Route(path:'service-addons', name:'ServiceAddonList', component: ServiceAddonListComponent),
  const Route(path:'/user-list', name:'UserList', component: UserListComponent)
])
class AppComponent
{
  AppComponent(this._countryService, this._languageService, this.outputService, this._salonService, this._skinTypeService, this.userService)
  {
    PhraseService.language = "sv";
    PhraseService.data = Phrases.data;

    loadStaticResources();
  }

  Future loadStaticResources() async
  {
    await _countryService.fetchAll();
    await _languageService.fetchAll();
    await _skinTypeService.fetchAll();
    //await userService.fetchAll();

    _salonService.streamAll();
    userService.streamAll();



    //temp
    await userService.login("patrick.minogue@gmail.com", "lok13rum");

  }

  final CountryService _countryService;
  final LanguageService _languageService;
  final OutputService outputService;
  final SalonService _salonService;
  final SkinTypeService _skinTypeService;
  final UserService userService;

  bool navOpen = true;
}
