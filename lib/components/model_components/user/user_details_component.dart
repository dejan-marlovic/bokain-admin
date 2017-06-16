// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/model_components/model_detail_component_base.dart';
import 'package:bokain_admin/components/status_select_component/status_select_component.dart';
import 'package:bokain_admin/pipes/phrase_pipe.dart';

@Component(
    selector: 'bo-user-details',
    templateUrl: 'user_details_component.html',
    styleUrls: const ['user_details_component.css'],
    directives: const [FORM_DIRECTIVES, materialDirectives, LowercaseDirective, StatusSelectComponent],
    pipes: const [PhrasePipe]
)

class UserDetailsComponent extends ModelDetailComponentBase implements OnChanges
{
  UserDetailsComponent(this.userService) : super();

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("user"))
    {
      form = new ControlGroup(
      {
        "city" : new Control(user.city, Validators.compose(
            [
              BoValidators.required,
              Validators.maxLength(64)
            ])),
        "firstname" : new Control(user.firstname, Validators.compose(
            [
              BoValidators.required,
              BoValidators.isName,
              Validators.maxLength(64)
            ])),
        "lastname" : new Control(user.lastname, Validators.compose(
            [
              BoValidators.required,
              BoValidators.isName,
              Validators.maxLength(64)
            ])),
        "postal_code" : new Control(user.postalCode, Validators.compose(
            [
              BoValidators.required,
              BoValidators.isAlphaNumeric,
              Validators.minLength(2),
              Validators.maxLength(20)
            ])),
        "street" : new Control(user.street, Validators.compose(
            [
              BoValidators.required,
              Validators.minLength(4),
              Validators.maxLength(64)
            ])),
        "password" : new Control(user.password, Validators.compose(
            [
              BoValidators.required,
              Validators.minLength(6),
              Validators.maxLength(64)
            ])),
        "booking_rank" : new Control(user.strBookingRank, Validators.compose(
            [
              BoValidators.required,
              BoValidators.isNumeric
            ])),
        "email" : new Control(user.email, Validators.compose(
          [
            BoValidators.required,
            Validators.maxLength(100),
            BoValidators.unique("email", "_user_with_this_email_already_exists", userService, user)
          ])),
        "phone" : new Control(user.phone, Validators.compose(
          [
            BoValidators.required,
            BoValidators.isPhoneNumber,
            Validators.maxLength(32),
            BoValidators.unique("phone", "_user_with_this_phone_already_exists", userService, user)
          ])),
        "social_number" : new Control(user.socialNumber, Validators.compose(
          [
            BoValidators.required,
            Validators.minLength(12), Validators.maxLength(12),
            BoValidators.isSwedishSocialSecurityNumber,
            BoValidators.unique("social_number", "_user_with_this_social_number_already_exists", userService, user)
          ]))
      });
    }
  }

  User get user => model;

  final UserService userService;

  @Input('user')
  void set user(User u) { model = u; }
}
