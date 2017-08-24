// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular2/router.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
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
    ROUTER_DIRECTIVES,
    materialDirectives,
    FoModalComponent,
    FoSidebarComponent,
    LoadIndicatorComponent,
    LoginComponent,
  ],
  providers: const
  [
    materialProviders,
    BookingService,
    CalendarService,
    CountryService,
    CustomerService,
    CustomerAuthService,
    OutputService,
    JournalService,
    LanguageService,
    MailerService,
    PhraseService,
    SalonService,
    ServiceService,
    ServiceAddonService,
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
  /**
   * TODO:
   */

  AppComponent(
      this.bookingService,
      this.calendarService,
      this.countryService,
      this.customerService,
      this.outputService,
      this.journalService,
      this.languageService,
      this.mailerService,
      this.salonService,
      this.serviceService,
      this.serviceAddonService,
      this.skinTypeService,
      this.userService
      )
  {

    PhraseService.language = "sv";
    PhraseService.data = Phrases.data;

    //temp
    userService.login("patrick.minogue@gmail.com", "lok13rum");
  }

  bool get loading => bookingService.loading || calendarService.loading || customerService.loading || salonService.loading ||
      serviceService.loading || serviceAddonService.loading || userService.loading || mailerService.loading || journalService.loading;

  final BookingService bookingService;
  final CalendarService calendarService;
  final CountryService countryService;
  final CustomerService customerService;
  final OutputService outputService;
  final JournalService journalService;
  final LanguageService languageService;
  final MailerService mailerService;
  final SalonService salonService;
  final ServiceService serviceService;
  final ServiceAddonService serviceAddonService;
  final SkinTypeService skinTypeService;
  final UserService userService;

  bool navOpen = true;
}
