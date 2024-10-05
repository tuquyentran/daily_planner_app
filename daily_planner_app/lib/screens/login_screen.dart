import 'package:daily_planner_app/models/api_service.dart';
import 'package:daily_planner_app/models/user.dart';
import 'package:flutter/material.dart';
import 'main_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  List<User> users = [];
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscureText = true;
  final ApiService apiService = ApiService();
  final _formKey = GlobalKey<FormState>();

  // Add a state variable to track login error
  String? _loginError;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Image.asset(
            'assets/images/dailyplanner.png',
            height: 150,
          ),
          LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: IntrinsicHeight(
                    child: Padding(
                      padding: EdgeInsets.only(top: screenHeight / 5),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(177, 138, 215, 0.612),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(25.0),
                          child: Center(
                            child: Column(
                              children: [
                                // login error message
                                if (_loginError != null)
                                  Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 16.0),
                                    child: Text(
                                      _loginError!,
                                      style: const TextStyle(
                                        color: Color.fromARGB(255, 205, 0, 0),
                                        fontSize: 16.0,
                                      ),
                                    ),
                                  ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      //text field email
                                      TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: _emailController,
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.white,
                                          prefixIcon: Icon(
                                            Icons.email,
                                            color:
                                                Color.fromRGBO(83, 13, 126, 10),
                                          ),
                                          labelText: 'Email',
                                        ),
                                        validator: (value) {
                                          return validateEmail(value);
                                        },
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      //text field pass
                                      TextFormField(
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        controller: _passwordController,
                                        obscureText: _obscureText,
                                        decoration: InputDecoration(
                                          labelText: 'Password',
                                          border: const OutlineInputBorder(),
                                          filled: true,
                                          fillColor: Colors.white,
                                          prefixIcon: const Icon(
                                            Icons.lock,
                                            color:
                                                Color.fromRGBO(83, 13, 126, 10),
                                          ),
                                          suffixIcon: GestureDetector(
                                            onTap: () {
                                              onObscureText();
                                            },
                                            child: Icon(
                                              _obscureText
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: const Color.fromRGBO(
                                                  83, 13, 126, 10),
                                            ),
                                          ),
                                        ),
                                        validator: (value) {
                                          return validatePassword(value);
                                        },
                                      ),
                                      const SizedBox(
                                        height: 60,
                                      ),
                                      //btn login
                                      InkWell(
                                        onTap: () {
                                          onLoginClick();
                                        },
                                        child: Container(
                                          height: 50,
                                          decoration: BoxDecoration(
                                            color: const Color.fromRGBO(
                                                83, 13, 126, 10),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Log In',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 30,
                                      ),
                                      const Row(
                                        children: [
                                          Expanded(
                                            child: Divider(
                                              thickness: 0.5,
                                              color: Color.fromRGBO(
                                                  83, 13, 126, 10),
                                            ),
                                          ),
                                          Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 10),
                                              child: Text(
                                                'OR',
                                                style: TextStyle(
                                                    color: Color.fromRGBO(
                                                        83, 13, 126, 10)),
                                              )),
                                          Expanded(
                                            child: Divider(
                                              thickness: 0.5,
                                              color: Color.fromRGBO(
                                                  83, 13, 126, 10),
                                            ),
                                          ),
                                        ],
                                      ),
                                      IconButton(
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.email,
                                          color:
                                              Color.fromRGBO(83, 13, 126, 10),
                                        ),
                                        iconSize: 30,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

//validate email
  String? validateEmail(String? value) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value!);
    if (value.isEmpty) {
      return 'Please enter email';
    } else if (!emailValid) {
      return 'Enter valid email';
    }
    return null;
  }

  //validate password
  String? validatePassword(String? value) {
    bool passwordValid =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*.]).{8,}$')
            .hasMatch(value!);
    if (value.isEmpty) {
      return 'Please enter password';
    } else if (!passwordValid) {
      return 'Enter valid password';
    }
    return null;
  }

  void onObscureText() {
    setState(
      () {
        _obscureText = !_obscureText;
      },
    );
  }

  Future<void> onLoginClick() async {
  if (_formKey.currentState!.validate()) {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    try {
      User? user = await apiService.loginUser(email, password);
      if (user != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(user: user),
          ),
        );
      } 
    } catch (e) {
      print('Error logging in: $e');
      setState(() {
        _loginError = 'Error logging in. Please try again.';
      });
    }
  }
}
}
