import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/icon.dart';
import '../../routes.dart';
import '../controller/admin_login_controller.dart';
import '../controller/password_reset_controller.dart';
import '../utils/space.dart';

class ForgetPasswordPage extends GetView<PasswordResetController> {
  const ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AdminLoginController alController = Get.find();
    final textTheme = Theme.of(context).textTheme;
    dropDownBorder() => OutlineInputBorder(
            borderSide: BorderSide(
          color: alController.isLightTheme.value
              ? Theme.of(context).dividerColor
              : Colors.grey.shade100,
        ));
    var labelStyle = textTheme.displayMedium?.copyWith(
      color:
          alController.isLightTheme.value ? Colors.grey : Colors.grey.shade300,
    );
    var floatingLabelStyle = textTheme.displayMedium?.copyWith(
      color:
          alController.isLightTheme.value ? Colors.grey : Colors.grey.shade300,
    );
    return Scaffold(
        body: SafeArea(
            child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: Image.asset(
            AdminIcon.adminForgetPassword,
            fit: BoxFit.contain,
          ),
        ),
        Expanded(
          flex: 4,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //Logo And Text
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SvgPicture.asset(
                    AdminIcon.nuclear,
                    width: 30,
                    height: 30,
                    color: Theme.of(context).iconTheme.color,
                  ),
                  title: Text(
                    "DehatFresh",
                    style: textTheme.displayLarge?.copyWith(
                      fontSize: 25,
                    ),
                  ),
                ),
                verticalSpace(),
                //Welcome
                Text(
                  "Forget Password? 🔐",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 20,
                  ),
                ),
                verticalSpace(v: 10),
                Text(
                  "Enter your email and we′ll send you instructions to reset your password",
                  style: GoogleFonts.inter(
                    color: Colors.grey,
                    fontSize: 20,
                  ),
                ),
                verticalSpace(),
                Obx(() {
                  final isPressed = controller.isFirstTimePressed.value;
                  return Form(
                    key: controller.formKey,
                    autovalidateMode: isPressed
                        ? AutovalidateMode.onUserInteraction
                        : AutovalidateMode.disabled,
                    child: SizedBox(
                      child: TextFormField(
                        validator: (v) => controller.validator(v, "Email"),
                        controller: controller.emailController,
                        decoration: InputDecoration(
                          border: dropDownBorder(),
                          disabledBorder: dropDownBorder(),
                          focusedBorder: dropDownBorder(),
                          enabledBorder: dropDownBorder(),
                          labelText: "Email",
                          floatingLabelStyle: const TextStyle(
                            color: Colors.black, // color of active label text
                          ),
                        ),
                      ),
                    ),
                  );
                }),
                verticalSpace(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => controller.resetPassword(),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "SEND RESET LINK",
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Align(
                    alignment: Alignment.center,
                    child: TextButton(
                      onPressed: () => Get.toNamed(adminLoginRoute),
                      child: Text("< Back to login",
                          style: textTheme.displayMedium?.copyWith(
                            color: Colors.blue,
                          )),
                    ))
              ],
            ),
          ),
        )
      ],
    )));
  }
}
