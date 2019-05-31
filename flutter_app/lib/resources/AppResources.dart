// String resources
import 'package:flutter_app/core/Resources.dart';

// Router path
class RR {
  static const login = '/login';
  static const main = '/main';
}

// Api URL
class RA {
  static const host = "https://jsonplaceholder.typicode.com";
  static const login = "$host/users/1";

  static posts(int userId) => "$host/posts?userId=$userId";
}

///[RS] String ID
class RS {
  static const app_name = 0;

  static const title = 1;
  static const title_home = 2;
  static const title_detail = 3;

  static const hint_email = 4;
  static const hint_password = 5;

  static const error_login_input = 7;
  static const error_login = 8;

  static const btn_login = 6;
  static const btn_change_language = 9;

  static const tab_home = 10;
  static const tab_user = 11;
  static const tab_default = 12;

  static const title_default = 13;
}

final defaultText = {
  RS.app_name: "Flutter Demo",
  RS.title: "Demo app",
  RS.title_home: "Home Page",
  RS.title_detail: "Detail home",
  RS.hint_email: "Email",
  RS.hint_password: "Password",
  RS.btn_login: "Login",
  RS.error_login_input: "Username or password can not be empty",
  RS.error_login: "Login fail",
  RS.btn_change_language: "Change Language",
  RS.tab_home: "Home",
  RS.tab_user: "User",
  RS.tab_default: "Default",
  RS.title_default: "This is default fragment",
};

final vnText = {
  RS.app_name: "Ứng dụng thử - Flutter",
  RS.title: "Ứng dụng chạy thử",
  RS.title_home: "Trang chủ",
  RS.title_detail: "Chi tiết trang chủ",
  RS.hint_email: "Tài khoản",
  RS.hint_password: "Mật khẩu",
  RS.btn_login: "Đăng nhập",
  RS.error_login_input: "Tài khoản hoặc mật khẩu không được để trống",
  RS.error_login: "Đăng nhập lỗi, thử lại!",
  RS.btn_change_language: "Thay đổi ngôn ngữ",
  RS.tab_home: "Trang chủ",
  RS.tab_user: "Người dùng",
  RS.tab_default: "Mặc định",
  RS.title_default: "Màn hình mặc định",
};

/// [RD] Dimension ID
class RD {
  static const size_2 = 1;
  static const size_10 = 2;
  static const size_50 = 3;
  static const text_size_18 = 4;
}

final defaultDimen = <int, double>{
  RD.size_10: 10.0,
  RD.size_2: 2.0,
  RD.size_50: 50.0,
  RD.text_size_18: 18,
};

class SupportLanguage {
  static const VN = "vn";
  static const EN = "en";
}

class AppResources extends Resources {
  @override
  Map<int, String> getTextConfig(String language) {
    switch (language.toLowerCase()) {
      case SupportLanguage.VN:
        return vnText;
      default:
        return defaultText;
    }
  }

  @override
  Map<int, double> getDimenConfig(String dimenStyle) {
    switch (dimenStyle.toLowerCase()) {
      default:
        return defaultDimen;
    }
  }
}
