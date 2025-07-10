import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/contact.dart';

class ApiService {
  static const String baseUrl = 'https://jsonplaceholder.typicode.com/users';

  Future<List<Contact>> getContacts() async {
    try {
      final res = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print("response "+res.body);
      print("response "+res.statusCode.toString());
      if (res.statusCode == 200) {
        final List list = jsonDecode(res.body);
        return list.map((e) => Contact.fromJson(e)).toList();
      } else {
        throw Exception("Failed to load: ${res.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching contacts: $e");
    }
  }

  Future<Contact> createContact(Contact contact) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(contact.toJson()),
    );
    print("response "+res.body);
    if (res.statusCode == 201) {
      return Contact.fromJson(jsonDecode(res.body));
    } else {
      throw Exception("Failed to create contact: ${res.statusCode}");
    }
  }

  Future<void> updateContact(Contact contact) async {
    final res = await http.put(
      Uri.parse('$baseUrl/${contact.id}'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(contact.toJson()),
    );
    print("response "+res.body);
    if (res.statusCode != 200) {
      throw Exception("Failed to update contact: ${res.statusCode}");
    }
  }

  Future<void> deleteContact(int id) async {
    final res = await http.delete(
      Uri.parse('$baseUrl/$id'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print("response "+res.statusCode.toString());
    if (res.statusCode != 200) {
      throw Exception("Failed to delete contact: ${res.statusCode}");
    }
  }
}