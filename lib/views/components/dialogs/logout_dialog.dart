import 'package:flutter/foundation.dart' show immutable;
import 'package:global_gallery/views/components/constants/strings.dart';
import 'package:global_gallery/views/components/dialogs/alert_dialog_model.dart';

@immutable
class LogoutDialog extends AlertDialogModel<bool> {
  LogoutDialog()
      : super(
            title: Strings.logOut,
            message: Strings.areYouSureThatYouWantToLogOutOfTheApp,
            buttons: {
              Strings.logOut: true,
              Strings.cancel: false,
            });
}
