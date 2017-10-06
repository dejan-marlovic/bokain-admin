// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of details_component_base;

@Component(
    selector: 'bo-product-details',
    templateUrl: '../webshop/product/product_details_component.html',
    styleUrls: const ['../webshop/product/product_details_component.css'],
    directives: const
    [
      CORE_DIRECTIVES,
      formDirectives,
      FoImageFileComponent,
      FoMultiSelectComponent,
      FoSelectComponent,
      materialDirectives,
      ProductRoutineDetailsComponent,
      StatusSelectComponent
    ],
    pipes: const [PhrasePipe],
    providers: const []
)
class ProductDetailsComponent extends DetailsComponentBase implements OnChanges
{
  ProductDetailsComponent(
      ProductService service,
      this._ingredientService,
      this._languageService,
      this.productCategoryService,
      this.productRoutineService) : super(service)
  {
    ingredientOptions = new StringSelectionOptions(_ingredientService.cachedModels.values.toList(growable: false), shouldSort: true);
    productOptions = new StringSelectionOptions(service.cachedModels.values.toList(growable: false), shouldSort: true);
    languageOptions = new StringSelectionOptions(_languageService.cachedModels.values.toList(growable: false), shouldSort: true);
    selectedLanguage = _languageService.cachedModels.values.first;
    productCategoryOptions = new StringSelectionOptions(productCategoryService.cachedModels.values.toList(growable: false), shouldSort: true);
  }

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("model"))
    {
      form = new ControlGroup(
      {
        "name" : new Control(product.name, Validators.compose(
          [
            FoValidators.required("enter_a_name"),
            Validators.maxLength(32),
            BoValidators.unique("name", "product_with_this_name_already_exists", productService, product)
          ]
        )),
        "article_no" : new Control(product.articleNo, Validators.compose(
          [
            FoValidators.required("enter_an_article_no"),
            FoValidators.alphaNumeric,
            FoValidators.noSpaces,
            Validators.maxLength(32),
            BoValidators.unique("article_no", "product_with_this_article_no_already_exists", productService, product)
          ])),
        "buy_price_sek" : new Control(product.strBuyPriceSEK, Validators.compose(
            [
              FoValidators.required(),
              FoValidators.integer,
              Validators.maxLength(8)
            ])),
        "price_eur" : new Control(product.strPriceEUR, Validators.compose(
            [
              FoValidators.required(),
              FoValidators.numeric,
              Validators.maxLength(8)
            ])),
        "price_sek" : new Control(product.strPriceSEK, Validators.compose(
            [
              FoValidators.required(),
              FoValidators.numeric,
              Validators.maxLength(8)
            ])),
        "price_usd" : new Control(product.strPriceUSD, Validators.compose(
            [
              FoValidators.required(),
              FoValidators.numeric,
              Validators.maxLength(8)
            ])),
        "score" : new Control(product.strScore, Validators.compose(
            [
              FoValidators.required(),
              FoValidators.integer,
              Validators.maxLength(6)
            ])),
        "search_rank" : new Control(product.strSearchRank, Validators.compose(
            [
              FoValidators.required("enter_a_search_rank"),
              FoValidators.integer,
              Validators.maxLength(5)
            ])),
        "stock" : new Control(product.strStock, Validators.compose(
          [
            FoValidators.required(),
            FoValidators.integer,
            Validators.maxLength(7)
          ])),
        "url_name" : new Control(product.urlName, Validators.compose(
            [
              FoValidators.required("enter_a_url_name"),
              FoValidators.alphaNumeric,
              FoValidators.noSpaces,
              Validators.maxLength(32),
              BoValidators.unique("url_name", "product_with_this_url_name_already_exists", productService, product)
            ])),
        "vat" : new Control(product.strVat, Validators.compose(
            [
              FoValidators.required(),
              FoValidators.integer,
              Validators.maxLength(9)
            ])),
        "volume" : new Control(product.strVolume, Validators.compose(
            [
              FoValidators.required(),
              FoValidators.integer,
              Validators.maxLength(7)
            ])),
        "weight" : new Control(product.strWeight, Validators.compose(
            [
              FoValidators.required(),
              FoValidators.integer,
              Validators.maxLength(7)
            ])),
      });

      _populateProductRoutineOptions();
    }

    if (changes.containsKey("productPhrases"))
    {
      updatePhrasesForm();
    }
  }

  Future onImageSourceChange(String source) async
  {
    if (source.isEmpty) product.imageURI = "";
    else product.imageURI = await productService.uploadImage(product.articleNo, source);
  }

  void updatePhrasesForm()
  {

    phrasesForm = new ControlGroup(
    {
      "name" : new Control(productPhrases[selectedLanguage.iso639_1].name, Validators.compose(
      [
        FoValidators.alphaNumeric,
        Validators.maxLength(64)
      ])),
      "description_long" : new Control(productPhrases[selectedLanguage.iso639_1].descriptionLong, Validators.compose(
      [
        Validators.maxLength(1024)
      ])),
      "description_short" : new Control(productPhrases[selectedLanguage.iso639_1].descriptionShort, Validators.compose(
      [
        Validators.maxLength(256)
      ])),
      "usage_instructions" : new Control(productPhrases[selectedLanguage.iso639_1].usageInstructions, Validators.compose(
      [
        Validators.maxLength(512)
      ])),
      "meta_description" : new Control(productPhrases[selectedLanguage.iso639_1].metaDescription, Validators.compose(
      [
        Validators.maxLength(155),
        FoValidators.alphaNumeric
      ])),
      "meta_keywords" : new Control(productPhrases[selectedLanguage.iso639_1].metaKeywords, Validators.compose(
      [
        Validators.maxLength(64)
      ])),
    });
  }

  Future onProductRoutineSave(ProductRoutine routine) async
  {
    if (routine.id == null)
    {
      routine.id = await productRoutineService.push(routine);
      product.productRoutineIds.add(routine.id);
      selectedProductRoutine = routine;
      productRoutineOptions = new StringSelectionOptions<ProductRoutine>(productRoutineOptions.optionsList..add(routine));
    }
    else await productRoutineService.set(routine);

    if (product.id != null) await productService.patch(product, "product_routine_ids");
  }

  Future onProductRoutineDelete(String id) async
  {
    await productRoutineService.remove(id);
    product.productRoutineIds.remove(id);
    productRoutineOptions = new StringSelectionOptions<ProductRoutine>(productRoutineOptions.optionsList..removeWhere((r) => r.id == id));
    selectedProductRoutine = null;

    if (product.id != null) await productService.patch(product, "product_routine_ids");
  }

  Future _populateProductRoutineOptions() async
  {
    List<ProductRoutine> options = ((await productRoutineService.fetchMany(product.productRoutineIds)).values.toList());
    productRoutineOptions = new StringSelectionOptions<ProductRoutine>(options);
  }

  String get detailsSecondaryText => !super.valid ? "required_field_missing" : null;
  String get imageSecondaryText => (product.imageURI == null || product.imageURI.isEmpty) ? "image_must_be_set" : null;

  @override
  bool get valid => super.valid && (phrasesForm != null && phrasesForm.valid);

  ControlGroup phrasesForm;
  Product get product => model;
  ProductService get productService => _service;
  final ProductCategoryService productCategoryService;
  final IngredientService _ingredientService;
  final LanguageService _languageService;
  final ProductRoutineService productRoutineService;
  StringSelectionOptions<Ingredient> ingredientOptions;
  StringSelectionOptions<Product> productOptions;
  StringSelectionOptions<Language> languageOptions;
  StringSelectionOptions<ProductCategory> productCategoryOptions;
  StringSelectionOptions<ProductRoutine> productRoutineOptions;
  Language selectedLanguage;
  ProductRoutine selectedProductRoutine;

  @Input('productPhrases')
  Map<String, ProductPhrases> productPhrases;
}
