import 'package:flutter/material.dart';
import '../../models/contact.dart';
import '../../services/api_service.dart';
import 'contact_form.dart';

class ContactList extends StatefulWidget {
  const ContactList({super.key});

  @override
  State<ContactList> createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final ApiService api = ApiService();
  late Future<List<Contact>> _contactFuture;

  @override
  void initState() {
    super.initState();
    _refreshList();
  }

  void _refreshList() {
    setState(() {
      _contactFuture = api.getContacts();
    });
  }

  void _delete(int id) async {
    await api.deleteContact(id);
    _refreshList();
  }

  void _edit(Contact contact) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ContactForm(contact: contact),
      ),
    ).then((_) => _refreshList());
  }

  void _create() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ContactForm()),
    ).then((_) => _refreshList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Manager')),
      body: FutureBuilder<List<Contact>>(
        future: _contactFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final contacts = snapshot.data!;
            return ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (_, index) {
                final contact = contacts[index];
                return ListTile(
                  title: Text(contact.name),
                  subtitle: Text(contact.email),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.edit), onPressed: () => _edit(contact)),
                      IconButton(icon: Icon(Icons.delete), onPressed: () => _delete(contact.id!)),
                    ],
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Failed to load data"));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _create,
        child: const Icon(Icons.add),
      ),
    );
  }
}
