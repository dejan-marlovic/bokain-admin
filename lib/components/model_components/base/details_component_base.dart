library details_component_base;

import 'dart:async';
import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_forms/angular_forms.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:d_components/d_components.dart';
import 'package:fo_components/fo_components.dart';
import '../../status_select_component/status_select_component.dart';

part '../customer/customer_details_component.dart';
part '../webshop/product/product_details_component.dart';
part '../webshop/product_category/product_category_details_component.dart';
part '../salon/salon_details_component.dart';
part '../service/service/service_details_component.dart';
part '../service/service_addon/service_addon_details_component.dart';
part '../user/user_details_component.dart';

abstract class DetailsComponentBase
{
  DetailsComponentBase(this._service);

  bool get valid => (form == null) ? false : form.valid;

  final FirebaseServiceBase _service;
  ControlGroup form = new ControlGroup({});

  @Input('model')
  ModelBase model;
}