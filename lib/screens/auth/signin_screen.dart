import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'forgot_password_screen.dart';
import '../home_screen.dart';
import '../employee_screen.dart';
import '../hr_dashboard_screen.dart';


class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}


class _SignInScreenState extends State<SignInScreen> {

  final supabase = Supabase.instance.client;
  @override
  void initState() {
    super.initState();

    final session = supabase.auth.currentSession;

    if (session != null) {
      isSignUp = true;
    }
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  bool isPasswordVisible = false;
  bool isLoading = false;
  String? selectedRole;
  List<String> roles = ["admin", "hr", "employee", "client"];


  bool isSignUp = false;

  /// 🔥 LOGIN
  Future<void> login() async {
    if (emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      showSnack("Enter email & password ❌", false);
      return;
    }

    setState(() => isLoading = true);

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    try {
      String role = '';

      /// 🔐 FIXED USERS
      if (email == 'charmisoni2076@gmail.com' &&
          password == 'Chand_2076' &&
          selectedRole == 'admin') {
        role = 'admin';
      }
        else if (email == 'jasooshuman@gmail.com' &&
          password == 'angel_198' &&
          selectedRole == 'hr') {
        role = 'hr';
      }
      else if (email == 'mishrisoni208@gmail.com' &&
          password == 'Mishri_208' &&
          selectedRole == 'employee') {
        role = 'employee';
      }
      else {
        showSnack("Invalid credentials ❌", false);
        setState(() => isLoading = false);
        return;
      }

      /// 🔥 NAVIGATION
      if (!mounted) return;

      if (role == 'admin') {
        if (role == 'admin') {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const HomeScreen()));
        }
        else if (role == 'hr') {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const HrDashboardScreen()));
        }
        else if (role == 'employee') {
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => const EmployeeScreen()));
        }
      }
    } catch (e) {
      showSnack("Login error ❌", false);
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
          'role': selectedRole,
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
        if (isSignUp)
          Column(
            children: [
              // DropdownButtonFormField<String>(
              //   value: selectedRole,
              //   hint: const Text("Select Role"),
              //   items: roles.map((role) {
              //     return DropdownMenuItem(
              //       value: role,
              //       child: Text(role.toUpperCase()),
              //     );
              //   }).toList(),
              //   onChanged: (value) {
              //     setState(() {
              //       selectedRole = value!;
              //     });
              //   },
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10),
              //     ),
              //   ),
              // ),
              const SizedBox(height: 15),
            ],
          ),
        // DropdownButtonFormField<String>(
        //   value: selectedRole,
        //   items: roles.map((role) {
        //     return DropdownMenuItem(
        //       value: role,
        //       child: Text(role.toUpperCase()),
        //     );
        //   }).toList(),
        //   onChanged: (value) {
        //     setState(() {
        //       selectedRole = value!;
        //     });
        //   },
        //   decoration: InputDecoration(
        //     border: OutlineInputBorder(
        //       borderRadius: BorderRadius.circular(10),
        //     ),
        //   ),
        // ),
        TextField(
          controller: emailController,
          enabled: selectedRole != null, // 🔥 MAIN CHANGE
          decoration: InputDecoration(
            hintText: selectedRole == null
                ? "Select role first"
                : "Email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
        const SizedBox(height: 15),
        const SizedBox(height: 15),
        const SizedBox(height: 15),

        Container(
          decoration: BoxDecoration(
            color: Colors.deepPurple.shade50,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.2),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: DropdownButtonFormField<String>(
            value: selectedRole,
            hint: const Text(
              "Select Role",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            icon: const Icon(Icons.person, color: Colors.deepPurple),
            dropdownColor: Colors.white,
            items: roles.map((role) {
              return DropdownMenuItem(
                value: role,
                child: Text(
                  role.toUpperCase(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedRole = value!;
              });
            },
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(height: 15),
        TextField(
          controller: passwordController,
          obscureText: !isPasswordVisible,
          enabled: selectedRole != null,
          decoration: InputDecoration(
            hintText: selectedRole == null
                ? "Select role first"
                : "Password",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            suffixIcon: IconButton(
              icon: Icon(isPasswordVisible
                  ? Icons.visibility
                  : Icons.visibility_off),
              onPressed: () {
                setState(() {
                  isPasswordVisible = !isPasswordVisible;
                });
              },
            ),
          ),
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