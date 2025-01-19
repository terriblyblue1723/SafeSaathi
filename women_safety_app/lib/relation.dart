import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:women_safety_app/DatabaseHelper.dart';
import 'package:women_safety_app/bottonNavBar.dart';
import 'package:women_safety_app/api_service.dart';

// Custom widget for relation tiles
class RelationTile extends StatelessWidget {
  final String relation;
  final bool isSelected;
  final VoidCallback onTap;
  final Color backgroundColor;

  const RelationTile({
    required this.relation,
    required this.isSelected,
    required this.onTap,
    required this.backgroundColor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        margin: const EdgeInsets.only(right: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.red : backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          relation,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

// Custom widget for relation indicator
class RelationIndicator extends StatelessWidget {
  final String relation;

  const RelationIndicator({required this.relation, Key? key}) : super(key: key);

  Color get backgroundColor {
    switch (relation) {
      case 'Family':
        return Colors.amber;
      case 'Friends':
        return Colors.purple;
      case 'Work':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        relation,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final List<Map<String, String>> _contacts = [];
  int _selectedIndex = 5;
  late DatabaseHelper _databaseHelper;

  @override
  void initState() {
    super.initState();
    _databaseHelper = DatabaseHelper.instance;
    _loadContacts();
  }

  Future<void> _loadContacts() async {
    try {
      // Get logged in user's Aadhaar number
      final aadhaarNumber = await _databaseHelper.getAadhaarNumber();
      if (aadhaarNumber == null) {
        throw Exception('User not logged in');
      }

      // First load from backend
      final apiService = ApiService();
      final backendContacts = await apiService.getEmergencyContacts(aadhaarNumber);

      // Update local database with backend data
      for (var contact in backendContacts) {
        await _databaseHelper.insertOrUpdateContact({
          'name': contact['name'],
          'phone': contact['phone_number'],
          'relation': contact['relation'] ?? 'Others',
        });
      }

      // Load from local database
      final contacts = await _databaseHelper.getContacts();
      setState(() {
        _contacts.clear();
        for (var contact in contacts) {
          _contacts.add({
            'name': contact['name'] as String,
            'phone': contact['phone'] as String,
            'relation': contact['relation'] as String,
          });
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading contacts: $e')),
        );
      }
    }
  }

  Future<void> _addContact(Map<String, String> newContact) async {
    try {
      // Get logged in user's Aadhaar number
      final aadhaarNumber = await _databaseHelper.getAadhaarNumber();
      if (aadhaarNumber == null) {
        throw Exception('User not logged in');
      }

      // First add to backend
      final apiService = ApiService();
      await apiService.addEmergencyContact(
        aadhaarNumber,
        newContact['phone']!,
        newContact['name']!,
        relation: newContact['relation'],
      );

      // Then add to local database
      await _databaseHelper.insertOrUpdateContact({
        'name': newContact['name']!,
        'phone': newContact['phone']!,
        'relation': newContact['relation']!,
      });

      await _loadContacts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contact added successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error adding contact: $e')),
        );
      }
    }
  }

  Future<void> _updateContact(String oldPhone, Map<String, String> newContact) async {
    try {
      // Get logged in user's Aadhaar number
      final aadhaarNumber = await _databaseHelper.getAadhaarNumber();
      if (aadhaarNumber == null) {
        throw Exception('User not logged in');
      }

      // First update in backend
      final apiService = ApiService();
      await apiService.updateEmergencyContact(
        aadhaarNumber,
        newContact['phone']!,
        newContact['name']!,
        relation: newContact['relation'],
      );

      // Then update local database
      await _databaseHelper.insertOrUpdateContact({
        'name': newContact['name']!,
        'phone': newContact['phone']!,
        'relation': newContact['relation']!,
      });

      await _loadContacts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contact updated successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating contact: $e')),
        );
      }
    }
  }

  Future<void> _deleteContact(String phone) async {
    try {
      // Get logged in user's Aadhaar number
      final aadhaarNumber = await _databaseHelper.getAadhaarNumber();
      if (aadhaarNumber == null) {
        throw Exception('User not logged in');
      }

      // First delete from backend
      final apiService = ApiService();
      await apiService.deleteEmergencyContact(aadhaarNumber, phone);

      // Then delete from local database
      await _databaseHelper.deleteContact(phone);

      await _loadContacts();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Contact deleted successfully')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting contact: $e')),
        );
      }
    }
  }

  void _showContactDialog({Map<String, String>? contact}) {
    final phoneController = TextEditingController(
      text: contact != null ? contact['phone']!.replaceFirst('+91', '') : '',
    );
    final nameController = TextEditingController(text: contact?['name']);
    final formKey = GlobalKey<FormState>();
    String selectedRelation = contact?['relation'] ?? 'Others';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(contact == null ? "Add New Contact" : "Edit Contact"),
              content: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: "Enter contact name",
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp('[a-zA-Z ]'))
                        ],
                        validator: (value) =>
                        value == null || value.isEmpty
                            ? "Enter contact name"
                            : null,
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: phoneController,
                        decoration: const InputDecoration(
                          labelText: "Enter phone number",
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Enter phone number";
                          }
                          if (value.length != 10) {
                            return "Phone number must be 10 digits";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Relation",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            RelationTile(
                              relation: "Family",
                              isSelected: selectedRelation == "Family",
                              backgroundColor: _getRelationColor("Family"),
                              onTap: () =>
                                  setState(() => selectedRelation = "Family"),
                            ),
                            RelationTile(
                              relation: "Friends",
                              isSelected: selectedRelation == "Friends",
                              backgroundColor: _getRelationColor("Friends"),
                              onTap: () =>
                                  setState(() => selectedRelation = "Friends"),
                            ),
                            RelationTile(
                              relation: "Work",
                              isSelected: selectedRelation == "Work",
                              backgroundColor: _getRelationColor("Work"),
                              onTap: () =>
                                  setState(() => selectedRelation = "Work"),
                            ),
                            RelationTile(
                              relation: "Others",
                              isSelected: selectedRelation == "Others",
                              backgroundColor: _getRelationColor("Others"),
                              onTap: () =>
                                  setState(() => selectedRelation = "Others"),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Map<String, String> newContact = {
                        'name': nameController.text.trim(),
                        'phone': phoneController.text.trim(),
                        'relation': selectedRelation,
                      };
                      if (contact == null) {
                        _addContact(newContact);
                      } else {
                        _updateContact(contact['phone']!, newContact);
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  child: Text(contact == null ? "Add" : "Update"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(239, 242, 249, 255),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Emergency Contacts',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add, size: 32, color: Colors.red),
                    onPressed: () => _showContactDialog(),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _contacts.isEmpty
                  ? const Center(
                child: Text(
                  "No contacts yet. Add your first contact!",
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              )
                  : _buildContactsList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _selectedIndex,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }

  // Get background color for relation tiles
  Color _getRelationColor(String relation) {
    switch (relation) {
      case 'Family':
        return Colors.amber.withOpacity(0.3);
      case 'Friends':
        return Colors.purple.withOpacity(0.3);
      case 'Work':
        return Colors.green.withOpacity(0.3);
      default:
        return Colors.blue.withOpacity(0.3);
    }
  }

  // Build the contacts list
  Widget _buildContactsList() {
    final sortedContacts = _getSortedContacts();
    String? currentRelation;
    List<Widget> contactGroups = [];

    for (var contact in sortedContacts) {
      if (currentRelation != contact['relation']) {
        currentRelation = contact['relation'];
        contactGroups.add(
          Padding(
            padding: const EdgeInsets.only(top: 16, bottom: 8),
            child: RelationIndicator(relation: currentRelation!),
          ),
        );
      }

      contactGroups.add(
        Dismissible(
          key: Key(contact['phone']!),
          direction: DismissDirection.endToStart,
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) {
            _deleteContact(contact['phone']!);
          },
          confirmDismiss: (direction) async {
            return await showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Contact'),
                content: const Text('Are you sure you want to delete this contact?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
          child: Card(
            margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
            child: ListTile(
              title: Text(
                contact['name'] ?? '',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                contact['phone'] ?? '',
                style: const TextStyle(fontSize: 14),
              ),
              trailing: IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => _showContactDialog(contact: contact),
              ),
            ),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: contactGroups,
    );
  }

  // Sort contacts by relation priority
  List<Map<String, String>> _getSortedContacts() {
    final Map<String, int> relationPriority = {
      'Family': 0,
      'Friends': 1,
      'Work': 2,
      'Others': 3,
    };

    List<Map<String, String>> sortedContacts = List.from(_contacts);
    sortedContacts.sort((a, b) {
      int priorityA = relationPriority[a['relation']] ?? 4;
      int priorityB = relationPriority[b['relation']] ?? 4;
      if (priorityA != priorityB) return priorityA.compareTo(priorityB);
      return (a['name'] ?? '').compareTo(b['name'] ?? '');
    });

    return sortedContacts;
  }
}
