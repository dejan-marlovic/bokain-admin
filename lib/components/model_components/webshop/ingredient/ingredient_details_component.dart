// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of details_component_base;

@Component(
    selector: 'bo-ingredient-details',
    templateUrl: '../webshop/ingredient/ingredient_details_component.html',
    styleUrls: const ['../webshop/ingredient/ingredient_details_component.css'],
    directives: const
    [
      CORE_DIRECTIVES,
      formDirectives,
      FoMultiInputComponent,
      FoSelectComponent,
      materialDirectives,
      FoImageFileComponent,
      StatusSelectComponent
    ],
    pipes: const [PhrasePipe]
)
class IngredientDetailsComponent extends DetailsComponentBase implements OnChanges
{
  IngredientDetailsComponent(IngredientService service, this._languageService) : super(service)
  {
    languageOptions = new StringSelectionOptions(_languageService.cachedModels.values.toList(growable: false));
    selectedLanguage = _languageService.cachedModels.values.first;
  }

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("model"))
    {
      form = new ControlGroup(
      {
        "name" : new Control(ingredient.name, Validators.compose(
            [
              FoValidators.required("enter_a_name"),
              FoValidators.alphaNumeric,
              FoValidators.noSpaces,
              Validators.maxLength(32),
              BoValidators.unique("name", "ingredient_with_this_name_already_exists", ingredientService, ingredient)
            ]))
      });
    }
    if (changes.containsKey("ingredientPhrases")) updatePhrasesForm();
  }

  void updatePhrasesForm()
  {
    phrasesForm = new ControlGroup(
        {
          "name" : new Control(ingredientPhrases[selectedLanguage.iso639_1].name, Validators.compose(
              [
                FoValidators.alphaNumeric,
                Validators.maxLength(32)
              ])),
          "name_inci" : new Control(ingredientPhrases[selectedLanguage.iso639_1].nameINCI, Validators.compose(
              [
                FoValidators.alphaNumeric,
                Validators.maxLength(32)
              ])),
          "category" : new Control(ingredientPhrases[selectedLanguage.iso639_1].category, Validators.compose(
              [
                Validators.maxLength(32)
              ])),
          "origin" : new Control(ingredientPhrases[selectedLanguage.iso639_1].origin, Validators.compose(
              [
                Validators.maxLength(128),
              ])),
          "trivia" : new Control(ingredientPhrases[selectedLanguage.iso639_1].trivia, Validators.compose(
              [
                Validators.maxLength(4000),
              ]))
        });
  }

  @override
  bool get valid => super.valid && (phrasesForm != null && phrasesForm.valid);

  ControlGroup phrasesForm;
  Ingredient get ingredient => model;
  IngredientService get ingredientService => _service;
  final LanguageService _languageService;
  StringSelectionOptions<Language> languageOptions;
  final StringSelectionOptions<FoModel> gradeOptions = new StringSelectionOptions(
  [
    new FoModel("Avoid"),
    new FoModel("Average"),
    new FoModel("Good"),
    new FoModel("Best")
  ]);
  final StringSelectionOptions<FoModel> typeOptions = new StringSelectionOptions(
  [
    new FoModel("Animal"),
    new FoModel("Synthetic"),
    new FoModel("Plant")
  ]);
  Language selectedLanguage;

  @Input('ingredientPhrases')
  Map<String, IngredientPhrases> ingredientPhrases;
}
