import 'dart:async' show Future;
import 'package:http/http.dart' show Response;
import 'package:http/browser_client.dart';
import 'package:angular2/angular2.dart' show Injectable;
import 'package:bokain_models/bokain_models.dart' show PhraseService;

@Injectable()
class MailerService
{
  MailerService(this._phraseService)
  {
  }

  Future<Response> mail(String body, String subject, String to) async
  {
    Response r = await _client.post(_url, body: {"body":body, "subject":subject, "to":to});
    return r;
  }

  String formatDatePronounced(DateTime date)
  {
    return _phraseService.get(
        [
          'weekday_${date.weekday}_pronounced',
          '${date.day}_pronounced',
          'month_${date.month}'
        ]) + " " + date.year.toString();
  }
  String formatHM(DateTime date)
  {
    String hour = (date.hour < 10) ? "0" + date.hour.toString() : date.hour.toString();
    String minute = (date.minute < 10) ? "0" + date.minute.toString() : date.minute.toString();
    return "$hour:$minute";
  }

  final BrowserClient _client = new BrowserClient();
  final PhraseService _phraseService;
  static final String _url = "https://api.bokain.se/mailer.php";
}