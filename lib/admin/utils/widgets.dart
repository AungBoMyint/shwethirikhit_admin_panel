import 'package:flutter/material.dart';

import '../controller/admin_login_controller.dart';

textFieldErrorBorder(bool hasError, AdminLoginController alController,
        BuildContext context) =>
    OutlineInputBorder(
        borderSide: BorderSide(
      color: hasError
          ? Colors.red
          : alController.isLightTheme.value
              ? Theme.of(context).dividerColor
              : Colors.grey.shade100,
    ));
