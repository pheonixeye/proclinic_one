// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:proklinik_doctor_portal/assets/assets.dart';
import 'package:proklinik_doctor_portal/extensions/is_mobile_context.dart';
import 'package:proklinik_doctor_portal/extensions/loc_ext.dart';
import 'package:proklinik_doctor_portal/models/dto_create_doctor_account.dart';
import 'package:proklinik_doctor_portal/models/speciality.dart';
import 'package:proklinik_doctor_portal/providers/px_auth.dart';
import 'package:proklinik_doctor_portal/providers/px_locale.dart';
import 'package:proklinik_doctor_portal/providers/px_speciality.dart';
import 'package:proklinik_doctor_portal/router/router.dart';
import 'package:proklinik_doctor_portal/widgets/central_loading.dart';
import 'package:proklinik_doctor_portal/widgets/login_register_avatar.dart';
import 'package:proklinik_doctor_portal/widgets/snackbar_.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _passwordConfirmController;
  Speciality? _speciality;
  bool _obscurePasswords = true;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _passwordConfirmController = TextEditingController();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmController.dispose();
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
              final Alignment _alignment =
                  l.isEnglish ? Alignment.topLeft : Alignment.topRight;
              return Row(
                children: [
                  //# register-form
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
                              title: Text(
                                context.loc.register,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              subtitle: Text(
                                context.loc.registerTag,
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
                                          _obscurePasswords =
                                              !_obscurePasswords;
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
                                obscureText: _obscurePasswords,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return context.loc.enterPassword;
                                  }
                                  if (value.length < 8) {
                                    return context.loc.passwordEightLetters;
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
                                    Text(context.loc.confirmPassword),
                                    const SizedBox(width: 20),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          _obscurePasswords =
                                              !_obscurePasswords;
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
                                controller: _passwordConfirmController,
                                decoration: const InputDecoration(
                                  hintText: '********',
                                ),
                                obscureText: _obscurePasswords,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return context.loc.enterConfirmPassword;
                                  }
                                  if (value != _passwordController.text) {
                                    return context.loc.passwordsNotMatching;
                                  }
                                  return null;
                                },
                              ),
                            ),
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Text(context.loc.speciality),
                              ),
                              subtitle: Consumer<PxSpec>(
                                builder: (context, s, _) {
                                  return DropdownButtonHideUnderline(
                                    child: DropdownButtonFormField<Speciality>(
                                      isExpanded: true,
                                      hint: Text(context.loc.selectSpeciality),
                                      alignment: Alignment.center,
                                      items: s.specialities?.map((e) {
                                        return DropdownMenuItem<Speciality>(
                                          alignment: Alignment.center,
                                          value: e,
                                          child: Text(
                                            l.isEnglish ? e.en : e.ar,
                                            textAlign: TextAlign.center,
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (spec) {
                                        setState(() {
                                          _speciality = spec;
                                        });
                                      },
                                      value: _speciality,
                                      validator: (value) {
                                        if (value == null) {
                                          return context.loc.selectSpeciality;
                                        }
                                        return null;
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Expanded(
                                  child: Consumer<PxAuth>(
                                    builder: (context, auth, _) {
                                      return ElevatedButton(
                                        onPressed: () async {
                                          late BuildContext _loadingContext;

                                          if (formKey.currentState!
                                              .validate()) {
                                            //todo: validate credentials
                                            final dto = DtoCreateDoctorAccount(
                                              email: _emailController.text,
                                              password:
                                                  _passwordController.text,
                                              passwordConfirm:
                                                  _passwordConfirmController
                                                      .text,
                                              speciality: _speciality!,
                                            );
                                            try {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    _loadingContext = context;
                                                    return const CentralLoading();
                                                  });
                                              if (context.mounted) {
                                                await auth.createAccount(dto);
                                                if (_loadingContext.mounted) {
                                                  Navigator.pop(
                                                      _loadingContext);
                                                }
                                                if (context.mounted) {
                                                  //todo: navigate to thankyou page

                                                  GoRouter.of(context).goNamed(
                                                    AppRouter.thankyou,
                                                    pathParameters:
                                                        defaultPathParameters(
                                                            context),
                                                  );
                                                }
                                              }
                                            } catch (e) {
                                              if (_loadingContext.mounted) {
                                                Navigator.pop(_loadingContext);
                                              }
                                              if (context.mounted) {
                                                showIsnackbar(e.toString());
                                              }
                                            }
                                          }
                                        },
                                        child: Text(context.loc.register),
                                      );
                                    },
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
                                    text: context.loc.alreadyRegistered,
                                    style: const TextStyle(
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const TextSpan(text: '   '),
                                  TextSpan(
                                    text: context.loc.login,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        GoRouter.of(context).goNamed(
                                          AppRouter.login,
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
                    LoginRegisterAvatar(
                      alignment: _alignment,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
