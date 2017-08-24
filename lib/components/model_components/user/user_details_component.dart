// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:fo_components/fo_components.dart';
import 'package:bokain_models/bokain_models.dart';
import 'package:bokain_admin/components/model_components/model_detail_component_base.dart';
import 'package:bokain_admin/components/status_select_component/status_select_component.dart';

@Component(
    selector: 'bo-user-details',
    templateUrl: 'user_details_component.html',
    styleUrls: const ['user_details_component.css'],
    directives: const [FORM_DIRECTIVES, FoImageFileComponent, LowercaseDirective, materialDirectives, StatusSelectComponent],
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
              FoValidators.required,
              Validators.maxLength(64)
            ])),
        "firstname" : new Control(user.firstname, Validators.compose(
            [
              FoValidators.required,
              FoValidators.alpha,
              Validators.maxLength(64)
            ])),
        "lastname" : new Control(user.lastname, Validators.compose(
            [
              FoValidators.required,
              FoValidators.alpha,
              Validators.maxLength(64)
            ])),
        "postal_code" : new Control(user.postalCode, Validators.compose(
            [
              FoValidators.required,
              FoValidators.alphaNumeric,
              Validators.minLength(2),
              Validators.maxLength(20)
            ])),
        "street" : new Control(user.street, Validators.compose(
            [
              FoValidators.required,
              Validators.minLength(4),
              Validators.maxLength(64)
            ])),
        "password" : new Control(user.password, Validators.compose(
            [
              FoValidators.required,
              Validators.minLength(6),
              Validators.maxLength(64)
            ])),
        "booking_rank" : new Control(user.strBookingRank, Validators.compose(
            [
              FoValidators.required,
              FoValidators.numeric
            ])),
        "email" : new Control(user.email, Validators.compose(
          [
            FoValidators.required,
            Validators.maxLength(100),
            BoValidators.unique("email", "service_addon_with_this_name_already_exists", userService, user)
          ])),
        "phone" : new Control(user.phone, Validators.compose(
          [
            FoValidators.required,
            FoValidators.phoneNumber,
            Validators.maxLength(32),
            BoValidators.unique("phone", "user_with_this_phone_already_exists", userService, user)
          ])),
        "social_number" : new Control(user.socialNumber, Validators.compose(
          [
            FoValidators.required,
            Validators.minLength(12), Validators.maxLength(12),
            FoValidators.swedishSocialSecurityNumber,
            BoValidators.unique("social_number", "user_with_this_social_number_already_exists", userService, user)
          ]))
      });
    }
  }

  Future onProfileImageSourceChange(String source) async
  {
    if (source.isEmpty) user.profileImageUrl = "";
    else user.profileImageUrl = await userService.uploadImage(user.id, source);

  }

  User get user => model;

  final UserService userService;


  @Input('user')
  void set user(User u) { model = u; }
}
