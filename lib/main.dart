import 'package:flutter/material.dart';

class Contact {
  final String name;
  final int id;

  Contact({required this.name, required this.id});
}

class ContactBook {
  ContactBook._sharedInstance();
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  final List<Contact> _contactList = [Contact(name: "Amanat", id: 1)];

  int get length => _contactList.length;

  void addContact({required Contact contact}) {
    _contactList.add(contact);
  }

  void removeContact({required Contact contact}) {
    _contactList.remove(contact);
  }

  Contact? contact({required int atIndex}) =>
      atIndex < _contactList.length ? _contactList.elementAt(atIndex) : null;
}

void main() {
  runApp(MaterialApp(
    title: 'Flutter Demo',
    theme: ThemeData(
      primarySwatch: Colors.blue,
    ),
    routes: {
      '/add-contact': (context) => const AddContactPage(),
    },
    debugShowCheckedModeBanner: false,
    home: const HomePage(),
  ));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(title: const Text("State App 1")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add-contact');
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          final contact = contactBook.contact(atIndex: index)!;
          return ListTile(title: Text(contact.name));
        },
        itemCount: contactBook.length,
      ),
    );
  }
}

class AddContactPage extends StatefulWidget {
  const AddContactPage({super.key});

  @override
  State<AddContactPage> createState() => _AddContactPageState();
}

class _AddContactPageState extends State<AddContactPage> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final contactBook = ContactBook();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add a Contact"),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              hintText: "Enter a new contact"
            ),
          ),
          TextButton(
            onPressed: () {
              // contactBook.addContact(contact: Contact(name: _controller.text, id: Uui));
              print(contactBook);
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }
}
