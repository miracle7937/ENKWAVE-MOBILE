import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MyForm extends StatefulWidget {
  @override
  _MyFormState createState() => _MyFormState();
}

class _MyFormState extends State<MyForm> {
  final _formKey = GlobalKey<FormState>();

  final _phoneNumberController = TextEditingController();

  String _selectedCountryCode = '+1';

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 100,
                child: DropdownButtonFormField<String>(
                  value: _selectedCountryCode,
                  onChanged: (value) {
                    setState(() {
                      _selectedCountryCode = value!;
                    });
                  },
                  items: [
                    DropdownMenuItem(
                      value: '+1',
                      child: Text('US'),
                    ),
                    DropdownMenuItem(
                      value: '+44',
                      child: Text('UK'),
                    ),
                    // Add more countries as needed
                  ],
                ),
              ),
              Expanded(
                child: TextFormField(
                  controller: _phoneNumberController,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter a phone number';
                    }
                    return null;
                  },
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Submit the form
                final phoneNumber =
                    '$_selectedCountryCode${_phoneNumberController.text}';
                print('Phone number: $phoneNumber');
              }
            },
            child: Text('Submit'),
          ),
        ],
      ),
    );
  }
}
