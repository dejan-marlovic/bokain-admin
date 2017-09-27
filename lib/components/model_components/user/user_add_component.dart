// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of add_component_base;

@Component(
    selector: 'bo-user-add',
    styleUrls: const ['../user/user_add_component.css'],
    templateUrl: '../user/user_add_component.html',
    directives: const [CORE_DIRECTIVES, FoModalComponent, UserDetailsComponent, materialDirectives],
    pipes: const [PhrasePipe]
)
class UserAddComponent extends AddComponentBase
{
  UserAddComponent(UserService user_service, OutputService output_service) : super(user_service, output_service);

  Future push() async
  {
    try
    {
      /**
       * Throws exception if users unique fields already exists
       */
      String id = await userService.push(user);

      firebase.User fbUser = await firebase.auth().createUserWithEmailAndPassword(user.email, user.password);
      fbUser.sendEmailVerification();

      model = new User();

      _onAddController.add(id);
    }
    catch(e)
    {
      _outputService.set(e.toString());
      _onAddController.add(null);
    }
  }
  
  User get user => model;
  UserService get userService => _service;
}
