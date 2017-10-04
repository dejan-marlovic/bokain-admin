// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library list_component_base;

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'add_component_base.dart';
import 'edit_component_base.dart';

part '../consultation/consultation_list_component.dart';
part '../customer/customer_list_component.dart';
part '../webshop/ingredient/ingredient_list_component.dart';
part '../webshop/product/product_list_component.dart';
part '../webshop/product_category/product_category_list_component.dart';
part '../salon/salon_list_component.dart';
part '../service/service/service_list_component.dart';
part '../service/service_addon/service_addon_list_component.dart';
part '../user/user_list_component.dart';

abstract class ListComponentBase
{
  ListComponentBase(this.service);

  void openModel(String event)
  {
    selectedModel = service.get(event);
    editModelVisible = true;
  }

  bool addModelVisible = false;
  bool editModelVisible = false;
  EditableModel selectedModel;
  final FirebaseServiceBase service;
}
