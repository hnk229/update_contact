import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:update_contact/Pages/about.dart';
import 'package:update_contact/Theme/theme.dart';

class homePage extends StatefulWidget {
  const homePage({super.key});

  @override
  State<homePage> createState() => _homePageState();
}

class _homePageState extends State<homePage> {
  List<Contact> contacts = [];
  Map<String, bool> selectedContacts = {}; // Stocke les contacts sélectionnés
  bool _selectAll = false;

  @override
  void initState() {
    super.initState();
    // _checkFirstLaunch();
    fetchContacts();
  }

  Future<void> fetchContacts() async {
    if (await Permission.contacts.request().isGranted) {
      final fetchedContacts = await FlutterContacts.getContacts(
        withProperties: true, // To fetch phone numbers and other properties
        withAccounts: true,
        withPhoto: true,
        withGroups: true,
      );
      setState(() {
        contacts = fetchedContacts
            .where((contact) =>
                contact.phones.any((phone) => isBeninNumber(phone.number)))
            .toList();

        for (var contact in contacts) {
          selectedContacts[contact.id] = true; // Tous sélectionnés par défaut
        }
        _selectAll = true;
      });
    } else {
      print("Permission refused.");
    }
  }

  String cleanNumber(String number) {
    return number.replaceAll(RegExp(r'\s+|-|\(|\)'), '');
  }

  bool isBeninNumber(String number) {
    final cleanedNumber = cleanNumber(number);
    return cleanedNumber.startsWith("+229") ||
        (cleanedNumber.length == 8 &&
            RegExp(r'^[6|9|5|4]\d{7}$').hasMatch(cleanedNumber));
  }

  String modifyBeninNumber(String number) {
    final cleanedNumber = cleanNumber(number);
    if (cleanedNumber.startsWith("+22901")) {
      return number;
    }
    if (cleanedNumber.startsWith("+229")) {
      return "+22901${cleanedNumber.substring(4)}";
    }
    if (RegExp(r'^[6|9|5|4]\d{7}$').hasMatch(cleanedNumber)) {
      return "01$cleanedNumber";
    }
    return number;
  }

  void _updateSelectedContacts() {
    setState(() {
      for (var contact in contacts) {
        final id = contact.id;
        if (selectedContacts[id] == true) {
          final updatedPhones = contact.phones.map((phone) {
            final modifiedNumber = modifyBeninNumber(phone.number);
            return Phone(
              modifiedNumber, // Le numéro modifié passe en premier (paramètre positionnel)
              label: phone.label, // Utilise le label existant
              isPrimary: phone.isPrimary, // Conserve la valeur de priorité
            );
          }).toList();

          // Update contact
          contact.phones = updatedPhones;
          try {
            FlutterContacts.updateContact(contact);
            print("Contact mis à jour : ${contact.displayName}");
          } catch (e) {
            print(
                "Erreur lors de la mise à jour de ${contact.displayName}: $e");
          }
        }
      }

      // Reset selection
      selectedContacts.updateAll((key, value) => false);
      _selectAll = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Contacts updated successfully!')),
    );
  }

  Future<void> confirmUpdate() async {
    if (selectedContacts.values.any((isSelected) => isSelected)) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: lightColorScheme.onPrimary,
          title: const Text("Confirmation"),
          content: const Text(
            "Vous êtes sur le point de modifier tous les contacts sélectionnés en ajoutant le préfix '01'. Voulez-vous continuer ?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Annuler"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _updateSelectedContacts();
              },
              child: const Text("Confirmer"),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Aucun contact sélectionné.")),
      );
    }
  }

  void _toggleSelectAll() {
    setState(() {
      _selectAll = !_selectAll;
      selectedContacts.updateAll((key, value) => _selectAll);
    });
  }

  int _getSelectedCount() {
    return selectedContacts.values.where((selected) => selected).length;
  }

  // Warning
  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('isFirstLaunch') ?? true;

    if (isFirstLaunch) {
      // Afficher l'avertissement
      _showWarningDialog();
      // Marquer l'application comme déjà ouverte
      await prefs.setBool('isFirstLaunch', false);
    }
  }

  void _showWarningDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Empêche la fermeture en dehors du dialogue
      builder: (context) => AlertDialog(
        backgroundColor: lightColorScheme.onPrimary,
        title: const Text("Conditions d'utilisation"),
        content: const Text(
          " En utilisant cette application, vous acceptez que les numéros de téléphone de vos contacts puissent être modifiés automatiquement selon les règles définies. "
          "Nous ne sommes pas responsables des erreurs ou des pertes de données. Veuillez sauvegarder vos contacts avant de continuer.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Fermer la boîte de dialogue
            },
            child: const Text("J'accepte"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenWidth = screenSize.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightColorScheme.primary,
        title: Text(
          "Port Autonome de cotonou ${_getSelectedCount() < 1 ? '' : '(${_getSelectedCount()})'}",
          style: TextStyle(
            color: lightColorScheme.onPrimary,
            fontSize: screenWidth * 0.04,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _selectAll ? Icons.check_box : Icons.check_box_outline_blank,
              color: lightColorScheme.onPrimary,
            ),
            onPressed: _toggleSelectAll,
          ),
          IconButton(
            icon: Icon(
              Icons.refresh,
              color: lightColorScheme.onPrimary,
              size: screenWidth * 0.06,
            ),
            onPressed: fetchContacts,
          ),
          PopupMenuButton<String>(
            // padding: const EdgeInsets.all(-1.0),
            color: lightColorScheme.onPrimary,
            onSelected: (value) {
              if (value == 'A propos') {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const About()),
                );
              }
            },
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  value: 'A propos',
                  child: Text(
                    'A propos',
                    style: TextStyle(
                      color: lightColorScheme.surface,
                      fontSize: screenWidth * 0.04,
                    ),
                  ),
                ),
              ];
            },
          ),
        ],
      ),
      backgroundColor: lightColorScheme.onPrimary,
      body: contacts.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: contacts.length,
              itemBuilder: (context, index) {
                final contact = contacts[index];
                final phoneNumbers =
                    contact.phones.map((phone) => phone.number).join(", ");

                return CheckboxListTile(
                  title: Text(
                    contact.displayName,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: lightColorScheme.surface),
                  ),
                  subtitle: Text(
                    phoneNumbers,
                    style: TextStyle(
                        color: lightColorScheme.surface.withOpacity(0.8)),
                  ),
                  value: selectedContacts[contact.id] ?? false,
                  onChanged: (isSelected) {
                    setState(() {
                      selectedContacts[contact.id] = isSelected!;
                      _selectAll = selectedContacts.values.every((selected) => selected);
                    });
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: confirmUpdate,
        child: const Icon(Icons.edit),
      ),
    );
  }
}
