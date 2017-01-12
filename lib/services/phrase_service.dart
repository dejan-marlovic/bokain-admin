import 'package:angular2/core.dart';

@Injectable()
class PhraseService
{
  PhraseService();

  String get(List<String> phrase_keys, { List<String> params : null, String separator : " ", bool capitalize_first : true})
  {
    List<String> phraseValues = new List();
    for (String key in phrase_keys)
    {
      if (_phraseData.containsKey(key)) phraseValues.add(_phraseData[key]);
      else phraseValues.add(key);
    }
    String phrase = phraseValues.join(separator);
    if (capitalize_first == true) phrase = phrase[0].toUpperCase() + phrase.substring(1, phrase.length);

    return phrase;
  }

  final Map<String, String> _phraseData =
  {
    "dashboard" : "dashboard",
    "email" : "e-post",
    "login" : "logga in",
    "password" : "lösenord",
  };
}