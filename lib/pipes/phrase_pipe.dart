import 'package:angular2/di.dart' show Pipe, PipeTransform;
import 'package:bokain_models/bokain_models.dart' show PhraseService;

@Pipe("phrase")
class PhrasePipe implements PipeTransform
{
  PhrasePipe(this._phraseService);

  String transform(String value, [Map<String, String> params = null])
  {
    return _phraseService.get([value], params: params);
  }

  final PhraseService _phraseService;
}