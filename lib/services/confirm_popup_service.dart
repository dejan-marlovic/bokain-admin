import 'package:angular2/core.dart';

typedef void confirmCallback();

@Injectable()
class ConfirmPopupService
{
  ConfirmPopupService();

  void onConfirmInternal()
  {
    if (onConfirm != null) onConfirm();
    title = message = onConfirm = onCancel = null;
  }

  void onCancelInternal()
  {
    if (onCancel != null) onCancel();
    title = message = onConfirm = onCancel = null;
  }


  String title;
  String message;
  confirmCallback onConfirm;
  confirmCallback onCancel;
}