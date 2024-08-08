import 'package:flutter/material.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart';

class AuthenticationDialog extends StatefulWidget {
  final void Function(bool) onAuthenticated;

  const AuthenticationDialog({super.key, required this.onAuthenticated});

  @override
  _AuthenticationDialogState createState() => _AuthenticationDialogState();
}

class _AuthenticationDialogState extends State<AuthenticationDialog> {
  final LocalAuthentication auth = LocalAuthentication();
  bool _isAuthenticating = false;
  final TextEditingController _passwordController = TextEditingController();
  String _authorized = 'Not Authorized';
  bool _requestAccepted = false;

  Future<void> _authenticateWithFingerprint() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticate(
        localizedReason: 'Scan your fingerprint to authenticate',
      );
      setState(() {
        _isAuthenticating = false;
        _requestAccepted = authenticated;
        _authorized = authenticated ? 'Request Accepted' : 'Not Authorized';
      });
    } on PlatformException catch (e) {
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Error - ${e.message}';
      });
      return;
    }

    if (authenticated) {
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      widget.onAuthenticated(true);
      Navigator.of(context).pop();
    }
  }

  Future<void> _authenticateWithPassword() async {
    String password = '';
    bool authenticated = false;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Authenticate with Password'),
          content: TextField(
            controller: _passwordController,
            obscureText: true,
            decoration: const InputDecoration(hintText: 'Enter your password'),
            onChanged: (value) {
              password = value;
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // For demonstration purposes, let's assume the password is '123'
                if (password == '123') {
                  authenticated = true;
                } else {
                  authenticated = false;
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );

    setState(() {
      _requestAccepted = authenticated;
      _authorized = authenticated ? 'Request Accepted' : 'Not Authorized';
    });

    if (authenticated) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      widget.onAuthenticated(true);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 25),
          _isAuthenticating
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: _authenticateWithFingerprint,
                  child: const Text('Authenticate with Fingerprint'),
                ),
          const SizedBox(height: 15),
          ElevatedButton(
            onPressed: _authenticateWithPassword,
            child: const Text('Authenticate with Password'),
          ),
          const SizedBox(height: 15),
          Text(
            _authorized,
            style: TextStyle(
              color: _requestAccepted ? Colors.green : Colors.red,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Close'),
          onPressed: () {
            widget.onAuthenticated(false);
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}
