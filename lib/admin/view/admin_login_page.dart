import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constant/icon.dart';
import '../../routes.dart';
import '../controller/admin_login_controller.dart';
import '../utils/func.dart';
import '../utils/space.dart';
import 'forget_password_page.dart';

class AdminLoginPage extends GetView<AdminLoginController> {
  const AdminLoginPage({super.key});

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
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(
            flex: 6,
            child: Image.asset(
              AdminIcon.adminLoginImage,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            flex: 4,
            child: Container(
              color: Theme.of(context).cardTheme.color,
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(child: SizedBox()),
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
                      "Welcome to DehatFresh Admin! 👋",
                      style: GoogleFonts.inter(
                        color: Theme.of(context).textTheme.displaySmall?.color,
                        fontSize: 20,
                      ),
                    ),
                    verticalSpace(),
                    Text(
                      "Please sign-in to your admin account.",
                      style: GoogleFonts.inter(
                        color: Colors.grey,
                        fontSize: 20,
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                    //FORM
                    Align(
                      alignment: Alignment.center,
                      child: Obx(() {
                        final isPressed = controller.isFirstTimePressed.value;
                        return Form(
                          key: controller.formKey,
                          autovalidateMode: isPressed
                              ? AutovalidateMode.onUserInteraction
                              : AutovalidateMode.disabled,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //email address
                                SizedBox(
                                  child: TextFormField(
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayMedium,
                                    validator: (v) => validateEmail(v),
                                    controller: controller.emailController,
                                    decoration: InputDecoration(
                                      border: dropDownBorder(),
                                      disabledBorder: dropDownBorder(),
                                      focusedBorder: dropDownBorder(),
                                      enabledBorder: dropDownBorder(),
                                      labelText: "Email",
                                      labelStyle: labelStyle,
                                      floatingLabelStyle:
                                          floatingLabelStyle, // color of active label text
                                    ),
                                  ),
                                ),
                                verticalSpace(),
                                //password
                                SizedBox(
                                  child: Obx(() {
                                    final isObscure =
                                        controller.isObscure.value;
                                    return TextFormField(
                                      style: Theme.of(context)
                                          .textTheme
                                          .displayMedium,
                                      obscureText: isObscure,
                                      validator: (v) =>
                                          controller.validator(v, "Password"),
                                      controller: controller.passwordController,
                                      decoration: InputDecoration(
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            isObscure
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                          ),
                                          onPressed: () =>
                                              controller.changeObscure(),
                                        ),
                                        border: dropDownBorder(),
                                        disabledBorder: dropDownBorder(),
                                        focusedBorder: dropDownBorder(),
                                        enabledBorder: dropDownBorder(),
                                        labelText: "Password",
                                        labelStyle: labelStyle,
                                        floatingLabelStyle:
                                            floatingLabelStyle, // color of active label text
                                        // color of active label text
                                      ),
                                    );
                                  }),
                                ),
                                verticalSpace(v: 10),
                              ]),
                        );
                      }),
                    ),
                    //Remember me Forget password
                    SizedBox(
                      height: 50,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          /* SizedBox(
                            height: 50,
                            width: 200,
                            child: */
                          Expanded(
                            child: Obx(() {
                              return CheckboxListTile(
                                contentPadding: EdgeInsets.zero,
                                controlAffinity:
                                    ListTileControlAffinity.leading,
                                title: Text("Remember Me",
                                    style: GoogleFonts.inter(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    )),
                                value: controller.rememberMe.value,
                                onChanged: (v) => controller.changeRememberMe(),
                              );
                            }),
                          ),
                          TextButton(
                              onPressed: () =>
                                  Get.toNamed(adminPasswordResetRoute),
                              child: Text("Forget Password?",
                                  style: textTheme.displayMedium?.copyWith(
                                    color: Colors.blue,
                                  ))),
                        ],
                      ),
                    ),
                    verticalSpace(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => controller.signIn(),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "SIGN IN",
                            style: GoogleFonts.inter(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Expanded(child: SizedBox()),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
