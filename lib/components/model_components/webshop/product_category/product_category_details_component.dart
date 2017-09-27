// Copyright (c) 2017, BuyByMarcus.ltd. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

part of details_component_base;

@Component(
    selector: 'bo-product-category-details',
    templateUrl: '../webshop/product_category/product_category_details_component.html',
    styleUrls: const ['../webshop/product_category/product_category_details_component.css'],
    directives: const
    [
      CORE_DIRECTIVES,
      formDirectives,
      FoSelectComponent,
      materialDirectives,
      FoImageFileComponent,
      StatusSelectComponent
    ],
    pipes: const [PhrasePipe]
)
class ProductCategoryDetailsComponent extends DetailsComponentBase implements OnChanges
{
  ProductCategoryDetailsComponent(ProductCategoryService service, this._languageService) : super(service)
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
            "name" : new Control(productCategory.name, Validators.compose(
            [
              FoValidators.required("enter_a_name"),
              FoValidators.alphaNumeric,
              FoValidators.noSpaces,
              Validators.maxLength(32),
              BoValidators.unique("name", "product_category_with_this_article_no_already_exists", productCategoryService, productCategory)
            ])),
            "url_name": new Control(productCategory.urlName, Validators.compose(
            [
              FoValidators.required("enter_a_url_name"),
              FoValidators.alphaNumeric,
              FoValidators.noSpaces,
              Validators.maxLength(32),
            ])),
            "search_rank" : new Control(productCategory.strSearchRank, Validators.compose(
            [
              FoValidators.required("enter_a_search_rank"),
              FoValidators.integer,
              Validators.maxLength(8)
            ])),
          });
    }

    if (changes.containsKey("productCategoryPhrases"))
    {
      updatePhrasesForm();
    }
  }

  Future onImageSourceChange(String source) async
  {
    if (source.isEmpty) productCategory.imageURI = "";
    else productCategory.imageURI = await productCategoryService.uploadImage(productCategory.name, source);
  }

  void updatePhrasesForm()
  {
    phrasesForm = new ControlGroup(
    {
      "name" : new Control(productCategoryPhrases[selectedLanguage.iso639_1].name, Validators.compose(
      [
        FoValidators.alphaNumeric,
        Validators.maxLength(32)
      ])),
      "description" : new Control(productCategoryPhrases[selectedLanguage.iso639_1].description, Validators.compose(
      [
        Validators.maxLength(1024)
      ])),
      "meta_description" : new Control(productCategoryPhrases[selectedLanguage.iso639_1].metaDescription, Validators.compose(
      [
        Validators.maxLength(155),
        FoValidators.alphaNumeric
      ])),
      "meta_keywords" : new Control(productCategoryPhrases[selectedLanguage.iso639_1].metaKeywords, Validators.compose(
      [
        Validators.maxLength(64)
      ])),
    });
  }

  String get imageSecondaryText => (productCategory.imageURI == null || productCategory.imageURI.isEmpty) ? "image_must_be_set" : null;

  @override
  bool get valid => super.valid && (phrasesForm != null && phrasesForm.valid);

  ControlGroup phrasesForm;
  ProductCategory get productCategory => model;
  ProductCategoryService get productCategoryService => _service;
  final LanguageService _languageService;
  StringSelectionOptions<Language> languageOptions;
  Language selectedLanguage;

  @Input('productCategoryPhrases')
  Map<String, ProductCategoryPhrases> productCategoryPhrases;
}
