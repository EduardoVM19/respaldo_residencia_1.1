import 'package:flutter/material.dart';

class PlatoDelBuenComerApp extends StatelessWidget {
  const PlatoDelBuenComerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Plato del Buen Comer',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: const PlatoScreen(),
    );
  }
}

class PlatoScreen extends StatefulWidget {
  const PlatoScreen({Key? key}) : super(key: key);

  @override
  _PlatoScreenState createState() => _PlatoScreenState();
}

class _PlatoScreenState extends State<PlatoScreen> {
  // Lista de ingredientes con categorías
  List<Ingredient> ingredients = [
    Ingredient(name: 'zanahoria', type: 'verdura'),
    Ingredient(name: 'manzana', type: 'fruta'),
    Ingredient(name: 'pan', type: 'cereal'),
    Ingredient(name: 'pescado', type: 'proteina'),
  ];

  // Lista para guardar los ingredientes que el usuario coloca en el plato
  final List<Ingredient> selectedIngredients = [];

  // Función para verificar si se cumplen las categorías necesarias
  bool hasCompletedMeal() {
    final typesInPlate = selectedIngredients.map((i) => i.type).toSet();
    return typesInPlate.containsAll(['verdura', 'fruta', 'cereal', 'proteina']);
  }

  // Función para calcular el porcentaje de tipos completados
  double calculateCompletionPercentage() {
    final requiredTypes = {'verdura', 'fruta', 'cereal', 'proteina'};
    final typesInPlate = selectedIngredients.map((i) => i.type).toSet();
    final matchedTypes = typesInPlate.intersection(requiredTypes).length;
    return (matchedTypes / requiredTypes.length) * 100;
  }

  // Función para manejar el botón "Terminado"
  void onFinishedButtonPressed() {
    if (hasCompletedMeal()) {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("¡Felicidades!"),
          content: Text("Has completado un plato balanceado."),
        ),
      );
    } else {
      final percentage = calculateCompletionPercentage();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Perdiste"),
          content: Text(
              "No has completado un plato balanceado. Estuviste cerca de un ${percentage.toStringAsFixed(0)}%"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plato del Buen Comer'),
      ),
      body: Column(
        children: [
          // Sección de ingredientes arrastrables
          Expanded(
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Número de columnas
                crossAxisSpacing: 4, // Espacio horizontal entre imágenes
                mainAxisSpacing: 4, // Espacio vertical entre imágenes
              ),
              itemCount: ingredients.length,
              itemBuilder: (context, index) {
                final ingredient = ingredients[index];
                return Draggable<Ingredient>(
                  data: ingredient,
                  feedback: Material(
                    child: Image.asset(
                      'assets/imagenes/${ingredient.name.toLowerCase()}.png',
                      height: 50,
                      width: 50,
                    ),
                  ),
                  childWhenDragging: Opacity(
                    opacity: 0.5,
                    child: Image.asset(
                      'assets/imagenes/${ingredient.name.toLowerCase()}.png',
                      height: 50,
                      width: 50,
                    ),
                  ),
                  child: Image.asset(
                    'assets/imagenes/${ingredient.name.toLowerCase()}.png',
                    height: 50,
                    width: 50,
                  ),
                );
              },
            ),
          ),
          // Zona del plato (DragTarget)
          DragTarget<Ingredient>(
            onAccept: (ingredient) {
              setState(() {
                selectedIngredients.add(ingredient);
                ingredients.remove(ingredient); // Elimina el ingrediente de la lista después de usarlo
              });
            },
            builder: (context, candidateData, rejectedData) {
              return Container(
                height: 200,
                width: double.infinity,
                color: Colors.lightGreen[100],
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Arrastra aquí los ingredientes para armar tu comida',
                      style: TextStyle(fontSize: 18),
                    ),
                    if (selectedIngredients.isNotEmpty)
                      Wrap(
                        children: selectedIngredients
                            .map((ingredient) => Image.asset(
                                  'assets/imagenes/${ingredient.name.toLowerCase()}.png',
                                  height: 50,
                                  width: 50,
                                ))
                            .toList(),
                      ),
                  ],
                ),
              );
            },
          ),
          // Botón "Terminado"
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: onFinishedButtonPressed,
              child: const Text("Terminado"),
            ),
          ),
        ],
      ),
    );
  }
}

// Modelo para representar un ingrediente
class Ingredient {
  final String name;
  final String type;

  Ingredient({required this.name, required this.type});
}
