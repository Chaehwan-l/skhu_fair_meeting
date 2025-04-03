import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  KakaoSdk.init(nativeAppKey:'9255023b3d9eebeecb1887c7ec03991d'); // ← 실제 키 입력
  runApp(const FairMeetingApp());
}

class FairMeetingApp extends StatelessWidget {
  const FairMeetingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fair Meeting',
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController pwController = TextEditingController();
  bool stayLoggedIn = false;

  void handleLogin() {
    final id = idController.text;
    final pw = pwController.text;

    // TODO: 로그인 정보 DB로 저장 로직 추가
    print('ID: $id, PW: $pw');
  }

  Future<void> kakaoLogin() async {
    try {
      OAuthToken token;

      if (await isKakaoTalkInstalled()) {
        token = await UserApi.instance.loginWithKakaoTalk();
      } else {
        token = await UserApi.instance.loginWithKakaoAccount();
      }

      final user = await UserApi.instance.me();
      print('카카오 로그인 성공: ${user.kakaoAccount?.email}');
    } catch (e) {
      print('카카오 로그인 실패: $e');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // 전체 배경 하얗게
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              const Center(
                child: Column(
                  children: [
                    Text(
                      'FAIR',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD9C189),
                      ),
                    ),
                    Text(
                      'MEETING',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFD9C189),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person),
                  hintText: '아이디',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: pwController,
                obscureText: true,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.lock),
                  hintText: '비밀번호',
                  border: OutlineInputBorder(),
                ),
              ),
              Row(
                children: [
                  Checkbox(
                    value: stayLoggedIn,
                    onChanged: (value) {
                      setState(() {
                        stayLoggedIn = value!;
                      });
                    },
                  ),
                  const Text('로그인 상태 유지'),
                ],
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD9C189),
                  foregroundColor: Colors.white,
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                ),
                child: const Text('로그인', style: TextStyle(fontSize: 18)),
              ),
              const SizedBox(height: 12),
              const Text(
                '아이디 찾기 | 비밀번호 찾기 | 회원가입',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  kakaoLogin();
                  // print('카카오톡 로그인 클릭됨');
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white, // ✅ 흰색 배경으로 수정
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image.asset('assets/kakaoOauth.png', height: 24),
                      const SizedBox(width: 8),
                      const Text(
                        '카카오톡으로 로그인',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  // TODO: 네이버 Oauth 연동 로직
                  print('네이버 로그인 클릭됨');
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey.shade300),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Image.asset('assets/naverOauth.png', height: 24),
                      const SizedBox(width: 8),
                      const Text(
                        '네이버로 로그인',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              /*
              SignInButton(
                Buttons.Kakao,
                onPressed: () {
                  // TODO: 카카오톡 Oauth 로그인 연동
                },
                text: '카카오톡으로 로그인',
              ),
              const SizedBox(height: 8),
              SignInButton(
                Buttons.Naver,
                onPressed: () {
                  // TODO: 네이버 Oauth 로그인 연동
                },
                text: '네이버로 로그인',
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
