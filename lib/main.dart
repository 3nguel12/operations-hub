// ==========================================
// OPERATIONS HUB - FLUTTER CODEBASE
// Compatible with iOS, Android & Firebase
// Clean Architecture, Material 3 & Real-time Agenda
// ==========================================

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // Ensure Firebase is initialized for real-time synchronization
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }
  runApp(const OperationsHubApp());
}

// ------------------------------------------
// DESIGN SYSTEM: Precision Flow Palette
// ------------------------------------------
class PrecisionFlowTheme {
  static const Color primary = Color(0xFF091426);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF505F76);
  static const Color background = Color(0xFFF7F9FB);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color error = Color(0xFFEF4444);
  static const Color borderSubtle = Color(0xFFE2E8F0);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: const ColorScheme.light(
        primary: primary,
        onPrimary: onPrimary,
        secondary: secondary,
        background: background,
        surface: surface,
        error: error,
      ),
      fontFamily: 'Inter',
      scaffoldBackgroundColor: background,
      cardTheme: CardThemeData(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderSubtle, width: 1),
        ),
      ),
    );
  }
}

// ------------------------------------------
// MAIN APPLICATION ROOT
// ------------------------------------------
class OperationsHubApp extends StatelessWidget {
  const OperationsHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Operations Hub',
      theme: PrecisionFlowTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const LoginScreen(),
    );
  }
}

// ------------------------------------------
// SCREEN 1: ONBOARDING / INTRO
// ------------------------------------------
class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              // Time & Efficiency Illustration
              Center(
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        )
                      ]
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.calendar_month,
                        size: 100,
                        color: Colors.teal,
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        "TIME & EFFICIENCY",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: PrecisionFlowTheme.primary,
                          letterSpacing: 1.1,
                        ),
                      ),
                      Text(
                        "Manage Your Schedule Seamlessly",
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.teal.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),
              const Text(
                "Simplifica tu tiempo",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: PrecisionFlowTheme.primary,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "El ecosistema Operations Hub ayuda a las pymes a gestionar agendas y citas con cero fricciones, conectando profesionales y clientes al instante.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.5,
                  color: PrecisionFlowTheme.secondary,
                ),
              ),
              const Spacer(),
              // "Comenzar" Button
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PrecisionFlowTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Comenzar",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              const SizedBox(height: 12),
              // "Omitir" Text Link
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text(
                  "Omitir",
                  style: TextStyle(
                    color: PrecisionFlowTheme.secondary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------
// SCREEN 2: LOGIN WITH ROLE SELECTION
// ------------------------------------------
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isClientSelected = true;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo & Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.hub, size: 36, color: PrecisionFlowTheme.primary),
                  const SizedBox(width: 8),
                  const Text(
                    "Operations Hub",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: PrecisionFlowTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "Acceso seguro a tu panel de control",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: PrecisionFlowTheme.secondary,
                ),
              ),
              const SizedBox(height: 32),

              // Role Selectors
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isClientSelected = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isClientSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isClientSelected ? PrecisionFlowTheme.primary : PrecisionFlowTheme.borderSubtle,
                            width: isClientSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: isClientSelected ? PrecisionFlowTheme.primary : PrecisionFlowTheme.secondary,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Soy Cliente",
                              style: TextStyle(
                                fontWeight: isClientSelected ? FontWeight.bold : FontWeight.normal,
                                color: isClientSelected ? PrecisionFlowTheme.primary : PrecisionFlowTheme.secondary,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isClientSelected = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: !isClientSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: !isClientSelected ? PrecisionFlowTheme.primary : PrecisionFlowTheme.borderSubtle,
                            width: !isClientSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.storefront_outlined,
                              color: !isClientSelected ? PrecisionFlowTheme.primary : PrecisionFlowTheme.secondary,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Soy Dueño",
                              style: TextStyle(
                                fontWeight: !isClientSelected ? FontWeight.bold : FontWeight.normal,
                                color: !isClientSelected ? PrecisionFlowTheme.primary : PrecisionFlowTheme.secondary,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Email Input
              const Text(
                "Correo Electrónico",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.mail_outline),
                  hintText: "ejemplo@correo.com",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: PrecisionFlowTheme.borderSubtle),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),

              // Password Input
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Contraseña",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                  TextButton(
                    onPressed: () {},
                    style: TextButton.styleFrom(padding: EdgeInsets.zero),
                    child: const Text(
                      "¿Olvidaste tu contraseña?",
                      style: TextStyle(fontSize: 12, color: PrecisionFlowTheme.secondary),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  hintText: "••••••••",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: PrecisionFlowTheme.borderSubtle),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 24),

              // Log In Button
              ElevatedButton(
                onPressed: () async {
                  final email = _emailController.text.trim();
                  final password = _passwordController.text;

                  if (email.isEmpty || password.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Por favor ingresa tu correo y contraseña")),
                    );
                    return;
                  }

                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const Center(child: CircularProgressIndicator()),
                  );

                  try {
                    // Try to authenticate
                    final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email,
                      password: password,
                    );

                    // Fetch user role from Firestore
                    final uid = userCredential.user?.uid;
                    String role = isClientSelected ? "client" : "owner"; // fallback to UI toggle

                    if (uid != null) {
                      final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
                      if (doc.exists && doc.data()?['role'] != null) {
                        role = doc.data()?['role'] as String;
                      }
                    }

                    if (mounted) {
                      Navigator.pop(context); // Close loading dialog
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => role == "client"
                              ? const ClientNavigationHub()
                              : const OwnerNavigationHub(),
                        ),
                      );
                    }
                  } catch (e) {
                    debugPrint("Login failed: $e");
                    if (mounted) {
                      Navigator.pop(context); // Close loading dialog
                      
                      // For convenience in testing (in case Firebase is not connected or there's no internet),
                      // let's show a snackbar and allow them to proceed with the selected toggle in the UI:
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Error de autenticación: ${e.toString().split(']').last.trim()}. Accediendo con simulación."),
                          backgroundColor: Colors.orange,
                          duration: const Duration(seconds: 5),
                          action: SnackBarAction(
                            label: "Entrar",
                            textColor: Colors.white,
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => isClientSelected
                                      ? const ClientNavigationHub()
                                      : const OwnerNavigationHub(),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: PrecisionFlowTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  "Iniciar Sesión",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

              // Sign Up Button
              OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const SignUpScreen()),
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: PrecisionFlowTheme.primary,
                  side: const BorderSide(color: PrecisionFlowTheme.primary),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "Crear cuenta",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------
// CLIENT PORTION: LAYOUT & NAVIGATION
// ------------------------------------------
class ClientNavigationHub extends StatefulWidget {
  final int initialIndex;
  const ClientNavigationHub({super.key, this.initialIndex = 0});

  @override
  State<ClientNavigationHub> createState() => _ClientNavigationHubState();
}

class _ClientNavigationHubState extends State<ClientNavigationHub> {
  late int _currentIndex;
  final List<Widget> _screens = [
    const ClientExploreScreen(),
    const ClientAppointmentsScreen(),
    const Center(child: Text("Favoritos", style: TextStyle(fontSize: 18))),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: PrecisionFlowTheme.primary,
        unselectedItemColor: PrecisionFlowTheme.secondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.explore_outlined), label: "Explorar"),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_today_outlined), label: "Reservas"),
          BottomNavigationBarItem(icon: Icon(Icons.favorite_border_outlined), label: "Favoritos"),
        ],
      ),
    );
  }
}

class ClientExploreScreen extends StatefulWidget {
  const ClientExploreScreen({super.key});

  @override
  State<ClientExploreScreen> createState() => _ClientExploreScreenState();
}

class _ClientExploreScreenState extends State<ClientExploreScreen> {
  String? _selectedCategory; // null means "Todas"

  final List<Map<String, dynamic>> _businesses = [
    {
      "name": "The Classic Trim",
      "category": "Barberías",
      "subtitle": "1.2 km away • Downtown",
      "rating": "4.8",
      "hours": "Abierto ahora",
      "isGreen": true,
      "imageUrl": "https://images.unsplash.com/photo-1503951914875-452162b0f3f1?auto=format&fit=crop&q=80&w=600",
      "services": [
        {"name": "Lifestyle Consultation", "duration": "60 min", "price": "\$150"},
        {"name": "Event Planning Discovery", "duration": "45 min", "price": "\$100"},
        {"name": "Travel Itinerary Review", "duration": "30 min", "price": "\$75"}
      ]
    },
    {
      "name": "Lumina Beauty Studio",
      "category": "Salones de Belleza",
      "subtitle": "2.5 km away • Westside",
      "rating": "4.9",
      "hours": "Cierra a las 19:00",
      "isGreen": false,
      "imageUrl": "https://images.unsplash.com/photo-1560066984-138dadb4c035?auto=format&fit=crop&q=80&w=600",
      "services": [
        {"name": "Corte de Cabello Premium", "duration": "45 min", "price": "\$50"},
        {"name": "Manicura & Pedicura", "duration": "60 min", "price": "\$40"},
        {"name": "Tratamiento Facial Hidratante", "duration": "75 min", "price": "\$85"}
      ]
    },
    {
      "name": "Luxe Concierge",
      "category": "Talleres",
      "subtitle": "0.5 km away • Beverly Hills",
      "rating": "4.9",
      "hours": "Abierto ahora",
      "isGreen": true,
      "imageUrl": "https://images.unsplash.com/photo-1486406146926-c627a92ad1ab?auto=format&fit=crop&q=80&w=600",
      "services": [
        {"name": "Asesoramiento de Estilo", "duration": "60 min", "price": "\$120"},
        {"name": "Planificación de Eventos", "duration": "90 min", "price": "\$200"},
        {"name": "Coordinación de Viajes", "duration": "120 min", "price": "\$180"}
      ]
    },
    {
      "name": "Clínica Dental del Sol",
      "category": "Consultorios",
      "subtitle": "0.8 km away • Medical District",
      "rating": "4.7",
      "hours": "Abierto ahora",
      "isGreen": true,
      "imageUrl": "https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&q=80&w=600",
      "services": [
        {"name": "Limpieza Dental General", "duration": "45 min", "price": "\$60"},
        {"name": "Consulta de Diagnóstico", "duration": "30 min", "price": "\$40"}
      ]
    },
    {
      "name": "Pediatría Integral & Bienestar",
      "category": "Consultorios",
      "subtitle": "2.1 km away • Plaza Médica",
      "rating": "4.9",
      "hours": "Cierra a las 18:00",
      "isGreen": false,
      "imageUrl": "https://images.unsplash.com/photo-1576091160550-2173dba999ef?auto=format&fit=crop&q=80&w=600",
      "services": [
        {"name": "Consulta Pediátrica", "duration": "40 min", "price": "\$80"},
        {"name": "Control de Crecimiento", "duration": "30 min", "price": "\$50"}
      ]
    },
    {
      "name": "CardioCare Centro Médico",
      "category": "Consultorios",
      "subtitle": "3.5 km away • North Hospital Area",
      "rating": "4.8",
      "hours": "Abierto ahora",
      "isGreen": true,
      "imageUrl": "https://images.unsplash.com/photo-1584515979956-d9f6e5d09982?auto=format&fit=crop&q=80&w=600",
      "services": [
        {"name": "Electrocardiograma & Consulta", "duration": "60 min", "price": "\$150"},
        {"name": "Chequeo Cardiovascular", "duration": "90 min", "price": "\$200"}
      ]
    }
  ];

  @override
  Widget build(BuildContext context) {
    final filteredBusinesses = _selectedCategory == null
        ? _businesses
        : _businesses.where((b) => b['category'] == _selectedCategory).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Recomendados para ti", style: TextStyle(fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: const CircleAvatar(
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=150'),
              radius: 18,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ClientSettingsScreen()),
              );
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Bar
            TextField(
              decoration: InputDecoration(
                hintText: "Buscar servicios o negocios...",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(24),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Filters
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildFilterChip("Todas", isSelected: _selectedCategory == null, onSelected: () {
                    setState(() {
                      _selectedCategory = null;
                    });
                  }),
                  const SizedBox(width: 8),
                  _buildFilterChip("Barberías", isSelected: _selectedCategory == "Barberías", onSelected: () {
                    setState(() {
                      _selectedCategory = "Barberías";
                    });
                  }),
                  const SizedBox(width: 8),
                  _buildFilterChip("Salones de Belleza", isSelected: _selectedCategory == "Salones de Belleza", onSelected: () {
                    setState(() {
                      _selectedCategory = "Salones de Belleza";
                    });
                  }),
                  const SizedBox(width: 8),
                  _buildFilterChip("Talleres", isSelected: _selectedCategory == "Talleres", onSelected: () {
                    setState(() {
                      _selectedCategory = "Talleres";
                    });
                  }),
                  const SizedBox(width: 8),
                  _buildFilterChip("Consultorios", isSelected: _selectedCategory == "Consultorios", onSelected: () {
                    setState(() {
                      _selectedCategory = "Consultorios";
                    });
                  }),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Recommendation Cards
            if (filteredBusinesses.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Text("No hay negocios en esta categoría.", style: TextStyle(color: PrecisionFlowTheme.secondary)),
                ),
              )
            else
              ...filteredBusinesses.map((b) => Padding(
                    padding: const EdgeInsets.only(bottom: 16.0),
                    child: _buildBusinessCard(context, b),
                  )),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, {required bool isSelected, required VoidCallback onSelected}) {
    return GestureDetector(
      onTap: onSelected,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? PrecisionFlowTheme.primary : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildBusinessCard(BuildContext context, Map<String, dynamic> business) {
    final title = business['name'] as String;
    final subtitle = business['subtitle'] as String;
    final rating = business['rating'] as String;
    final hours = business['hours'] as String;
    final isGreen = business['isGreen'] as bool;
    final imageUrl = business['imageUrl'] as String;
    final services = List<Map<String, String>>.from(
      (business['services'] as List).map((s) => Map<String, String>.from(s)),
    );

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusinessDetailScreen(
              name: title,
              imageUrl: imageUrl,
              rating: rating,
              subtitle: subtitle,
              hours: hours,
              services: services,
            ),
          ),
        );
      },
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Stack(
              children: [
                Image.network(imageUrl, height: 160, width: double.infinity, fit: BoxFit.cover),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(rating, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: const TextStyle(color: PrecisionFlowTheme.secondary, fontSize: 13)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(Icons.circle, color: isGreen ? Colors.green : Colors.amber, size: 8),
                          const SizedBox(width: 6),
                          Text(
                             hours,
                             style: TextStyle(
                               color: isGreen ? Colors.green.shade800 : Colors.amber.shade800,
                               fontSize: 12,
                               fontWeight: FontWeight.w600,
                             ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Icon(Icons.arrow_forward, color: PrecisionFlowTheme.secondary),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------
// SCREEN 3: BUSINESS DETAILS (LUXE CONCIERGE)
// ------------------------------------------
class BusinessDetailScreen extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String rating;
  final String subtitle;
  final String hours;
  final List<Map<String, String>> services;

  const BusinessDetailScreen({
    super.key,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.subtitle,
    required this.hours,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Hero Image
              Image.network(imageUrl, height: 260, fit: BoxFit.cover),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text("$rating (128)", style: const TextStyle(fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(color: PrecisionFlowTheme.secondary)),
                    const SizedBox(height: 16),
                    Row(
                      children: const [
                        Icon(Icons.location_on_outlined, color: PrecisionFlowTheme.secondary),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text("123 Luxury Ave, Suite 400, Beverly Hills, CA 90210"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.access_time, color: PrecisionFlowTheme.secondary),
                        const SizedBox(width: 8),
                        Text(hours),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text("Servicios", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),

                    // Services list
                    ...services.map((svc) => _buildServiceItem(
                          context,
                          svc['name']!,
                          svc['duration']!,
                          svc['price']!,
                        )),
                  ],
                ),
              ),
              const Spacer(),
              // Booking CTA
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClientBookingLandingScreen(
                          businessName: name,
                          services: services,
                        ),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PrecisionFlowTheme.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text("Reservar Cita", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
            ],
          ),
          // Back Button Overlay
          Positioned(
            top: 40,
            left: 16,
            child: CircleAvatar(
              backgroundColor: Colors.white.withValues(alpha: 0.9),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black87),
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context, String title, String duration, String price) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ClientBookingLandingScreen(
              businessName: name,
              initialService: title,
              initialDuration: duration,
              initialPrice: price,
              services: services,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: PrecisionFlowTheme.borderSubtle),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(height: 4),
                Text(duration, style: const TextStyle(color: PrecisionFlowTheme.secondary, fontSize: 12)),
              ],
            ),
            Row(
              children: [
                Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, color: PrecisionFlowTheme.secondary),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------
// SCREEN 4: SERVICE SELECTION & BOOKING CALENDAR
// ------------------------------------------
class ClientBookingLandingScreen extends StatefulWidget {
  final String? businessName;
  final String? initialService;
  final String? initialDuration;
  final String? initialPrice;
  final List<Map<String, String>>? services;

  const ClientBookingLandingScreen({
    super.key,
    this.businessName,
    this.initialService,
    this.initialDuration,
    this.initialPrice,
    this.services,
  });

  @override
  State<ClientBookingLandingScreen> createState() => _ClientBookingLandingScreenState();
}

class _ClientBookingLandingScreenState extends State<ClientBookingLandingScreen> {
  late int step;
  String? selectedService;
  String? selectedDuration;
  String? selectedPrice;

  DateTime _focusedDate = DateTime.now();
  late DateTime _selectedDate;
  String selectedTimeSlot = "10:30 AM";

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    if (widget.initialService != null) {
      selectedService = widget.initialService;
      selectedDuration = widget.initialDuration;
      selectedPrice = widget.initialPrice;
      step = 2; // Jump directly to date and time select
    } else {
      step = 1; // Start with service selection
    }
  }

  String get _formattedSelectedDate {
    return DateFormat('EEEE, MMMM d, yyyy').format(_selectedDate);
  }

  DateTime get _startOfWeek {
    final int difference = _focusedDate.weekday % 7;
    return _focusedDate.subtract(Duration(days: difference));
  }

  String _calculateEndTime(String startTime, String duration) {
    try {
      int minutes = 0;
      final cleanDuration = duration.toLowerCase();
      if (cleanDuration.contains('h')) {
        final hourPart = cleanDuration.split('h')[0].trim();
        final hours = double.tryParse(hourPart) ?? 1.0;
        minutes = (hours * 60).toInt();
      } else {
        minutes = int.parse(cleanDuration.replaceAll(RegExp(r'[^0-9]'), ''));
      }
      final DateFormat parser = DateFormat("hh:mm a");
      final DateTime parsedStart = parser.parse(startTime);
      final DateTime parsedEnd = parsedStart.add(Duration(minutes: minutes));
      return DateFormat("hh:mm a").format(parsedEnd);
    } catch (e) {
      return "11:30 AM";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Paso $step de 2", style: const TextStyle(fontSize: 14, color: PrecisionFlowTheme.secondary)),
        centerTitle: true,
      ),
      body: step == 1 ? _buildStep1Service() : _buildStep2Calendar(),
    );
  }

  Widget _buildStep1Service() {
    final List<Map<String, String>> displayedServices = widget.services ?? [
      {"name": "Initial Consultation", "desc": "A comprehensive 45-minute assessment to understand your needs.", "duration": "45 min", "price": "\$100"},
      {"name": "Follow-up Session", "desc": "A standard 30-minute review to track progress.", "duration": "30 min", "price": "\$60"},
      {"name": "Group Workshop", "desc": "A 90-minute collaborative session on specific topics.", "duration": "90 min", "price": "\$150"},
    ];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Select a Service",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Choose the type of appointment you need.",
            textAlign: TextAlign.center,
            style: TextStyle(color: PrecisionFlowTheme.secondary),
          ),
          const SizedBox(height: 24),
          ...displayedServices.map((svc) => _buildServiceCard(
                svc['name']!,
                svc['desc'] ?? "Servicio profesional para ti.",
                svc['duration']!,
                svc['price']!,
                Icons.security,
              )),
        ],
      ),
    );
  }

  Widget _buildServiceCard(String title, String desc, String time, String price, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, color: PrecisionFlowTheme.primary, size: 36),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            ),
            Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: PrecisionFlowTheme.primary)),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 6),
            Text(desc, style: const TextStyle(fontSize: 13, color: PrecisionFlowTheme.secondary)),
            const SizedBox(height: 8),
            Text(time, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          ],
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: () {
          setState(() {
            selectedService = title;
            selectedDuration = time;
            selectedPrice = price;
            step = 2;
          });
        },
      ),
    );
  }

  Widget _buildStep2Calendar() {
    final activeService = selectedService ?? "Servicio";
    final activeDuration = selectedDuration ?? "60 min";
    final activePrice = selectedPrice ?? "";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            "Select an Appointment",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            "Choose your preferred date and available time slot.",
            textAlign: TextAlign.center,
            style: TextStyle(color: PrecisionFlowTheme.secondary),
          ),
          const SizedBox(height: 20),

          // Simulated Calendar
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        DateFormat('MMMM yyyy').format(_focusedDate),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: () {
                              setState(() {
                                _focusedDate = _focusedDate.subtract(const Duration(days: 7));
                              });
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () {
                              setState(() {
                                _focusedDate = _focusedDate.add(const Duration(days: 7));
                              });
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                  const Divider(),
                  // Calendar Days Row & Numbers
                  const Text("S  M  T  W  T  F  S", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(7, (index) {
                      final day = _startOfWeek.add(Duration(days: index));
                      final isSelected = day.year == _selectedDate.year &&
                          day.month == _selectedDate.month &&
                          day.day == _selectedDate.day;
                      return _calendarDay(day, isSelected: isSelected);
                    }),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Time Grid
          Text(_formattedSelectedDate, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.8,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _timeSlot("09:00 AM", selectedTimeSlot == "09:00 AM"),
              _timeSlot("09:30 AM", selectedTimeSlot == "09:30 AM"),
              _timeSlot("10:30 AM", selectedTimeSlot == "10:30 AM"),
              _timeSlot("11:00 AM", selectedTimeSlot == "11:00 AM"),
            ],
          ),
          const SizedBox(height: 24),

          // Selection Summary
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.green),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_formattedSelectedDate, style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text(
                        "$selectedTimeSlot - ${_calculateEndTime(selectedTimeSlot, activeDuration)} ($activeDuration)",
                        style: const TextStyle(color: PrecisionFlowTheme.secondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Servicio: $activeService ($activePrice)",
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12, color: PrecisionFlowTheme.primary),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 24),

          ElevatedButton(
            onPressed: () async {
              final businessStr = widget.businessName ?? "General Business";
              final dateStr = _formattedSelectedDate;
              final timeStr = selectedTimeSlot;
              final durationStr = activeDuration;
              final priceStr = activePrice;
              final serviceStr = activeService;

              showDialog(
                context: context,
                barrierDismissible: false,
                builder: (context) => const Center(child: CircularProgressIndicator()),
              );

              try {
                // Connect with Firebase Firestore database logic
                await FirebaseFirestore.instance.collection('appointments').add({
                  'businessName': businessStr,
                  'serviceName': serviceStr,
                  'duration': durationStr,
                  'price': priceStr,
                  'date': dateStr,
                  'timeSlot': timeStr,
                  'status': 'CONFIRMED',
                  'createdAt': FieldValue.serverTimestamp(),
                  'clientId': FirebaseAuth.instance.currentUser?.uid ?? 'anonymous_client',
                });

                if (mounted) {
                  Navigator.pop(context); // Close loading dialog
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Cita para $serviceStr en $businessStr Agendada Exitosamente!"),
                      backgroundColor: PrecisionFlowTheme.success,
                    ),
                  );
                  // Redirect to Reservas tab (index 1) in navigation hub
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ClientNavigationHub(initialIndex: 1),
                    ),
                    (route) => false,
                  );
                }
              } catch (e) {
                debugPrint("Firestore write failed: $e");
                if (mounted) {
                  Navigator.pop(context); // Close loading dialog
                  // Fallback to local simulation to ensure fully testing capabilities
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Cita para $serviceStr Agendada (Simulado localmente)"),
                      backgroundColor: Colors.orange,
                    ),
                  );
                  // Redirect to Reservas tab (index 1) in navigation hub
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ClientNavigationHub(initialIndex: 1),
                    ),
                    (route) => false,
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: PrecisionFlowTheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Confirmar Cita", style: TextStyle(fontWeight: FontWeight.bold)),
          )
        ],
      ),
    );
  }

  Widget _calendarDay(DateTime date, {bool isSelected = false}) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDate = date;
        });
      },
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isSelected ? PrecisionFlowTheme.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          date.day.toString(),
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _timeSlot(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTimeSlot = label;
        });
      },
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFD2E3FC) : Colors.white,
          border: Border.all(
            color: isSelected ? PrecisionFlowTheme.primary : PrecisionFlowTheme.borderSubtle,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? PrecisionFlowTheme.primary : Colors.black87,
          ),
        ),
      ),
    );
  }
}

// ------------------------------------------
// SCREEN 5: MY APPOINTMENTS (CLIENT VIEW)
// ------------------------------------------
class ClientAppointmentsScreen extends StatelessWidget {
  const ClientAppointmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mis Citas", style: TextStyle(fontWeight: FontWeight.bold)),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Próximas"),
              Tab(text: "Historial"),
            ],
            labelColor: PrecisionFlowTheme.primary,
            unselectedLabelColor: PrecisionFlowTheme.secondary,
            indicatorColor: PrecisionFlowTheme.primary,
          ),
        ),
        body: TabBarView(
          children: [
            // Próximas List with StreamBuilder from Firestore
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('appointments')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                List<Widget> cards = [];

                if (snapshot.hasData) {
                  for (var doc in snapshot.data!.docs) {
                    final data = doc.data() as Map<String, dynamic>;
                    final service = data['serviceName'] ?? 'Lifestyle Consultation';
                    final business = data['businessName'] ?? 'The Classic Trim';
                    final date = data['date'] ?? 'Thursday, October 12';
                    final time = data['timeSlot'] ?? '10:30 AM';
                    final duration = data['duration'] ?? '60 min';
                    final price = data['price'] ?? '';
                    final status = data['status'] ?? 'CONFIRMED';

                    Color statusColor = Colors.green;
                    String statusText = "Confirmada";
                    if (status == "PENDING") {
                      statusColor = Colors.amber;
                      statusText = "Pendiente";
                    } else if (status == "CANCELLED") {
                      statusColor = Colors.red;
                      statusText = "Cancelada";
                    }

                    cards.add(
                      _buildAppointmentCard(
                        context,
                        business,
                        "$service ($price)",
                        date,
                        "$time ($duration)",
                        statusText,
                        statusColor,
                        isHistory: status == "CANCELLED" || status == "COMPLETED",
                        isFirebase: true,
                        docId: doc.id,
                      ),
                    );
                    cards.add(const SizedBox(height: 16));
                  }
                }

                // Add the default static mock appointments
                cards.add(
                  _buildAppointmentCard(
                    context,
                    "Dr. Silva Dental Clinic",
                    "123 Health Ave, Suite 4B",
                    "Oct 24, 2023",
                    "10:00 AM - 11:00 AM",
                    "Confirmada",
                    Colors.green,
                  ),
                );
                cards.add(const SizedBox(height: 16));
                cards.add(
                  _buildAppointmentCard(
                    context,
                    "Zenith Spa & Wellness",
                    "45 Relaxation Blvd.",
                    "Oct 26, 2023",
                    "2:30 PM - 4:00 PM",
                    "Pendiente",
                    Colors.amber,
                  ),
                );

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: cards,
                );
              },
            ),
            // Historial List
            ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildAppointmentCard(
                  context,
                  "The Classic Trim",
                  "123 Main St, Downtown",
                  "Sep 12, 2023",
                  "11:00 AM",
                  "Completada",
                  Colors.grey,
                  isHistory: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppointmentCard(
    BuildContext context,
    String clinic,
    String address,
    String date,
    String time,
    String status,
    Color statusColor, {
    bool isHistory = false,
    bool isFirebase = false,
    String? docId,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(clinic, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), overflow: TextOverflow.ellipsis),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status,
                    style: TextStyle(color: statusColor, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.location_on_outlined, size: 16, color: PrecisionFlowTheme.secondary),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(address, style: const TextStyle(color: PrecisionFlowTheme.secondary, fontSize: 13), overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 16, color: PrecisionFlowTheme.secondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(date, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, size: 16, color: PrecisionFlowTheme.secondary),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(time, style: const TextStyle(fontSize: 13), overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (!isHistory) ...[
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: () async {
                  if (isFirebase && docId != null) {
                    try {
                      // Try updating status to CANCELLED in Firestore
                      await FirebaseFirestore.instance.collection('appointments').doc(docId).update({
                        'status': 'CANCELLED',
                      });
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Cita cancelada con éxito.")),
                        );
                      }
                    } catch (e) {
                      debugPrint("Failed to cancel Firestore appointment status, trying delete: $e");
                      try {
                        await FirebaseFirestore.instance.collection('appointments').doc(docId).delete();
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Cita eliminada con éxito.")),
                          );
                        }
                      } catch (err) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Error al cancelar la cita en Firestore (Simulación)")),
                          );
                        }
                      }
                    }
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Cita de simulación cancelada.")),
                    );
                  }
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: PrecisionFlowTheme.error,
                  side: const BorderSide(color: PrecisionFlowTheme.error),
                ),
                child: const Text("Cancelar"),
              )
            ]
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------
// OWNER PORTION: OPERATIONS HUB ADMIN DASHBOARD
// ------------------------------------------
class OwnerNavigationHub extends StatefulWidget {
  const OwnerNavigationHub({super.key});

  @override
  State<OwnerNavigationHub> createState() => _OwnerNavigationHubState();
}

class _OwnerNavigationHubState extends State<OwnerNavigationHub> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const OwnerDashboardScreen(),
    const OwnerServiceManagementScreen(),
    const OwnerOpeningHoursScreen(),
    const OwnerSettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: PrecisionFlowTheme.primary,
        unselectedItemColor: PrecisionFlowTheme.secondary,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.today), label: "Dashboard"),
          BottomNavigationBarItem(icon: Icon(Icons.business_center), label: "Servicios"),
          BottomNavigationBarItem(icon: Icon(Icons.schedule), label: "Horarios"),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
        ],
      ),
    );
  }
}

class OwnerDashboardScreen extends StatelessWidget {
  const OwnerDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Today", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OwnerSettingsScreen()),
              );
            },
            child: const CircleAvatar(
              backgroundImage: NetworkImage('https://images.unsplash.com/photo-1472099645785-5658abf4ff4e?auto=format&fit=crop&q=80&w=150'),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Today's Appointments", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                Text(DateFormat('MMM dd, EEEE').format(DateTime.now()), style: const TextStyle(color: PrecisionFlowTheme.secondary)),
              ],
            ),
            const SizedBox(height: 16),

            // Appointment Cards matching Screen 1 image
            _buildTimelineCard("09:00 AM", "Sarah Jenkins", "Initial Consultation", "COMPLETED", Colors.grey),
            const SizedBox(height: 12),
            _buildTimelineCard("11:00 AM", "Michael Chang", "Quarterly Review", "CONFIRMED", Colors.green),
            const SizedBox(height: 12),
            _buildTimelineCard("01:30 PM", "Elena Rodriguez", "Follow-up Call", "PENDING", Colors.amber),
            const SizedBox(height: 12),
            _buildTimelineCard("03:00 PM", "David Kim", "Onboarding Session", "RISK", Colors.red, warning: "Missed previous appointment"),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineCard(String time, String client, String service, String status, Color color, {String? warning}) {
    return Card(
      child: Container(
        decoration: BoxDecoration(
          border: Border(left: BorderSide(color: color, width: 4)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(time, style: const TextStyle(fontWeight: FontWeight.bold, color: PrecisionFlowTheme.secondary)),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                  child: Text(status, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 11)),
                )
              ],
            ),
            const SizedBox(height: 8),
            Text(client, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(service, style: const TextStyle(color: PrecisionFlowTheme.secondary)),
            if (warning != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, color: Colors.red, size: 16),
                  const SizedBox(width: 4),
                  Text(warning, style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------
// SCREEN 6: OWNER SERVICE & STAFF MANAGEMENT
// ------------------------------------------
class OwnerServiceManagementScreen extends StatelessWidget {
  const OwnerServiceManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Servicios", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add),
              label: const Text("Añadir Servicio"),
              style: ElevatedButton.styleFrom(
                backgroundColor: PrecisionFlowTheme.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),
            _buildServiceConfigRow("Consultoría Inicial Estratégica", "1h • \$150.00", "Elena R."),
            const SizedBox(height: 12),
            _buildServiceConfigRow("Auditoría de Sistemas (Anual)", "4h • \$800.00", "Elena R. +2"),
            const SizedBox(height: 12),
            _buildServiceConfigRow("Revisión de Cumplimiento", "2h • \$350.00", "Carlos M."),

            const SizedBox(height: 32),
            const Text("Personal", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildStaffAvatar("Elena Ríos", "Estratega Senior"),
                const SizedBox(width: 12),
                _buildStaffAvatar("Carlos Mendoza", "Oficial Compliance"),
                const SizedBox(width: 12),
                _buildAddStaffButton(),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildServiceConfigRow(String name, String meta, String staff) {
    return Card(
      child: ListTile(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text("$meta \nStaff: $staff", style: const TextStyle(color: PrecisionFlowTheme.secondary)),
        trailing: const Icon(Icons.edit_outlined),
        onTap: () {},
      ),
    );
  }

  Widget _buildStaffAvatar(String name, String title) {
    return Column(
      children: [
        const CircleAvatar(radius: 28, backgroundColor: Colors.grey),
        const SizedBox(height: 6),
        Text(name.split(" ")[0], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        Text(title, style: const TextStyle(color: PrecisionFlowTheme.secondary, fontSize: 11)),
      ],
    );
  }

  Widget _buildAddStaffButton() {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(color: PrecisionFlowTheme.borderSubtle, style: BorderStyle.none),
            shape: BoxShape.circle,
            color: Colors.grey.shade200,
          ),
          child: const Icon(Icons.add),
        ),
        const SizedBox(height: 6),
        const Text("Añadir", style: TextStyle(fontSize: 13)),
      ],
    );
  }
}

// ------------------------------------------
// SCREEN 7: OWNER OPERATING HOURS
// ------------------------------------------
class OwnerOpeningHoursScreen extends StatefulWidget {
  const OwnerOpeningHoursScreen({super.key});

  @override
  State<OwnerOpeningHoursScreen> createState() => _OwnerOpeningHoursScreenState();
}

class _OwnerOpeningHoursScreenState extends State<OwnerOpeningHoursScreen> {
  bool mondayOpen = true;
  bool tuesdayOpen = true;
  bool wednesdayOpen = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Horario de Apertura", style: TextStyle(fontWeight: FontWeight.bold))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Define the standard operating hours for each day.", style: TextStyle(color: PrecisionFlowTheme.secondary)),
          const SizedBox(height: 24),
          _buildDayRow("Monday", mondayOpen, (val) => setState(() => mondayOpen = val)),
          const SizedBox(height: 16),
          _buildDayRow("Tuesday", tuesdayOpen, (val) => setState(() => tuesdayOpen = val)),
          const SizedBox(height: 16),
          _buildDayRow("Wednesday", wednesdayOpen, (val) => setState(() => wednesdayOpen = val)),
        ],
      ),
    );
  }

  Widget _buildDayRow(String day, bool isOpen, Function(bool) onToggle) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(day, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Switch(value: isOpen, onChanged: onToggle, activeColor: Colors.green),
              ],
            ),
            if (isOpen) ...[
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _timePickerBox("09:00 AM"),
                  const Text("to", style: TextStyle(color: PrecisionFlowTheme.secondary)),
                  _timePickerBox("06:00 PM"),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  Widget _timePickerBox(String time) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: PrecisionFlowTheme.borderSubtle),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(time, style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          const Icon(Icons.access_time, size: 16, color: PrecisionFlowTheme.secondary),
        ],
      ),
    );
  }
}

// ------------------------------------------
// SCREEN 8: OWNER SETTINGS & SUBSCRIPTIONS
// ------------------------------------------
class OwnerSettingsScreen extends StatelessWidget {
  const OwnerSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Business Profile & Subscription", style: TextStyle(fontWeight: FontWeight.bold))),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Business profile box
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Center(
                      child: CircleAvatar(radius: 40, backgroundColor: PrecisionFlowTheme.primary, child: Icon(Icons.business, color: Colors.white, size: 40)),
                    ),
                    const SizedBox(height: 16),
                    const Text("Business Name", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextFormField(initialValue: "Acme Operations Ltd.", decoration: const InputDecoration(border: OutlineInputBorder())),
                    const SizedBox(height: 12),
                    const Text("Tax ID / EIN", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 6),
                    TextFormField(initialValue: "US-987654321", decoration: const InputDecoration(border: OutlineInputBorder())),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Subscription status card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Subscription", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                          child: const Text("Activo", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 11)),
                        )
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text("Plan Pro", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const Text("\$49.00 / mes", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    const Text("Próximo pago: 15 Nov, 2023", style: TextStyle(color: PrecisionFlowTheme.secondary)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Log Out Button
            ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text("Cerrar Sesión"),
              style: ElevatedButton.styleFrom(
                backgroundColor: PrecisionFlowTheme.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------
// SCREEN 9: CLIENT SETTINGS SCREEN
// ------------------------------------------
class ClientSettingsScreen extends StatelessWidget {
  const ClientSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final userEmail = user?.email ?? "cliente@example.com";
    final userName = user?.displayName ?? "Cliente de Operations Hub";

    return Scaffold(
      appBar: AppBar(
        title: const Text("Perfil y Configuración", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Profile Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage('https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&q=80&w=150'),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      userEmail,
                      style: const TextStyle(color: PrecisionFlowTheme.secondary),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        "Rol: Cliente",
                        style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Settings Options
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.person_outline),
                    title: const Text("Editar Datos"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.notifications_none),
                    title: const Text("Notificaciones"),
                    trailing: Switch(
                      value: true,
                      onChanged: (val) {},
                      activeColor: Colors.green,
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security),
                    title: const Text("Seguridad"),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Log Out Button
            ElevatedButton.icon(
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                if (context.mounted) {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout),
              label: const Text("Cerrar Sesión"),
              style: ElevatedButton.styleFrom(
                backgroundColor: PrecisionFlowTheme.error,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ------------------------------------------
// SCREEN 10: REGISTRATION / SIGN UP SCREEN
// ------------------------------------------
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool isClientSelected = true;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  Future<void> _signUp() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Por favor completa todos los campos"), backgroundColor: Colors.red),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Las contraseñas no coinciden"), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // 1. Create account in Firebase Auth
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final uid = userCredential.user?.uid;
      final role = isClientSelected ? "client" : "owner";

      if (uid != null) {
        // 2. Save user profile in Firestore
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'name': name,
          'email': email,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Cuenta creada exitosamente!"), backgroundColor: PrecisionFlowTheme.success),
        );
        
        // 3. Navigate to appropriate hub
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => isClientSelected
                ? const ClientNavigationHub()
                : const OwnerNavigationHub(),
          ),
          (route) => false,
        );
      }
    } catch (e) {
      debugPrint("Error registering user: $e");
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString().split(']').last.trim()}"), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Registrarse", style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo & Title
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.hub, size: 36, color: PrecisionFlowTheme.primary),
                  const SizedBox(width: 8),
                  const Text(
                    "Operations Hub",
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: PrecisionFlowTheme.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Text(
                "Crea tu cuenta gratis hoy mismo",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: PrecisionFlowTheme.secondary,
                ),
              ),
              const SizedBox(height: 24),

              // Role Selectors
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isClientSelected = true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: isClientSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isClientSelected ? PrecisionFlowTheme.primary : PrecisionFlowTheme.borderSubtle,
                            width: isClientSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.person_outline,
                              color: isClientSelected ? PrecisionFlowTheme.primary : PrecisionFlowTheme.secondary,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Soy Cliente",
                              style: TextStyle(
                                fontWeight: isClientSelected ? FontWeight.bold : FontWeight.normal,
                                color: isClientSelected ? PrecisionFlowTheme.primary : PrecisionFlowTheme.secondary,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => isClientSelected = false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          color: !isClientSelected ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: !isClientSelected ? PrecisionFlowTheme.primary : PrecisionFlowTheme.borderSubtle,
                            width: !isClientSelected ? 2 : 1,
                          ),
                        ),
                        child: Column(
                          children: [
                            Icon(
                              Icons.storefront_outlined,
                              color: !isClientSelected ? PrecisionFlowTheme.primary : PrecisionFlowTheme.secondary,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Soy Dueño",
                              style: TextStyle(
                                fontWeight: !isClientSelected ? FontWeight.bold : FontWeight.normal,
                                color: !isClientSelected ? PrecisionFlowTheme.primary : PrecisionFlowTheme.secondary,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Name Input
              const Text(
                "Nombre Completo",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person_outline),
                  hintText: "Juan Pérez",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: PrecisionFlowTheme.borderSubtle),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),

              // Email Input
              const Text(
                "Correo Electrónico",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.mail_outline),
                  hintText: "ejemplo@correo.com",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: PrecisionFlowTheme.borderSubtle),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),

              // Password Input
              const Text(
                "Contraseña",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _passwordController,
                obscureText: _obscurePassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    ),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  hintText: "••••••••",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: PrecisionFlowTheme.borderSubtle),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 16),

              // Confirm Password Input
              const Text(
                "Confirmar Contraseña",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              const SizedBox(height: 6),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: _obscureConfirmPassword,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock_outline),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                    ),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  hintText: "••••••••",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: PrecisionFlowTheme.borderSubtle),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 24),

              // Sign Up Button
              ElevatedButton(
                onPressed: _isLoading ? null : _signUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: PrecisionFlowTheme.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                      )
                    : const Text(
                        "Crear Cuenta",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
