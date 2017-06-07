// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart' show IconComponent, FoSidebarComponent;
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/calendar_component/calendar_component.dart';
import 'package:bokain_admin/components/dashboard_component/dashboard_component.dart';
import 'package:bokain_admin/components/load_indicator_component/load_indicator_component.dart';
import 'package:bokain_admin/components/login_component/login_component.dart';
import 'package:bokain_admin/components/model_components/customer/customer_list_component.dart';
import 'package:bokain_admin/components/model_components/salon/salon_list_component.dart';
import 'package:bokain_admin/components/model_components/service/service_list_component.dart';
import 'package:bokain_admin/components/model_components/service_addon/service_addon_list_component.dart';
import 'package:bokain_admin/components/model_components/user/user_list_component.dart';
import 'package:bokain_admin/components/sidebar_component/sidebar_component.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';

@Component(
  selector: 'bo-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const
  [
    ROUTER_DIRECTIVES,
    materialDirectives,
    FoSidebarComponent,
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
    CustomerService,
    JournalService,
    MailerService,
    PhraseService,
    SalonService,
    ServiceService,
    ServiceAddonService,
    UserService
  ],
  pipes: const [PhrasePipe]
)
@RouteConfig(const
[
  const Route(path:'/index.html', name:'Dashboard', component: DashboardComponent, useAsDefault: true),
  const Route(path:'/calendar', name:'Calendar', component: CalendarComponent),
  const Route(path:'/customers', name:'CustomerList', component: CustomerListComponent),
  const Route(path:'/salons', name:'SalonList', component: SalonListComponent),
  const Route(path:'/services', name:'ServiceList', component: ServiceListComponent),
  const Route(path:'service-addons', name:'ServiceAddonList', component: ServiceAddonListComponent),
  const Route(path:'/user-list', name:'UserList', component: UserListComponent)
])
class AppComponent
{
  AppComponent(this.bookingService, this.calendarService, this.customerService, this.journalService, this.mailerService, this.salonService, this.serviceService, this.serviceAddonService, this.userService)
  {
    //temp
    userService.login("patrick.minogue@gmail.com", "lok13rum");
  }

  bool get isLoading => bookingService.isLoading || calendarService.isLoading || customerService.isLoading || salonService.isLoading ||
      serviceService.isLoading || serviceAddonService.isLoading || userService.isLoading || mailerService.isLoading || journalService.isLoading;

  final BookingService bookingService;
  final CalendarService calendarService;
  final CustomerService customerService;
  final JournalService journalService;
  final MailerService mailerService;
  final SalonService salonService;
  final ServiceService serviceService;
  final ServiceAddonService serviceAddonService;
  final UserService userService;

  bool navOpen = false;
}
