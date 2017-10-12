// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of details_component_base;

@Component(
    selector: 'bo-customer-details',
    templateUrl: '../customer/customer_details_component.html',
    styleUrls: const ['../customer/customer_details_component.css'],
    directives: const
    [
      CORE_DIRECTIVES,
      formDirectives,
      FoModalComponent,
      FoSelectComponent,
      LowercaseDirective,
      materialDirectives,
      StatusSelectComponent,
      UppercaseDirective
    ],
    pipes: const [DatePipe, PhrasePipe]
)

class CustomerDetailsComponent extends DetailsComponentBase implements OnInit, OnChanges
{
  CustomerDetailsComponent(
      this.countryService,
      CustomerService customer_service,
      this.languageService,
      this._phraseService,
      this.skinTypeService,
      this.userService)
  : super(customer_service);

  void ngOnInit()
  {
    countryOptions = new StringSelectionOptions(countryService.cachedModels.values.toList(growable: false));
    languageOptions = new StringSelectionOptions(languageService.cachedModels.values.toList(growable: false));
    userOptions = new StringSelectionOptions(userService.cachedModels.values.toList(growable: false));
    sexOptions = new StringSelectionOptions(
    [
      new FoModel("male", _phraseService.get("male")),
      new FoModel("female", _phraseService.get("female"))
    ]);
  }

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("model"))
    {
      form = new ControlGroup(
      {
        "firstname" : new Control(customer.firstname,
            Validators.compose([FoValidators.required("enter_a_firstname"), FoValidators.alpha, Validators.maxLength(64)])),
        "lastname" : new Control(customer.lastname,
            Validators.compose([FoValidators.required("enter_a_lastname"), FoValidators.alpha, Validators.maxLength(64)])),
        "street" : new Control(customer.street,
            Validators.compose([FoValidators.required("enter_a_street"), Validators.minLength(4), Validators.maxLength(64)])),
        "care_of" : new Control(customer.careOf, null),
        "postal_code" : new Control(customer.postalCode,
            Validators.compose([FoValidators.required("enter_a_postal_code"), FoValidators.alphaNumeric, Validators.minLength(2), Validators.maxLength(20)])),
        "city" : new Control(customer.city,
            Validators.compose([FoValidators.required("enter_a_city"), Validators.maxLength(64)])),
        "comments_internal" : new Control(customer.commentsInternal,
            Validators.maxLength(8000)),
        "comments_external" : new Control(customer.commentsExternal,
            Validators.maxLength(8000)),
        "email" : new Control(customer.email,
            Validators.compose([FoValidators.required("enter_an_email"), Validators.maxLength(100),
            BoValidators.unique("email", "customer_with_this_email_already_exists", customerService, customer)])),
        "phone" : new Control(customer.phone,
            Validators.compose([FoValidators.required("enter_a_phone"), FoValidators.phoneNumber, Validators.maxLength(32),
            BoValidators.unique("phone", "customer_with_this_phone_already_exists", customerService, customer)])),
        "social_number" : new Control(customer.socialNumber,
            Validators.compose([FoValidators.swedishSocialSecurityNumber,
            BoValidators.unique("social_number", "customer_with_this_social_number_already_exists", customerService, customer)])),
        "age" : new Control(customer.strAge, Validators.compose([FoValidators.integer]))
      });

      if (customer.socialNumber != null && customer.socialNumber.isNotEmpty) _evalSexAndAge();
    }
  }

  fetchDetails() async
  {
    try
    {
      if (customer.socialNumber == null || customer.socialNumber.isEmpty) return;

      errorMessage = null;
      Map<String, String> details = await customerService.fetchDetails(customer.socialNumber);
      details.remove(details.values.where((value) => value == null || value.isEmpty));
      details.forEach((property, value)
      {
        if (value != null && value.isNotEmpty) customer.data[property] = value;
      });

      _evalSexAndAge();

    } catch(e) { errorMessage = "ssn_error_could_not_fetch"; }
  }

  void _evalSexAndAge()
  {
    customer.age = new DateTime.now().difference(DateTime.parse(customer.socialNumber.substring(0, "YYYYMMDD".length))).inDays ~/365;
    customer.sex = int.parse(customer.socialNumber["YYYYMMDD-X".length]).isEven ? "female" : "male";
  }

  CustomerService get customerService => _service;
  Customer get customer => model;

  String errorMessage;
  final CountryService countryService;
  final LanguageService languageService;
  final PhraseService _phraseService;
  final SkinTypeService skinTypeService;
  final UserService userService;
  StringSelectionOptions<Country> countryOptions;
  StringSelectionOptions<Language> languageOptions;
  StringSelectionOptions<User> userOptions;
  StringSelectionOptions<FoModel> sexOptions;

  @Input('showComments')
  bool showComments = true;
}
