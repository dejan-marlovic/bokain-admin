// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:d_components/d_components.dart';
import 'package:fo_components/fo_components.dart';
import 'calendar_component/calendar_component.dart';
import 'dashboard_component/dashboard_component.dart';
import 'load_indicator_component/load_indicator_component.dart';
import 'log_component/log_component.dart';
import 'login_component/login_component.dart';
import 'model_components/base/list_component_base.dart';
import 'model_components/webshop/webshop_component.dart';
import 'model_components/service/service_component.dart';

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
    ConsultationService,
    CountryService,
    CustomerService,
    DayService,
    DynamicPhraseService,
    OutputService,
    IngredientService,
    ProductService,
    ProductCategoryService,
    LanguageService,
    ProductRoutineService,
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
  const Route(path:'/webshop', name:'Webshop', component: WebshopComponent),
  const Route(path:'/services', name:'Service', component: ServiceComponent),
  const Route(path:'/users', name:'UserList', component: UserListComponent),
  const Route(path:'/salons', name:'SalonList', component: SalonListComponent),
  const Route(path:'/consultations', name:'ConsultationList', component: ConsultationListComponent)
])
class AppComponent
{
  AppComponent(
      this._countryService,
      this._customerService,
      this._languageService,
      this.outputService,
      this._productService,
      this._productCategoryService,
      this._salonService,
      this._serviceService,
      this._serviceAddonService,
      this._skinTypeService,
      this.userService)
  {
    PhraseService.language = "sv";
    PhraseService.data = Phrases.data;

    loadStaticResources();
  }

  Future loadStaticResources() async
  {
   // _dynamicPhraseService.streamLanguage("sv");
    //temp
    await userService.login("patrick.minogue@gmail.com", "lok13rum");

    await _countryService.fetchAll();
    await _languageService.fetchAll();
    await _skinTypeService.fetchAll();

    _customerService.streamAll();
    _productService.streamAll();
    _productCategoryService.streamAll();
    _salonService.streamAll();
    _serviceService.streamAll();
    _serviceAddonService.streamAll();
    userService.streamAll();
  }

  final CountryService _countryService;
  final CustomerService _customerService;
  final LanguageService _languageService;
  final OutputService outputService;
  final ProductService _productService;
  final ProductCategoryService _productCategoryService;
  final SalonService _salonService;
  final ServiceService _serviceService;
  final ServiceAddonService _serviceAddonService;
  final SkinTypeService _skinTypeService;
  final UserService userService;

  bool navOpen = true;

  List<FoSidebarCategory> sidebarCategories =
  [
    new FoSidebarCategory("management",
    [
      new FoSidebarItem("index.html", "dashboard", "Dashboard", "dashboard"),
      new FoSidebarItem("calendar", "calendar", "Calendar", "event"),
      new FoSidebarItem("log", "log", "Log", "list")
    ]),
    new FoSidebarCategory("content",
    [
      new FoSidebarItem("customers", "customers", "CustomerList", "account_circle"),
      new FoSidebarItem("webshop", "webshop", "Webshop", "shopping_cart"),
      new FoSidebarItem("services", "services", "Service", "spa"),
      new FoSidebarItem("users", "users", "UserList", "supervisor_account"),
      new FoSidebarItem("salons", "salons", "SalonList", "store"),
      new FoSidebarItem("skin_consultations", "skin_consultations", "ConsultationList", "face")
    ]),
  ];
}
