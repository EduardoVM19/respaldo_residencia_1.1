import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key); // Constructor constante

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String _userName = '';
  int _daysConnected = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    _user = _auth.currentUser;

    if (_user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('users').doc(_user!.uid);
      final docSnapshot = await userDoc.get();

      if (docSnapshot.exists) {
        setState(() {
          // Verificamos que el campo exista usando 'data()' y operador null-aware
          final data = docSnapshot.data();
          _userName = data?['name'] ?? 'Usuario';
          _daysConnected =
              data?['daysConnected'] ?? 0; // Usamos 0 como valor predeterminado
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150.0),
        child: Container(
          margin: const EdgeInsets.only(top: 40),
          child: AppBar(
            title: Row(
              children: [
                // Imagen del logo en el extremo izquierdo
                Image.asset(
                  'assets/imagenes/icono-app.png',
                  width: 100,
                  height: 100,
                ),

                // Spacer para separar y empujar los elementos hacia los extremos
                const Spacer(),

                // Imagen de fuego y texto en el extremo derecho
                Row(
                  children: [
                    Image.asset(
                      'assets/imagenes/fuego.png',
                      width: 50,
                      height: 50,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$_daysConnected',
                      style: const TextStyle(color: Colors.black),
                    ),
                  ],
                ),
              ],
            ),
            centerTitle: true,
            toolbarHeight: 100,
            automaticallyImplyLeading: false,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          'Bienvenido $_userName',
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
