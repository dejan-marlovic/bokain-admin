// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular2_components/angular2_components.dart';
import 'package:fo_components/fo_components.dart' show IconComponent;
import 'package:bokain_admin/components/calendar_component/calendar_component.dart';
import 'package:bokain_admin/components/confirm_popup_component/confirm_popup_component.dart';
import 'package:bokain_admin/components/dashboard_component/dashboard_component.dart';
import 'package:bokain_admin/components/load_indicator_component/load_indicator_component.dart';
import 'package:bokain_admin/components/login_component/login_component.dart';
import 'package:bokain_admin/components/model_components/customer/customer_add_component.dart';
import 'package:bokain_admin/components/model_components/customer/customer_edit_component.dart';
import 'package:bokain_admin/components/model_components/customer/customer_list_component.dart';
import 'package:bokain_admin/components/model_components/salon/salon_add_component.dart';
import 'package:bokain_admin/components/model_components/salon/salon_edit_component.dart';
import 'package:bokain_admin/components/model_components/salon/salon_list_component.dart';
import 'package:bokain_admin/components/model_components/service/service_add_component.dart';
import 'package:bokain_admin/components/model_components/service/service_edit_component.dart';
import 'package:bokain_admin/components/model_components/service/service_list_component.dart';
import 'package:bokain_admin/components/model_components/service_addon/service_addon_add_component.dart';
import 'package:bokain_admin/components/model_components/service_addon/service_addon_edit_component.dart';
import 'package:bokain_admin/components/model_components/service_addon/service_addon_list_component.dart';
import 'package:bokain_admin/components/model_components/user/user_add_component.dart';
import 'package:bokain_admin/components/model_components/user/user_edit_component.dart';
import 'package:bokain_admin/components/model_components/user/user_list_component.dart';
import 'package:bokain_admin/components/sidebar_component/sidebar_component.dart';
import 'package:bokain_admin/services/calendar_service.dart';
import 'package:bokain_admin/services/confirm_popup_service.dart';
import 'package:bokain_admin/services/model/model_service.dart';
import 'package:bokain_admin/services/phrase_service.dart';

@Component(
  selector: 'bo-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const
  [
    ROUTER_DIRECTIVES,
    ConfirmPopupComponent,
    IconComponent,
    LoadIndicatorComponent,
    LoginComponent,
    SidebarComponent
  ],
  providers: const
  [
    FORM_PROVIDERS,
    materialProviders,
    BookingService,
    CalendarService,
    ConfirmPopupService,
    CustomerService,
    PhraseService,
    SalonService,
    ServiceService,
    ServiceAddonService,
    UserService
  ],
  preserveWhitespace: false
)
@RouteConfig(const
[
  const Route(path:'/index.html', name:'Dashboard', component: DashboardComponent, useAsDefault: true),
  const Route(path:'/calendar', name:'Calendar', component: CalendarComponent),
  const Route(path:'/customer-add', name:'CustomerAdd', component: CustomerAddComponent),
  const Route(path:'/customer-edit', name: 'CustomerEdit', component: CustomerEditComponent),
  const Route(path:'/customer-list', name:'CustomerList', component: CustomerListComponent),
  const Route(path:'/salon-add', name:'SalonAdd', component: SalonAddComponent),
  const Route(path:'/salon-edit', name:'SalonEdit', component: SalonEditComponent),
  const Route(path:'/salon-list', name:'SalonList', component: SalonListComponent),
  const Route(path:'/service-add', name:'ServiceAdd', component: ServiceAddComponent),
  const Route(path:'/service-edit', name:'ServiceEdit', component: ServiceEditComponent),
  const Route(path:'/service-list', name:'ServiceList', component: ServiceListComponent),
  const Route(path:'/service-addon-add', name:'ServiceAddonAdd', component: ServiceAddonAddComponent),
  const Route(path:'/service-addon-edit', name:'ServiceAddonEdit', component: ServiceAddonEditComponent),
  const Route(path:'service-addon-list', name:'ServiceAddonList', component: ServiceAddonListComponent),
  const Route(path:'/user-add', name:'UserAdd', component: UserAddComponent),
  const Route(path:'/user-edit', name:'UserEdit', component: UserEditComponent),
  const Route(path:'/user-list', name:'UserList', component: UserListComponent)
])
class AppComponent
{
  AppComponent(this.phrase, this.bookingService, this.calendarService, this.customerService, this.salonService, this.serviceService, this.serviceAddonService, this.userService)
  {
    //temp
    userService.login("patrick.minogue@gmail.com", "lok13rum");
  }

  bool get isLoading => bookingService.isLoading || calendarService.isLoading || customerService.isLoading || salonService.isLoading ||
      serviceService.isLoading || serviceAddonService.isLoading || userService.isLoading;

  final BookingService bookingService;
  final CalendarService calendarService;
  final CustomerService customerService;
  final SalonService salonService;
  final ServiceService serviceService;
  final ServiceAddonService serviceAddonService;
  final UserService userService;
  final PhraseService phrase;

  bool navOpen = false;
}
