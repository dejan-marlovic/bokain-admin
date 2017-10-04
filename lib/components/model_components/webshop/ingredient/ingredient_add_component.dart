// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of add_component_base;

@Component(
  selector: 'bo-ingredient-add',
  styleUrls: const ['../webshop/ingredient/ingredient_add_component.css'],
  templateUrl: '../webshop/ingredient/ingredient_add_component.html',
  directives: const [CORE_DIRECTIVES, IngredientDetailsComponent, materialDirectives],
  pipes: const [PhrasePipe],
)
class IngredientAddComponent extends AddComponentBase
{
  IngredientAddComponent(this._dynamicPhraseService, this._languageService, IngredientService service, OutputService output_service) : super(service, output_service);

  @override
  void ngOnInit()
  {
    super.ngOnInit();

    for (Language language in _languageService.cachedModels.values)
    {
      ingredientPhrases[language.iso639_1] = new IngredientPhrases();
    }
  }

  Ingredient get ingredient => model;
  IngredientService get ingredientService => _service;

  @override
  Future<String> push() async
  {
    String id = await super.push();
    for (String language in ingredientPhrases.keys)
    {
      await _dynamicPhraseService.setPhrases(language, "ingredients", id, ingredientPhrases[language].data);
    }
    return id;
  }

  Map<String, IngredientPhrases> ingredientPhrases = new Map();
  final LanguageService _languageService;
  final DynamicPhraseService _dynamicPhraseService;
}
