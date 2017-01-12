// Copyright (c) 2017, BuyByMarcus Ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/platform/browser.dart';
import 'package:bokain_admin/components/app_component.dart';
import 'package:firebase/firebase.dart' as firebase;

main()
{
  firebase.initializeApp
  (
    apiKey: "AIzaSyCI0vWdEbluGat7P20ffnl8u5PCRPo_pC4",
    authDomain: "bokain-admin.firebaseapp.com",
    databaseURL: "https://bokain-admin.firebaseio.com",
    storageBucket: "bokain-admin.appspot.com"
  );

  bootstrap(AppComponent);
}
