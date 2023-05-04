import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Contact {
  final String name;
  final String id;

  Contact({required this.name}) : id = const Uuid().v1();
}

class ContactBook extends ValueNotifier<List<Contact>> {
  ContactBook._sharedInstance() : super([]);
  static final ContactBook _shared = ContactBook._sharedInstance();
  factory ContactBook() => _shared;

  int get length => value.length;

  void addContact({required Contact contact}) {
    final contactsList = value;
    contactsList.add(contact);
    notifyListeners();
  }

  void removeContact({required Contact contact}) {
    final contactsList = value;
    contactsList.remove(contact);
    notifyListeners();
  }

  Contact? contact({required int atIndex}) =>
      atIndex < value.length ? value.elementAt(atIndex) : null;
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
    return Scaffold(
      appBar: AppBar(title: const Text("State App 1")),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed('/add-contact');
        },
        child: const Icon(Icons.add),
      ),
      body: ValueListenableBuilder(
        valueListenable: ContactBook(),
        builder: (context, value, child) => ListView.builder(
          itemBuilder: (context, index) {
            final contact = value.elementAt(index);
            return Dismissible(
                onDismissed: (direction) =>
                    ContactBook().removeContact(contact: contact),
                key: ValueKey(contact.id),
                child: Card(
                    color: Colors.amber.shade50,
                    child: ListTile(title: Text(contact.name))));
          },
          itemCount: value.length,
        ),
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
            decoration: const InputDecoration(hintText: "Enter a new contact"),
            onSubmitted: (value) {
              contactBook.addContact(contact: Contact(name: value));
              Navigator.of(context).pop();
            },
          ),
          TextButton(
            onPressed: () {
              contactBook.addContact(contact: Contact(name: _controller.text));
              Navigator.of(context).pop();
            },
            child: const Text("Add"),
          )
        ],
      ),
    );
  }
}
