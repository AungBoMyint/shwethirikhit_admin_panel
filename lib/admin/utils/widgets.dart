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

// ignore: must_be_immutable
class FirebaseSnapHelper<T> extends StatelessWidget {
  FirebaseSnapHelper({
    super.key,
    required this.future,
    required this.onSuccess,
  });

  Future<T> future;
  Function(T) onSuccess;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
        future: future,
        builder: (context, AsyncSnapshot<T> snap) {
          if (snap.hasError) {
            debugPrint("Something was wrong");
            return ErrorWidget("Something was wrong!");
          }
          if (snap.hasData) {
            return onSuccess(snap.data!);
          }
          return SizedBox(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          );
        });
  }
}
