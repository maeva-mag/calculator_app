// Import necessary packages
import 'package:flutter/material.dart'; // Flutter material package provides UI components and theming
import 'package:math_expressions/math_expressions.dart'; // Math expressions package for parsing and evaluating mathematical expressions
import 'calculator_screen.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    // You can customize this widget as needed
    return const Scaffold(
      body: Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
// Custom HoverButton widget that implements hover effect
class HoverButton extends StatefulWidget {
  // Properties for the button
  final VoidCallback onPressed;
  final Icon icon;
  final String label;

  // Constructor
  const HoverButton({
    super.key,
    required this.onPressed,
    required this.icon,
    required this.label,
  });

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  // Track if the button is being hovered
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Define colors
    final Color defaultColor = const Color.fromARGB(
      255,
      210,
      79,
      2,
    ); // Original orange
    final Color hoverColor = const Color.fromARGB(
      255,
      255,
      120,
      30,
    ); // Lighter orange for hover

    return MouseRegion(
      // Detect when mouse enters and exits
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      cursor: SystemMouseCursors.click, // Change cursor to indicate clickable
      child: AnimatedContainer(
        // Animate changes in properties
        duration: const Duration(milliseconds: 200), // Animation duration
        child: ElevatedButton.icon(
          // The actual button
          onPressed: widget.onPressed,
          icon: widget.icon,
          label: Text(
            widget.label,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor:
                isHovered ? hoverColor : defaultColor, // Change color on hover
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 15,
            ), // Padding
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // Rounded corners
            ),
            elevation: isHovered ? 8 : 4, // Increase elevation on hover
            shadowColor: Colors.black45, // Shadow color
          ),
        ),
      ),
    );
  }
}

// Main function - entry point of the Flutter application


// Root widget of the application - Stateless because it doesn't need to maintain any state
class CalculatorApp extends StatelessWidget {
  // Constructor with optional key parameter
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Build method defines the widget's UI
    return MaterialApp(
      title:
          'Two Page Calculator App', // Title shown in task switchers and app management screens
      theme: ThemeData.dark(),
      initialRoute: '/input_page', // Define which route to load when app starts
      routes: {
        // Map of named routes to their respective widget builders
        '/input_page':
            (context) => const InputPage(), // First page with basic calculator
        '/calculator_page':
            (context) =>
                const CalculatorScreen(), // Second page with advanced calculator
      },
    );
  }
}

// First Page: Simple calculator with two input fields and basic arithmetic operations
class InputPage extends StatefulWidget {
  // StatefulWidget because we need to maintain state (input values and calculation results)
  const InputPage({super.key});

  @override
  // Create the mutable state for this widget
  InputPageState createState() => InputPageState();
}

 class InputPageState extends State<InputPage> {
  // Controllers to manage the text input fields
  final TextEditingController _number1Controller = TextEditingController();
  final TextEditingController _number2Controller = TextEditingController();

  // Variable to store and display the calculation result
  String _result = '';

  // Method to perform calculations based on the selected operator
  void _calculate(String operator) {
    // setState triggers UI update after changing state variables
    setState(() {
      // Get the raw input values
      final String input1 = _number1Controller.text;
      final String input2 = _number2Controller.text;

      // Try to parse input text to numbers, may return null if parsing fails
      final double? number1 = double.tryParse(input1);
      final double? number2 = double.tryParse(input2);

      // Check if both inputs are valid numbers
      final bool isNumeric = number1 != null && number2 != null;

      // Handle string concatenation if inputs are not both numbers and using + operator
      if (operator == '+') {
        if (isNumeric) {
          // If both are numbers, perform numeric addition
          _result = (number1 + number2).toString();
        } else {
          // If either is not a number, concatenate as strings
          _result = input1 + input2;
        }
        return;
      }

      // For other operators, validate numeric inputs
      if (!isNumeric) {
        _result = 'Invalid numeric input';
        return; // Exit early if validation fails
      }

      // Perform the appropriate calculation based on the operator
      switch (operator) {
        case '-':
          _result = (number1 - number2).toString(); // Subtraction
          break;
        case '*':
          _result = (number1 * number2).toString(); // Multiplication
          break;
        case '/':
          // Handle division by zero error
          if (number2 == 0) {
            _result = 'Cannot divide by zero';
          } else {
            // Format division result to 2 decimal places
            _result = (number1 / number2).toStringAsFixed(2);
          }
          break;
        default:
          _result = 'Invalid operator'; // Fallback for unexpected operators
      }
    });
  }

  @override
  // Cleanup method called when widget is removed from the widget tree
  void dispose() {
    // Release resources to prevent memory leaks
    _number1Controller.dispose(); // Clean up first text field controller
    _number2Controller.dispose(); // Clean up second text field controller
    super.dispose(); // Call parent class dispose method
  }

  @override
  Widget build(BuildContext context) {
    // Main build method that creates the UI for the InputPage
    return Scaffold(
      // Scaffold provides the basic material design visual structure
      appBar: AppBar(
        title: const Text(' Calculator App',
         style: TextStyle(
      color: Color.fromARGB(255, 177, 152, 6), // Orange text color
      fontWeight: FontWeight.bold,
    ),
        ),
        centerTitle: true, // Center the title in the app bar
        backgroundColor: const Color.fromARGB(255, 22, 21, 21), // Custom orange color
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0), // Add padding around all content
        child: Column(
          // Arrange all elements in a vertical column
          mainAxisAlignment:
              MainAxisAlignment.center, // Center content vertically
          children: <Widget>[
            // List of child widgets
            // First input field with enhanced styling
            TextField(
              key: const Key('number1_field'), // Added key for testing
              controller: _number1Controller, // Set the controller
              keyboardType:
                  TextInputType.number, // Set the keyboard type to number
              style: const TextStyle(color: Color.fromARGB(255, 232, 232, 230)), // White text color
              decoration: const InputDecoration(
                labelText: 'Enter first number', // Fixed typo in "number"
                border: OutlineInputBorder(), // Add outline border
                filled: true, // Enable background fill
                fillColor: Color.fromARGB(255, 23, 4, 4), // Black background
                prefixIcon: Icon(
                  Icons.calculate,
                  color: Colors.white,
                ), // White calculator icon
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 203, 189, 3),
                ), // gold label text
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 204, 207, 41),
                    width: 2.0,
                  ), // gold border when focused
                ),
              ),
            ),
            const SizedBox(height: 12), // Spacer with fixed height
            // Second input field with enhanced styling
            TextField(
              key: const Key('number2_field'), // Added key for testing
              controller: _number2Controller, // Set the controller
              keyboardType:
                  TextInputType.number, // Set the keyboard type to number
              style: const TextStyle(color: Colors.white), // White text color
              decoration: const InputDecoration(
                labelText: 'Enter second number',
                border: OutlineInputBorder(), // Add outline border
                filled: true, // Enable background fill
                fillColor: Color.fromARGB(255, 6, 6, 6), // Black background
                prefixIcon: Icon(
                  Icons.calculate,
                  color: Colors.white,
                ), // White calculator icon
                labelStyle: TextStyle(
                  color: Color.fromARGB(255, 210, 203, 2),
                ), // gold label text
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 222, 219, 2),
                    width: 2.0,
                  ), // gold border when focused
                ),
              ),
            ),
            const SizedBox(height: 20), // Spacer with fixed height
            // Result display with enhanced styling - moved before arithmetic operations
            Container(
              width: double.infinity, // Full width container
              padding: const EdgeInsets.symmetric(
                vertical: 20.0,
                horizontal: 16.0,
              ),
              margin: const EdgeInsets.only(bottom: 20.0),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 8, 3, 3), // Light gray background
                borderRadius: BorderRadius.circular(10), // Rounded corners
                border: Border.all(
                  color: const Color.fromARGB(255, 247, 247, 245),
                  width: 2,
                ), // Orange border
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0, 2),
                    blurRadius: 4.0,
                  ),
                ],
              ),
              child: Text(
                // Display the result
                'Result: $_result', // Show the result
                key: const Key('result_text'), // Added key for testing
                textAlign: TextAlign.center, // Center the text
                style: const TextStyle(
                  fontSize: 28, // Larger font size
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 210, 186, 2), // Orange text color
                ),
              ),
            ),

            // Arithmetic operation buttons
            Row(
              // Row to arrange buttons horizontally
              mainAxisAlignment:
                  MainAxisAlignment.spaceAround, // Space the buttons evenly
              children: <Widget>[
                // Addition button with enhanced styling
                ElevatedButton(
                  onPressed: () => _calculate('+'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(109, 89, 73, 1), // O background
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ), // Larger button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    '+',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 204, 190, 3),
                    ),
                  ),
                ),

                // Subtraction button with enhanced styling
                ElevatedButton(
                  onPressed: () => _calculate('-'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                      109, 89, 73, 1
                    ), // O background
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ), // Larger button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    '-',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 204, 190, 3),
                    ),
                  ),
                ),

                // Multiplication button with enhanced styling
                ElevatedButton(
                  onPressed: () => _calculate('*'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                     109, 89, 73, 1
                    ), // O background
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ), // Larger button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    '*',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 204, 190, 3),
                    ),
                  ),
                ),

                // Division button with enhanced styling
                ElevatedButton(
                  onPressed: () => _calculate('/'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                      109, 89, 73, 1
                    ), // Orange background
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ), // Larger button
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10,
                      ), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    '/',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 204, 190, 3),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30), // Larger spacer for better separation
            // Enhanced navigation button with hover effect using HoverButton custom widget
            HoverButton(
              // Custom widget that handles hover state
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/calculator_page',
                ); // Navigate to calculator page
              },
              icon: const Icon(Icons.calculate, size: 24), // Calculator icon
              label: 'Go to Calculator', // Button text
            ),
          ],
        ),
      ),
    );
  }
}
