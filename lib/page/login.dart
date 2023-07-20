import 'package:chat_im/utils/keyboard_hide_widget.dart';
import 'package:chat_im/utils/toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../model/login_data.dart';
import '../route/router.dart';
import '../viewmodel/login_view_model.dart';

class Login extends ConsumerStatefulWidget {
  const Login({super.key});

  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {
  //是否顯示輸入框的密碼
  bool isShowPwd = false;
  TextEditingController accountController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //註冊聊天室房間的provider
  final userProvider = ChangeNotifierProvider<LoginViewModel>((ref) => LoginViewModel());

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    accountController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  //設置是否顯示或隱藏密碼
  void setPwdVisible() {
    setState(() {
      isShowPwd = !isShowPwd;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: KeyboardHideWidget(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/img/login_bg.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.all(10.w),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  "assets/img/logo.jpg",
                  width: 100,
                  height: 100,
                ),
                //帳號輸入框
                TextField(
                  controller: accountController,
                  keyboardType: TextInputType.text,
                  maxLines: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]')), // 只允许输入英文字母和数字
                  ],
                  decoration: const InputDecoration(
                    hintText: "帳號",
                  ),
                ),
                //密碼輸入框
                TextField(
                  controller: passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: !isShowPwd,
                  enableSuggestions: false,
                  autocorrect: false,
                  maxLines: 1,
                  decoration: InputDecoration(
                    hintText: "密碼",
                    suffixIcon: GestureDetector(
                      onTap: () {
                        setPwdVisible();
                      },
                      child: Icon(
                        isShowPwd ? Icons.visibility : Icons.visibility_off,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.w,
                ),
                ElevatedButton(
                  child: Text(
                    '登入',
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.white,
                    ),
                  ),
                  onPressed: () async {
                    String account = accountController.text;
                    String password = passwordController.text;

                    if (account.isEmpty) {
                      showToast("請輸入帳號");
                      return;
                    }
                    if (password.isEmpty) {
                      showToast("請輸入密碼");
                      return;
                    }

                    LoginData loginResult = await ref.read(userProvider.notifier).login(account, password);
                    print(loginResult.success);
                    if (loginResult.success == true) {
                      Application.router.navigateTo(context, Routers.chatList, clearStack: true);
                    } else {
                      showDialog(context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('登入失敗'),
                              content: Text('請檢查帳號和密碼是否正確'),
                              actions: [
                                TextButton(
                                  child: Text('確定'),
                                  onPressed: () {
                                    Navigator.of(context).pop(); // 關閉對話框
                                  },
                                ),
                              ],
                            );
                          });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
