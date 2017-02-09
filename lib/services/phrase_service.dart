import 'package:angular2/core.dart';

@Injectable()
class PhraseService
{
  PhraseService();

  String get(List<String> phrase_keys, { Map<String, String> params : null, String separator : " ", bool capitalize_first : true})
  {
    List<String> phraseValues = new List();
    for (String key in phrase_keys)
    {
      if (key == null) return "";
      key = key.toLowerCase();
      if (_phraseData.containsKey(key))
      {
        params?.forEach((paramName, paramVal)
        {
          _phraseData[key] = _phraseData[key].replaceAll("%$paramName%", paramVal);
        });

        phraseValues.add(_phraseData[key]);
      }
      else phraseValues.add(key);
    }
    String phrase = phraseValues.join(separator);
    if (capitalize_first == true) phrase = phrase[0].toUpperCase() + phrase.substring(1, phrase.length);

    return phrase;
  }

  final Map<String, String> _phraseData =
  {
    "active" : "aktiv",
    "add" : "lägg till",
    "at" : "på",
    "belongs_to" : "tillhör",
    "bookable_plural" : "bokningsbara",
    "booking_details" : "bokningsinformation",
    "booking_history" : "bokningshistorik",
    "bookings_only" : "enbart bokningar",
    "break" : "rast",
    "calendar" : "kalender",
    "cancel" : "avbryt",
    "city" : "stad",
    "close" : "stäng",
    "confirm" : "bekräfta",
    "confirm_save" : "du har osparade ändringar, tryck OK för att spara eller AVBRYT för att ignorera ändringarna",
    "comments_external" : "kommentarer (externa)",
    "comments_internal" : "kommentarer (interna)",
    "country" : "land",
    "country_gb" : "storbritannien",
    "country_se" : "sverige",
    "customer" : "kund",
    "customers" : "kunder",
    "customer_add" : "lägg till kund",
    "customer_details" : "kunduppgifter",
    "dashboard" : "dashboard",
    "disabled" : "inaktiverad",
    "edit" : "redigera",
    "email" : "e-post",
    "error_occured" : "ett fel inträffade",
    "friday" : "fredag",
    "information" : "information",
    "firstname" : "förnamn",
    "frozen" : "fryst",
    "function" : "funktion",
    "language" : "språk",
    "language_en" : "engelska",
    "language_sv" : "svenska",
    "lastname" : "efternamn",
    "login" : "logga in",
    "monday" : "måndag",
    "none" : "inget",
    "only" : "enbart",
    "open" : "öppna",
    "order_history" : "orderhistorik",
    "password" : "lösenord",
    "phone" : "telefonnummer",
    "postal_code" : "postnummer",
    "saturday" : "lördag",
    "save" : "spara",
    "schedule" : "schema",
    "selection_state" : "markeringsläge",
    "send_email_notification" : "skicka e-post notifikation",
    "sick" : "sjuk",
    "skin_consultation" : "hudkonsultation",
    "skin_type" : "hudtyp",
    "skin_type_acne" : "akne",
    "skin_type_aging" : "åldrande",
    "skin_type_combination_skin" : "blandhy",
    "skin_type_oily" : "fet hy",
    "skin_type_sensitive" : "känslig hy",
    "skin_type_milia" : "milier",
    "skin_type_normal" : "normal hy",
    "skin_type_pigmentation" : "pigmentfläckar",
    "skin_type_comedones" : "pormaskar",
    "skin_type_rosacea" : "rosacea",
    "skin_type_seborrhea" : "seborré",
    "skin_type_sun_damaged" : "solskadad hy",
    "skin_type_dry" : "torr hy",
    "social_number" : "personnummer",
    "street" : "gatuadress",
    "sunday" : "söndag",
    "thursday" : "torsdag",
    "time" : "tid",
    "times" : "tider",
    "tuesday" : "tisdag",
    "user" : "användare",
    "user_add" : "lägg till användare",
    "user_details" : "användaruppgifter",
    "users" : "användare",
    "wednesday" : "onsdag",
    "week" : "vecka",
    "_could_not_save_model" : "kunde inte spara %model%.",
    "_unique_database_value_exists" : "ett objekt med detta värde finns redan registrerat",
    "_Error: The email address is already in use by another account." : "Det finns redan en användare med denna e-post.",
    "_Error: Password should be at least 6 characters" : "Lösenordet måste innehålla minst 6 tecken",
  };
}