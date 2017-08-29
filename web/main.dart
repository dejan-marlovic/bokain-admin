// Copyright (c) 2017, BuyByMarcus Ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:angular/angular.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:angular_router/angular_router.dart';
import 'package:bokain_admin/components/app_component.dart';
import 'package:firebase/firebase.dart' as firebase;

main() async
{
  await initializeDateFormatting("sv_SE", null);
  Intl.defaultLocale = "sv_SE";

  firebase.initializeApp
  (
    apiKey: "AIzaSyCI0vWdEbluGat7P20ffnl8u5PCRPo_pC4",
    authDomain: "bokain-admin.firebaseapp.com",
    databaseURL: "https://bokain-admin.firebaseio.com",
    storageBucket: "bokain-admin.appspot.com"
  );

  bootstrap(AppComponent,
  [
    FORM_PROVIDERS,
    ROUTER_PROVIDERS
  ]);
}
