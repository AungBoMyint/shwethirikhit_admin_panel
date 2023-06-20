import 'package:flutter/material.dart';
import 'package:pizza/admin/utils/space.dart';

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

class CreateButton extends StatelessWidget {
  const CreateButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  final String title;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
          const Icon(
            Icons.add,
            color: Colors.white,
          ),
          horizontalSpace(v: 15),
          Text(
            title,
            style: textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ]),
      ),
    );
  }
}

dropDownBorder() => const OutlineInputBorder(
        borderSide: BorderSide(
      color: Colors.black,
    ));
