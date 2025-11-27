import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CallMe',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    PhoneDialerPage(),
    ContactsPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dialpad), label: 'Dialer'),
          BottomNavigationBarItem(icon: Icon(Icons.contacts), label: 'Contacts'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}

class PhoneDialerPage extends StatefulWidget {
  const PhoneDialerPage({super.key});

  @override
  State<PhoneDialerPage> createState() => _PhoneDialerPageState();
}

class _PhoneDialerPageState extends State<PhoneDialerPage> {
  final TextEditingController _phoneController = TextEditingController();
  bool _isCalling = false;

  void _appendDigit(String digit) {
    setState(() {
      _phoneController.text += digit;
    });
  }

  void _backspace() {
    setState(() {
      if (_phoneController.text.isNotEmpty) {
        _phoneController.text = _phoneController.text.substring(0, _phoneController.text.length - 1);
      }
    });
  }

  void _dial() {
    final phoneNumber = _phoneController.text.trim();
    if (phoneNumber.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please enter a phone number')));
      return;
    }
    setState(() {
      _isCalling = true;
    });
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => CallingScreen(phoneNumber: phoneNumber, contactName: null, onEndCall: () { Navigator.of(context).pop(); setState(() { _isCalling = false; }); } )));
  }

  void _endCall() {
    setState(() {
      _isCalling = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Call ended')));
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Image.asset('assets/images/app_logo.jpg', height: 36, width: 36, fit: BoxFit.contain),
        ),
        title: const Text('CallMe'),
        elevation: 0,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.green.shade700, Colors.teal.shade400]),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            padding: const EdgeInsets.fromLTRB(20, 22, 20, 28),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('Quick Dial', style: TextStyle(color: Colors.white70, fontSize: 14)),
                      SizedBox(height: 6),
                      Text('CallMe', style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white.withOpacity(0.18),
                  child: ClipOval(child: Image.asset('assets/images/app_logo.jpg', width: 40, height: 40, fit: BoxFit.contain)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 18.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        _phoneController.text.isEmpty ? 'Enter number' : _phoneController.text,
                        style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(width: 12),
                    IconButton(
                      onPressed: _backspace,
                      icon: const Icon(Icons.backspace_outlined),
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: GridView.count(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                children: [
                  for (var i = 1; i <= 9; i++) _buildDialButton(i.toString()),
                  _buildDialButton('*'),
                  _buildDialButton('0'),
                  _buildDialButton('#'),
                ],
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: _saveContact,
                  icon: const Icon(Icons.person_add),
                  label: const Text('Save'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green.shade700,
                    elevation: 2,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),

                FloatingActionButton.extended(
                  onPressed: _dial,
                  label: const Text('Call'),
                  icon: const Icon(Icons.call),
                  backgroundColor: Colors.green.shade700,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDialButton(String label) {
    return ElevatedButton(
      onPressed: () => _appendDigit(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        elevation: 2,
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(20),
      ),
      child: Text(label, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600)),
    );
  }

  Future<void> _saveContact() async {
    final phone = _phoneController.text.trim();
    if (phone.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Enter a number before saving')));
      }
      return;
    }

    final TextEditingController nameCtrl = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Save contact'),
        content: TextField(
          controller: nameCtrl,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(nameCtrl.text.trim()), child: const Text('Save')),
        ],
      ),
    );

    if (result != null && result.isNotEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Saved $result — $phone (local only)')));
      }
    }
  }
}

class CallingScreen extends StatelessWidget {
  final String phoneNumber;
  final String? contactName;
  final VoidCallback onEndCall;

  const CallingScreen({
    super.key,
    required this.phoneNumber,
    this.contactName,
    required this.onEndCall,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Contact avatar or default icon
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.green,
              child: contactName != null
                  ? Text(
                      contactName![0].toUpperCase(),
                      style: const TextStyle(fontSize: 48, color: Colors.white),
                    )
                  : const Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.white,
                    ),
            ),
            const SizedBox(height: 20),
            // Contact name or "Unknown"
            Text(
              contactName ?? 'Unknown',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            // Phone number
            Text(
              phoneNumber,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 20),
            // Calling status
            const Text(
              'Calling...',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 60),
            // End call button
            FloatingActionButton(
              onPressed: onEndCall,
              backgroundColor: Colors.red,
              child: const Icon(Icons.call_end, size: 32),
            ),
          ],
        ),
      ),
    );
  }
}

class Contact {
  String name;
  String phone;

  Contact({required this.name, required this.phone});

  Map<String, dynamic> toJson() => {'name': name, 'phone': phone};

  factory Contact.fromJson(Map<String, dynamic> json) =>
      Contact(name: json['name'], phone: json['phone']);
}

class ContactsPage extends StatefulWidget {
  const ContactsPage({super.key});

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class _ContactsPageState extends State<ContactsPage> {
  List<Contact> _contacts = [];

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = prefs.getString('contacts');
    if (contactsJson != null) {
      final List<dynamic> decoded = json.decode(contactsJson);
      setState(() {
        _contacts = decoded.map((item) => Contact.fromJson(item)).toList();
      });
    } else {
      // If no contacts, add some sample ones
      setState(() {
        _contacts = [
          Contact(name: 'John Doe', phone: '+1234567890'),
          Contact(name: 'Jane Smith', phone: '+0987654321'),
          Contact(name: 'Bob Johnson', phone: '+1122334455'),
        ];
      });
      _saveContacts();
    }
  }

  Future<void> _saveContacts() async {
    final prefs = await SharedPreferences.getInstance();
    final contactsJson = json.encode(_contacts.map((contact) => contact.toJson()).toList());
    await prefs.setString('contacts', contactsJson);
  }

  void _addContact() {
    _showContactDialog();
  }

  void _editContact(int index) {
    _showContactDialog(contact: _contacts[index], index: index);
  }

  void _deleteContact(int index) {
    setState(() {
      _contacts.removeAt(index);
    });
    _saveContacts();
  }

  void _showContactDialog({Contact? contact, int? index}) {
    final nameController = TextEditingController(text: contact?.name ?? '');
    final phoneController = TextEditingController(text: contact?.phone ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(contact == null ? 'Add Contact' : 'Edit Contact'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final name = nameController.text.trim();
              final phone = phoneController.text.trim();
              if (name.isNotEmpty && phone.isNotEmpty) {
                setState(() {
                  if (index != null) {
                    _contacts[index] = Contact(name: name, phone: phone);
                  } else {
                    _contacts.add(Contact(name: name, phone: phone));
                  }
                });
                _saveContacts();
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _addContact,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(contact.name[0].toUpperCase()),
            ),
            title: Text(contact.name),
            subtitle: Text(contact.phone),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () => _editContact(index),
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () => _deleteContact(index),
                ),
              ],
            ),
            onTap: () {
              // Navigate back to dialer with this contact's number
              Navigator.of(context).pop();
              // This would need to be implemented to pass data back
            },
          );
        },
      ),
    );
  }
}
