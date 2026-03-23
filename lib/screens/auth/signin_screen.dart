import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'forgot_password_screen.dart';
import '../home_screen.dart';
import '../employee_screen.dart';
import '../employee_HrPolicies.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final supabase = Supabase.instance.client;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;

  /// 🔥 toggle (login / signup)
  bool isSignUp = false;

  /// 🔥 LOGIN
  Future<void> login() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      showSnack("Enter email & password ❌", false);
      return;
    }

    setState(() => isLoading = true);

    try {
      await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // 🔥 EMAIL BASED ROLE (MAIN FIX)
      String email = emailController.text.trim();
      String role = '';

      if (email == 'admin@gmail.com') {
        role = 'admin';
      } else if (email == 'hr@gmail.com') {
        role = 'hr';
      } else {
        role = 'employee';
      }

      if (!mounted) return;

      //  NAVIGATION
      if (role == 'admin') {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const HomeScreen()));
      }
      else if (role == 'hr') {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const EmployeeDocumentScreen()));
      }
      else {
        Navigator.push(context,
            MaterialPageRoute(builder: (_) => const EmployeeScreen()));
      }

    } catch (e) {
      showSnack("Invalid email or password ", false);
    }

    setState(() => isLoading = false);
  }
  /// 🔥 SIGNUP
  Future<void> signUp() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      showSnack("Fill all fields ❌", false);
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        data: {
          'name': nameController.text.trim(),
        },
      );

      if (res.user != null) {
        showSnack("Account created ✅", true);
        setState(() => isSignUp = false);
      }
    } catch (e) {
      showSnack("Error: $e", false);
    }

    setState(() => isLoading = false);
  }

  void showSnack(String msg, bool success) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  Widget inputField({
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Column(
      children: [
        TextField(
          controller: controller,
          obscureText: isPassword && !isPasswordVisible,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: isPassword
                ? IconButton(
              icon: Icon(isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            )
                : null,
          ),
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  /// 🔥 FORM (LOGIN / SIGNUP SWITCH)
  Widget buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isSignUp ? "Create account" : "Sign in",
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        Text(isSignUp
            ? "Enter details to create your account"
            : "Enter your credentials to log in"),

        const SizedBox(height: 30),

        /// 👉 NAME (only signup)
        if (isSignUp)
          inputField(
            hint: "Name",
            controller: nameController,
          ),

        inputField(
          hint: "Email",
          controller: emailController,
        ),

        inputField(
          hint: "Password",
          controller: passwordController,
          isPassword: true,
        ),

        if (!isSignUp)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Checkbox(value: false, onChanged: (v) {}),
                  const Text("Remember me"),
                ],
              ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ForgotPasswordScreen(),
                    ),
                  );
                },
                child: const Text("Forgot Password?"),
              ),
            ],
          ),

        const SizedBox(height: 10),

        SizedBox(
          width: double.infinity,
          height: 50,
          child: InkWell(
            onTap: isLoading
                ? null
                : isSignUp
                ? signUp
                : login,
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [
                    Color(0xFFB49B86),
                    Color(0xFF8E7AAE),
                  ],
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                isSignUp ? "Create account" : "Login",
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        Center(
          child: TextButton(
            onPressed: () {
              setState(() {
                isSignUp = !isSignUp;
              });
            },
            child: Text(
              isSignUp
                  ? "Already have an account? Login"
                  : "Don't have an account? Sign up",
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return Scaffold(
      backgroundColor: const Color(0xFFDCE9F1),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: isMobile ? double.infinity : 900,
            height: isMobile ? null : 520,
            margin: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),

            child: isMobile
                ? Column(
              children: [
                Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Color(0xFFE7D9CC),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Center(
                    child: Image.network(
                      "https://cdn-icons-png.flaticon.com/512/4140/4140048.png",
                      height: 120,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: buildForm(),
                ),
              ],
            )
                : Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: buildForm(),
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0xFFE7D9CC),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: Center(
                      child: Image.network(
                        "https://cdn-icons-png.flaticon.com/512/4140/4140048.png",
                        height: 300,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}