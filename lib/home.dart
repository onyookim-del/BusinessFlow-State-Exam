import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:businessflow/constants/app_colors.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _hidePass = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _phoneCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Form submitted'.tr())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('register_form'.tr()),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _nameCtrl,
              decoration: InputDecoration(
                labelText: 'full_name'.tr(),
                prefixIcon: const Icon(Icons.person),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Name is required'.tr() : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _phoneCtrl,
              decoration: InputDecoration(
                labelText: 'phone_number'.tr(),
                prefixIcon: const Icon(Icons.phone),
                helperText: 'phone_format'.tr(),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Phone number required'.tr() : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _emailCtrl,
              decoration: InputDecoration(
                labelText: 'email_address'.tr(),
                prefixIcon: const Icon(Icons.email),
              ),
              validator: (v) =>
                  v == null || v.isEmpty ? 'Email required'.tr() : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _passCtrl,
              obscureText: _hidePass,
              decoration: InputDecoration(
                labelText: 'password'.tr(),
                prefixIcon: const Icon(Icons.lock),
                suffixIcon: IconButton(
                  icon: Icon(
                    _hidePass ? Icons.visibility_off : Icons.visibility,
                    color: Colors.blue,
                  ),
                  onPressed: () => setState(() => _hidePass = !_hidePass),
                ),
              ),
              validator: (v) => v == null || v.length < 6
                  ? 'At least 6 characters'.tr()
                  : null,
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: _confirmCtrl,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'confirm_password'.tr(),
                prefixIcon: const Icon(Icons.lock_outline),
              ),
              validator: (v) =>
                  v != _passCtrl.text ? 'Passwords do not match'.tr() : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.tertiary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: _submitForm,
              child: Text(
                'submit_form'.tr(),
                style: const TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  onPressed: () async {
                    await context.setLocale(const Locale('en'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Language changed to English')),
                    );
                  },
                  child: const Text('EN'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                  ),
                  onPressed: () async {
                    await context.setLocale(const Locale('ko'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('언어가 한국어로 변경되었습니다')),
                    );
                  },
                  child: const Text('KO'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

