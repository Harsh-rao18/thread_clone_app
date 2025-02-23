import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:thread_clone_app/controllers/auth_controller.dart';
import 'package:thread_clone_app/core/widgets/auth_input.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final cpasswordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final AuthController controller = Get.put(AuthController());

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    cpasswordController.dispose();
    super.dispose();
  }

  // Submit Method
  void _submit() {
    if (_formKey.currentState!.validate()) {
      controller.register(
          nameController.text, emailController.text, passwordController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(10),
              child: Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 60,
                        height: 60,
                      ),
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Register',
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            Text('Welcome to the Threads Clone'),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthInput(
                        hintText: 'Enter Your Name',
                        labelText: 'FullName',
                        controller: nameController,
                        validator: ValidationBuilder()
                            .required()
                            .minLength(3)
                            .maxLength(50)
                            .build(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthInput(
                        hintText: 'Enter Your Email',
                        labelText: 'Email',
                        controller: emailController,
                        validator:
                            ValidationBuilder().required().email().build(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthInput(
                        hintText: 'Enter Your password',
                        labelText: 'Password',
                        controller: passwordController,
                        isObsecure: true,
                        validator: ValidationBuilder()
                            .required()
                            .minLength(6)
                            .maxLength(12)
                            .build(),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      AuthInput(
                        hintText: 'Confirm Your password',
                        labelText: 'Confirm Password',
                        controller: cpasswordController,
                        isObsecure: true,
                        validator: (args) {
                          if (passwordController.text != args) {
                            return "Confirm Password not matched";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Obx(() => ElevatedButton(
                            onPressed: _submit,
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 50),
                              backgroundColor: Colors.white,
                            ),
                            child:  Text(
                              controller.registerLoading.value
                                  ? 'processing...'
                                  :
                              'Register',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          )),
                      const SizedBox(
                        height: 20,
                      ),
                      RichText(
                        text: TextSpan(
                          text: "Already have an account? ",
                          style: const TextStyle(color: Colors.white),
                          children: [
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(context, '/login');
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
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
  }
}
