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
      FoSelectComponent,
      materialDirectives,
      FoImageFileComponent,
      StatusSelectComponent
    ],
    pipes: const [PhrasePipe]
)
class ProductDetailsComponent extends DetailsComponentBase implements OnChanges
{
  ProductDetailsComponent(ProductService service, this.productCategoryService, this._languageService) : super(service)
  {
    languageOptions = new StringSelectionOptions(_languageService.cachedModels.values.toList(growable: false));
    selectedLanguage = _languageService.cachedModels.values.first;

    productCategoryOptions = new StringSelectionOptions(productCategoryService.cachedModels.values.toList(growable: false));
  }

  void ngOnChanges(Map<String, SimpleChange> changes)
  {
    if (changes.containsKey("model"))
    {
      form = new ControlGroup(
      {
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

  String get imageSecondaryText => (product.imageURI == null || product.imageURI.isEmpty) ? "image_must_be_set" : null;

  @override
  bool get valid => super.valid && (phrasesForm != null && phrasesForm.valid);

  ControlGroup phrasesForm;
  Product get product => model;
  ProductService get productService => _service;
  final ProductCategoryService productCategoryService;
  final LanguageService _languageService;
  StringSelectionOptions<Language> languageOptions;
  StringSelectionOptions<ProductCategory> productCategoryOptions;
  Language selectedLanguage;

  @Input('productPhrases')
  Map<String, ProductPhrases> productPhrases;
}
