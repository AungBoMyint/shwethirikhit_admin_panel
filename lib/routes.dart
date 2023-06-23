import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'admin/bin/admin_bin.dart';
import 'admin/bin/password_reset_binding.dart';
import 'admin/view/admin_login_page.dart';
import 'admin/view/admin_main_screen.dart';
import 'admin/view/forget_password_page.dart';
import 'admin/view/user/user_profile_page.dart';
import 'admin/view/user_profile_page.dart';
import 'constant/data.dart';

const initialRoute = "/";
const loginRoute = "/login";
const adminLoginRoute = "/admin_login";
const adminPasswordResetRoute = "/admin_password_reset";
const phoneLoginRoute = "/phone_login_route";
const verifyPhoneCodeRoute = "/verify_phone_code";
const pizzaOrderRoute = "/pizza_order";
const adminRoute = "/admin";
const checkOutScreen = '/checkout';
const manageDivisionRoute = "/manage_division";
const locationNotFoundRoute = "/location_not_found";
const locationSearchRoute = "/location_search";
const adminMainRoute = "/admin_main_route";
const userProfilePage = "/user_profile_page";

String getInitialRoute() {
  final box = Hive.box(loginBox);
  if (box.get(isAuthenticatedKey, defaultValue: false) == false) {
    return adminLoginRoute; /* loginRoute; */
  } else {
    return adminMainRoute;
  }
}

// We use name route
// All our routes will be available here
List<GetPage> routes = [
  GetPage(
    name: adminMainRoute,
    binding: AdminBinding(),
    page: () => const AdminMainScreen(),
  ),
  GetPage(
    name: adminLoginRoute,
    page: () => const AdminLoginPage(),
  ),
  GetPage(
    name: userProfilePage,
    page: () => const UserProfilePage(),
  ),
  GetPage(
    name: adminPasswordResetRoute,
    binding: PasswordResetBining(),
    page: () => const ForgetPasswordPage(),
  ),
];
