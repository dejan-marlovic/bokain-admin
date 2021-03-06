// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of details_component_base;

@Component(
    selector: 'bo-user-details',
    templateUrl: '../user/user_details_component.html',
    styleUrls: const ['../user/user_details_component.css'],
    directives: const [CORE_DIRECTIVES, formDirectives, FoImageFileComponent, LowercaseDirective, materialDirectives, StatusSelectComponent],
    pipes: const [PhrasePipe]
)

class UserDetailsComponent extends DetailsComponentBase<User> implements OnChanges
{
  UserDetailsComponent(UserService service) : super(service);

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("model"))
    {
      form = new ControlGroup(
      {
        "city" : new Control(user.city, Validators.compose(
            [
              FoValidators.required("enter_a_city"),
              Validators.maxLength(64)
            ])),
        "firstname" : new Control(user.firstname, Validators.compose(
            [
              FoValidators.required("enter_a_firstname"),
              FoValidators.alpha,
              Validators.maxLength(64)
            ])),
        "lastname" : new Control(user.lastname, Validators.compose(
            [
              FoValidators.required("enter_a_lastname"),
              FoValidators.alpha,
              Validators.maxLength(64)
            ])),
        "postal_code" : new Control(user.postalCode, Validators.compose(
            [
              FoValidators.required("enter_a_postal_code"),
              FoValidators.alphaNumeric,
              Validators.minLength(2),
              Validators.maxLength(20)
            ])),
        "street" : new Control(user.street, Validators.compose(
            [
              FoValidators.required("enter_a_street"),
              Validators.minLength(4),
              Validators.maxLength(64)
            ])),
        "password" : new Control(user.password, Validators.compose(
            [
              FoValidators.required("enter_a_password"),
              Validators.minLength(6),
              Validators.maxLength(64)
            ])),
        "booking_rank" : new Control(user.strBookingRank, Validators.compose(
            [
              FoValidators.required("enter_a_booking_rank"),
              FoValidators.numeric
            ])),
        "email" : new Control(user.email, Validators.compose(
          [
            FoValidators.required("enter_an_email"),
            Validators.maxLength(100),
            BoValidators.unique("email", "user_with_this_email_already_exists", userService, user)
          ])),
        "phone" : new Control(user.phone, Validators.compose(
          [
            FoValidators.required("enter_a_phone"),
            FoValidators.phoneNumber,
            Validators.maxLength(32),
            BoValidators.unique("phone", "user_with_this_phone_already_exists", userService, user)
          ])),
        "social_number" : new Control(user.socialNumber, Validators.compose(
          [
            FoValidators.required("enter_a_social_number"),
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
  UserService get userService => _service;

}
