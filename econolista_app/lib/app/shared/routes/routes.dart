import '../../modules/splash/splash.dart';
import '../../modules/login/login.dart';
import '../../modules/home/home_page.dart';
//import '../../modules/purchase_details/purchase_details.dart';

final applicationRoutes = {
  '/splash': (_) => const Splash(),
  '/login': (_) => const Login(),
  '/home': (_) => const HomePage(),
  //'/purchase_details': (_) => const PurchaseDetails(),
};
