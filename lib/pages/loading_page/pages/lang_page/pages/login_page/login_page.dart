import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proklinik_doctor_portal/assets/assets.dart';
import 'package:proklinik_doctor_portal/core/api/auth/api_auth.dart';
import 'package:proklinik_doctor_portal/extensions/is_mobile_context.dart';
import 'package:proklinik_doctor_portal/extensions/loc_ext.dart';
import 'package:proklinik_doctor_portal/providers/px_auth.dart';
import 'package:proklinik_doctor_portal/providers/px_locale.dart';
import 'package:proklinik_doctor_portal/router/router.dart';
import 'package:proklinik_doctor_portal/widgets/central_loading.dart';
import 'package:proklinik_doctor_portal/widgets/login_register_avatar.dart';
import 'package:proklinik_doctor_portal/widgets/snackbar_.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();

  final emailFieldKey = GlobalKey<FormFieldState>();

  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;

  bool _rememberMe = false;
  bool _obscure = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Consumer<PxLocale>(
            builder: (context, l, _) {
              // ignore: no_leading_underscores_for_local_identifiers
              final Alignment _alignment =
                  l.isEnglish ? Alignment.topLeft : Alignment.topRight;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32.0),
                      child: Form(
                        key: formKey,
                        child: ListView(
                          //# create account form
                          children: [
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Image.asset(
                                  AppAssets.icon,
                                  width: 50,
                                  height: 50,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Text(
                                  'ProKliniK',
                                  style: TextStyle(
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 60),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text(
                                context.loc.welcomeBack,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              subtitle: Text(
                                context.loc.loginTag,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(context.loc.email),
                              ),
                              subtitle: TextFormField(
                                controller: _emailController,
                                key: emailFieldKey,
                                decoration: const InputDecoration(
                                  hintText: 'example@domain.com',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return context.loc.enterEmailAddress;
                                  }
                                  if (!EmailValidator.validate(value)) {
                                    return context.loc.invalidEmailAddress;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  children: [
                                    Text(context.loc.password),
                                    const SizedBox(width: 20),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _obscure = !_obscure;
                                        });
                                      },
                                      child: const Icon(
                                        Icons.remove_red_eye_outlined,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              subtitle: TextFormField(
                                controller: _passwordController,
                                decoration: const InputDecoration(
                                  hintText: '********',
                                ),
                                obscureText: _obscure,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return context.loc.enterPassword;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            CheckboxListTile(
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              title: Row(
                                children: [
                                  Text(context.loc.rememberMe),
                                  const Spacer(),
                                  Text.rich(
                                    TextSpan(
                                      text: context.loc.forgotPassword,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () async {
                                          //todo: verify that email address was entered
                                          if (emailFieldKey.currentState!
                                              .validate()) {
                                            //todo: end forgot password email
                                            await AuthApi()
                                                .requestResetPassword(
                                                    _emailController.text);
                                            if (context.mounted) {
                                              //todo: show snackbar that a password reset mail was sent
                                              showIsnackbar(context
                                                  .loc.passwordResetEmailSent);
                                            }
                                          }
                                        },
                                      style: const TextStyle(
                                        color: Colors.blue,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              value: _rememberMe,
                              onChanged: (val) {
                                setState(() {
                                  if (val != null) {
                                    _rememberMe = val;
                                  }
                                });
                              },
                              mouseCursor: SystemMouseCursors.click,
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      //todo: validate credentials
                                      // ignore: no_leading_underscores_for_local_identifiers
                                      late BuildContext _loadingContext;
                                      if (formKey.currentState!.validate()) {
                                        //TODO: navigate to app
                                        showDialog(
                                          context: context,
                                          builder: (loadingContext) {
                                            _loadingContext = loadingContext;
                                            return const CentralLoading();
                                          },
                                        );
                                        if (context.mounted) {
                                          try {
                                            await context
                                                .read<PxAuth>()
                                                .loginAccount(
                                                  _emailController.text,
                                                  _passwordController.text,
                                                  _rememberMe,
                                                );
                                          } catch (e) {
                                            if (_loadingContext.mounted) {
                                              Navigator.pop(_loadingContext);
                                            }
                                            if (context.mounted) {
                                              showIsnackbar(e.toString());
                                            }
                                            return;
                                          }
                                        }
                                        if (_loadingContext.mounted) {
                                          Navigator.pop(_loadingContext);
                                        }
                                        if (context.mounted) {
                                          GoRouter.of(context).goNamed(
                                            AppRouter.app,
                                            pathParameters:
                                                defaultPathParameters(context),
                                          );
                                        }
                                      }
                                    },
                                    child: Text(context.loc.login),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text.rich(
                              TextSpan(
                                text: '',
                                children: [
                                  TextSpan(
                                    text: context.loc.notRegisteredYet,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const TextSpan(text: '   '),
                                  TextSpan(
                                    text: context.loc.createAccount,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        GoRouter.of(context).goNamed(
                                          AppRouter.register,
                                          pathParameters:
                                              defaultPathParameters(context),
                                        );
                                      },
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  //# login-register-avatar
                  if (!context.isMobile)
                    LoginRegisterAvatar(alignment: _alignment),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
