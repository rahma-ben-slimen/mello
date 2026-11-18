
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../widgets/mello_logo.dart';
import '../widgets/mello_button.dart';
import '../widgets/mello_text_field.dart';
import 'sign_in_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _dateController = TextEditingController();
  final _villeController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _hidePassword = true;
  bool _hideConfirmPassword = true;

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _telephoneController.dispose();
    _dateController.dispose();
    _villeController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Sélection de la date de naissance
  
Future<void> _selectDate() async {
  final now = DateTime.now();

  // Âge minimum : 18 ans
  final maxBirthDate = DateTime(
    now.year - 18,
    now.month,
    now.day,
  );

  final DateTime? pickedDate = await showDatePicker(
    context: context,
    initialDate: DateTime(2000),
    firstDate: DateTime(1920),
    lastDate: maxBirthDate,
    locale: const Locale('fr', 'FR'),
    helpText: 'Sélectionner votre date de naissance',
    cancelText: 'Annuler',
    confirmText: 'Confirmer',
  );

  if (pickedDate != null) {
    setState(() {
      final day = pickedDate.day.toString().padLeft(2, '0');
      final month = pickedDate.month.toString().padLeft(2, '0');
      final year = pickedDate.year;

      _dateController.text = '$day/$month/$year';
    });
  }
}

  // Validation du formulaire
  void _register() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Formulaire valide : inscription à relier au backend.',
          ),
        ),
      );
    }
  }

 

  // Validation du nom, prénom et ville
  String? _nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Ce champ est obligatoire';
    }

    if (!RegExp(r"^[a-zA-ZÀ-ÿ\s'-]+$").hasMatch(value.trim())) {
      return 'Veuillez saisir uniquement des lettres';
    }

    return null;
  }

  // Validation de l'adresse e-mail
  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez saisir votre adresse e-mail';
    }

    if (!RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    ).hasMatch(value.trim())) {
      return 'Adresse e-mail invalide';
    }

    return null;
  }

  // Validation du numéro de téléphone
  String? _telephoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Veuillez saisir votre numéro';
    }

    if (!RegExp(r'^[0-9]{8}$').hasMatch(value.trim())) {
      return 'Le numéro doit contenir 8 chiffres';
    }

    return null;
  }

  // Validation de la date de naissance
  
String? _dateValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'Veuillez sélectionner votre date de naissance';
  }

  try {
    final parts = value.split('/');

    if (parts.length != 3) {
      return 'Format de date invalide';
    }

    final day = int.parse(parts[0]);
    final month = int.parse(parts[1]);
    final year = int.parse(parts[2]);

    final birthDate = DateTime(year, month, day);
    final now = DateTime.now();

    // Vérifier que la date existe réellement
    if (birthDate.day != day ||
        birthDate.month != month ||
        birthDate.year != year) {
      return 'Date de naissance invalide';
    }

    // Vérifier la date future
    if (birthDate.isAfter(now)) {
      return 'La date ne peut pas être dans le futur';
    }

    // Vérifier l'âge minimum de 18 ans
    final minBirthDate = DateTime(
      now.year - 18,
      now.month,
      now.day,
    );

    if (birthDate.isAfter(minBirthDate)) {
      return 'Vous devez avoir au moins 18 ans';
    }

    return null;
  } catch (e) {
    return 'Date de naissance invalide';
  }
}

  // Validation du mot de passe
  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez saisir un mot de passe';
    }

    if (value.length < 8) {
      return '8 caractères minimum';
    }

    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Ajoutez au moins une majuscule';
    }

    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Ajoutez au moins une minuscule';
    }

    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Ajoutez au moins un chiffre';
    }

    return null;
  }

  // Confirmation du mot de passe
  String? _confirmPasswordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Veuillez confirmer votre mot de passe';
    }

    if (value != _passwordController.text) {
      return 'Les mots de passe ne correspondent pas';
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MelloColors.linen,
        foregroundColor: MelloColors.espresso,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                const Center(
                  child: MelloLogo(
                    iconSize: 100,
                  ),
                ),

                const SizedBox(height: 30),

                const Text(
                  'Créer un compte',
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: MelloColors.espresso,
                  ),
                ),

                const SizedBox(height: 8),

                const Text(
                  'Rejoignez Mello et prenez soin de votre bien-être.',
                  style: TextStyle(
                    fontSize: 14,
                    color: MelloColors.cocoa,
                  ),
                ),

                const SizedBox(height: 25),

                // Nom
                MelloTextField(
                  label: 'Nom',
                  hint: 'Votre nom',
                  controller: _nomController,
                  validator: _nameValidator,
                ),

                const SizedBox(height: 18),

                // Prénom
                MelloTextField(
                  label: 'Prénom',
                  hint: 'Votre prénom',
                  controller: _prenomController,
                  validator: _nameValidator,
                ),

                const SizedBox(height: 18),

                // Adresse e-mail
                MelloTextField(
                  label: 'Adresse e-mail',
                  hint: 'exemple@email.com',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: _emailValidator,
                ),

                const SizedBox(height: 18),

                // Téléphone
                MelloTextField(
                  label: 'Téléphone',
                  hint: 'Votre numéro de téléphone',
                  controller: _telephoneController,
                  keyboardType: TextInputType.phone,
                  validator: _telephoneValidator,
                ),

                const SizedBox(height: 18),

                // Date de naissance
                MelloTextField(
                  label: 'Date de naissance',
                  hint: 'JJ/MM/AAAA',
                  controller: _dateController,
                  readOnly: true,
                  onTap: _selectDate,
                  suffixIcon: const Icon(
                    Icons.calendar_month_outlined,
                    color: MelloColors.cocoa,
                  ),
                  validator: _dateValidator,
                ),

                const SizedBox(height: 18),

                // Ville
                MelloTextField(
                  label: 'Ville',
                  hint: 'Votre ville',
                  controller: _villeController,
                  validator: _nameValidator,
                ),

                const SizedBox(height: 18),

                // Mot de passe
                MelloTextField(
                  label: 'Mot de passe',
                  hint: '8 caractères minimum',
                  controller: _passwordController,
                  obscureText: _hidePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hidePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: MelloColors.cocoa,
                    ),
                    onPressed: () {
                      setState(() {
                        _hidePassword = !_hidePassword;
                      });
                    },
                  ),
                  validator: _passwordValidator,
                ),

                const SizedBox(height: 18),

                // Confirmation du mot de passe
                MelloTextField(
                  label: 'Confirmer le mot de passe',
                  hint: 'Répétez votre mot de passe',
                  controller: _confirmPasswordController,
                  obscureText: _hideConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _hideConfirmPassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: MelloColors.cocoa,
                    ),
                    onPressed: () {
                      setState(() {
                        _hideConfirmPassword =
                            !_hideConfirmPassword;
                      });
                    },
                  ),
                  validator: _confirmPasswordValidator,
                ),

                const SizedBox(height: 30),

                // Bouton inscription
                MelloButton(
                  text: 'Créer mon compte',
                  onPressed: _register,
                ),

                const SizedBox(height: 20),

                // Navigation vers la connexion
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Flexible(
                      child: Text(
                        'Vous avez déjà un compte ?',
                        style: TextStyle(
                          color: MelloColors.espresso,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignInPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Se connecter',
                        style: TextStyle(
                          color: MelloColors.cocoa,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
