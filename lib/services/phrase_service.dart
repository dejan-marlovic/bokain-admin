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
      String value = key = key.toLowerCase();

      if (_phraseData.containsKey(key))
      {
        value = _phraseData[key];
        params?.forEach((paramName, paramVal)
        {
          value = value.replaceAll("%$paramName%", paramVal);
        });
      }
      phraseValues.add(value);
    }
    String phrase = phraseValues.join(separator);
    if (capitalize_first == true) phrase = phrase[0].toUpperCase() + phrase.substring(1, phrase.length);

    return phrase;
  }

  final Map<String, String> _phraseData =
  {
    "active" : "aktiv",
    "add" : "lägg till",
    "addon_services" : "tilläggstjänster",
    "associate" : "anslut",
    "associated" : "ansluten",
    "associated_plural" : "anslutna",
    "at" : "på",
    "belongs_to" : "tillhör",
    "bookable_plural" : "bokningsbara",
    "booking_details" : "bokningsinformation",
    "booking_history" : "bokningshistorik",
    "booking_plural" : "bokningar",
    "bookings_only" : "enbart bokningar",
    "break" : "rast",
    "calendar" : "kalender",
    "cancel" : "avbryt",
    "category" : "kategori",
    "city" : "stad",
    "close" : "stäng",
    "confirm" : "bekräfta",
    "confirm_remove" : "bekräfta borttagning av objekt",
    "confirm_save" : "du har osparade ändringar, tryck OK för att spara eller AVBRYT för att ignorera ändringarna",
    "comments_external" : "kommentarer (externa)",
    "comments_internal" : "kommentarer (interna)",
    "country" : "land",
    "country_gb" : "storbritannien",
    "country_se" : "sverige",
    "currency_sek" : "kr",
    "customer" : "kund",
    "customer_plural" : "kunder",
    "customer_details" : "kunduppgifter",
    "dashboard" : "dashboard",
    "delete" : "ta bort",
    "description" : "beskrivning",
    "details" : "uppgifter",
    "disabled" : "inaktiverad",
    "duration" : "varaktighet",
    "edit" : "redigera",
    "email" : "e-post",
    "email_pronounced" : "denna e-post",
    "error_occured" : "ett fel inträffade",
    "friday" : "fredag",
    "in_minutes" : "(minuter)",
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
    "name" : "namn",
    "name_pronounced" : "detta namn",
    "new_room" : "nytt rum",
    "none" : "inget",
    "not" : "ej",
    "only" : "enbart",
    "open" : "öppna",
    "order_history" : "orderhistorik",
    "password" : "lösenord",
    "phone" : "telefonnummer",
    "postal_code" : "postnummer",
    "price" : "pris",
    "room" : "rum",
    "room_plural" : "rum",
    "room_pronounced" : "detta rum",
    "salon" : "salong",
    "salon_details" : "salongens uppgifter",
    "salon_plural" : "salonger",
    "saturday" : "lördag",
    "save" : "spara",
    "schedule" : "schema",
    "search" : "sök",
    "selection_state" : "markeringsläge",
    "send_email_notification" : "skicka e-post notifikation",
    "service" : "tjänst",
    "service_details" : "tjänstens uppgifter",
    "service_plural" : "tjänster",
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
    "social_number_pronounced" : "detta personnummer",
    "street" : "gatuadress",
    "sunday" : "söndag",
    "thursday" : "torsdag",
    "time" : "tid",
    "times" : "tider",
    "tuesday" : "tisdag",
    "user" : "användare",
    "user_plural" : "användare",
    "user_details" : "användaruppgifter",
    "warning" : "varning",
    "wednesday" : "onsdag",
    "week" : "vecka",
    "_could_not_save_model" : "Kunde inte spara %model%.",
    "_delete_are_you_sure" : "Är du säker på att du vill ta bort %model%? Operationen går inte att ångra.",
    "_unique_database_value_exists" : "Det finns redan ett objekt med %property_pronounced% i systemet",
    "_Error: The email address is already in use by another account." : "Det finns redan en användare med denna e-post.",
    "_Error: Password should be at least 6 characters" : "Lösenordet måste innehålla minst 6 tecken",
  };
}