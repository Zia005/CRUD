import 'package:flutter/material.dart';
import '../../models/contact.dart';
import '../../services/api_service.dart';

class ContactForm extends StatefulWidget {
  final Contact? contact;

  const ContactForm({super.key, this.contact});

  @override
  State<ContactForm> createState() => _ContactFormState();
}

class _ContactFormState extends State<ContactForm> {
  final _formKey = GlobalKey<FormState>();
  late String name;
  late String email;

  final api = ApiService();

  @override
  void initState() {
    super.initState();
    name = widget.contact?.name ?? '';
    email = widget.contact?.email ?? '';
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final newContact = Contact(
        id: widget.contact?.id ?? 0,
        name: name,
        username: name,
        email: email,
        phone: '123-456-7890',
        website: 'example.com',
        address: Address(
          street: '123',
          suite: 'Apt. 101',
          city: 'Sylhet',
          zipcode: '1200',
          geo: Geo(lat: '23.8103', lng: '90.4125'),
        ),
        company: Company(
          name: 'Test',
          catchPhrase: 'Nothing',
          bs: '......',
        ),
      );

      if (widget.contact == null) {
        await api.createContact(newContact);
      } else {
        await api.updateContact(newContact);
      }

      Navigator.pop(context);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.contact == null ? 'Create Contact' : 'Edit Contact')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: name,
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (val) => name = val!,
                validator: (val) => val!.isEmpty ? 'Enter name' : null,
              ),
              TextFormField(
                initialValue: email,
                decoration: const InputDecoration(labelText: 'Email'),
                onSaved: (val) => email = val!,
                validator: (val) => val!.isEmpty ? 'Enter email' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(onPressed: _submit, child: const Text("Save"))
            ],
          ),
        ),
      ),
    );
  }
}
