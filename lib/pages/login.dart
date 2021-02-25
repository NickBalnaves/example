import 'package:flutter/material.dart';
import 'package:gift_card_shopping/providers/user.dart';
import 'package:provider/provider.dart';

/// Login page
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _error;

  static const _validCredentials = {
    'nick': '1234',
  };

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: SizedBox(
              width: 400,
              child: Column(
                children: [
                  TextFormField(
                    controller: _usernameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(labelText: 'Username'),
                    validator: (value) =>
                        value.isEmpty ? 'Please enter a username' : null,
                  ),
                  TextFormField(
                    controller: _passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(labelText: 'Password'),
                    validator: (value) =>
                        value.isEmpty ? 'Please enter a password' : null,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate() &&
                          _validCredentials[_usernameController.text] ==
                              _passwordController.text) {
                        context.read<UserNotifier>().writeAuth(
                              username: _usernameController.text,
                              password: _passwordController.text,
                            );
                        context.read<UserNotifier>().signIn();
                      } else {
                        setState(() => _error = 'Incorrect login credentials');
                      }
                    },
                    child: const Text('LOGIN'),
                  ),
                  if (_error != null)
                    Text(
                      _error,
                      style: const TextStyle(color: Colors.red),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
