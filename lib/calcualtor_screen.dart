//IM-2021-022
//import necessary packages
import 'package:flutter/material.dart'; // Core Flutter package
import 'button_values.dart'; // Contains button labels and values
import 'dart:math'; // For mathematical operations like square root

// Main Calculator Screen Widget
class CalculatorScreen extends StatefulWidget {
  final VoidCallback onToggleTheme; // Callback function to toggle between light and dark themes

  const CalculatorScreen({super.key, required this.onToggleTheme});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  // Variables to store operands, operator, and calculation history
  String number1 = ""; // First operand
  String operand = ""; // Operator (+, -, *, /)
  String number2 = ""; // Second operand
  List<String> history = []; // Stores the history of calculations
  bool calculationDone = false; // Flag to track if a calculation has been completed

  @override
  Widget build(BuildContext context) {
    // Retrieve screen size to ensure responsive layout
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'), // AppBar title
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6), // Icon for theme toggle
            onPressed: widget.onToggleTheme, // Callback to toggle theme
          ),
          IconButton(
            icon: const Icon(Icons.history), // Icon to open calculation history
            onPressed: () => showHistory(context), // Opens the history modal
          ),
        ],
      ),
      body: SafeArea(
        bottom: false, // Extend content to the bottom edge of the screen
        child: Column(
          children: [
            // Display area for the current input and result
            Expanded(
              child: SingleChildScrollView(
                reverse: true, // Automatically scroll to the latest input/output
                child: Container(
                  alignment: Alignment.bottomRight, // Align text to the bottom-right
                  padding: const EdgeInsets.all(16), // Padding for the display area
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0" // Default display when no input is provided
                        : "$number1$operand$number2", // Display current input
                    style: const TextStyle(
                      fontSize: 48, // Large font size for visibility
                      fontWeight: FontWeight.bold, // Bold font for emphasis
                    ),
                    textAlign: TextAlign.end, // Align text to the right
                  ),
                ),
              ),
            ),
            // Layout for calculator buttons
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      width: screenSize.width / 4, // Button width (1/4th of the screen)
                      height: screenSize.width / 5, // Button height proportional to width
                      child: buildButton(value), // Generate each button
                    ),
                  )
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }

  // Function to build individual calculator buttons
  Widget buildButton(String value) {
    Color btnColor = getBtnColor(value); // Determine button color based on type
    bool isGrayButton = btnColor == const Color.fromARGB(255, 145, 145, 145); // Check for special buttons

    return Padding(
      padding: const EdgeInsets.all(8.0), // Add space between buttons
      child: Material(
        elevation: 8, // Add shadow effect for a raised look
        shadowColor: Colors.black.withOpacity(0.3), // Shadow color
        borderRadius: BorderRadius.circular(50), // Make buttons circular
        child: Container(
          decoration: BoxDecoration(
            color: btnColor, // Background color for the button
            borderRadius: BorderRadius.circular(50), // Rounded edges
          ),
          child: InkWell(
            borderRadius: BorderRadius.circular(50), // Restrict ripple effect within the button
            onTap: () => onBtnTap(value), // Define what happens on button tap
            child: Center(
              child: Text(
                value, // Button label
                style: TextStyle(
                  fontWeight: FontWeight.bold, // Bold text for visibility
                  fontSize: 24, // Font size
                  color: isGrayButton ? Colors.white : Colors.black, // Text color
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Handles the logic when a button is tapped
  void onBtnTap(String value) {
    if (calculationDone && value != Btn.calculate) {
      clearAll(); // Clear inputs for new calculation
    }

    if (value == Btn.del) {
      delete(); // Handle delete button
      return;
    }
    if (value == Btn.clr) {
      clearAll(); // Handle clear button
      return;
    }
    if (value == Btn.per) {
      convertToPercentage(); // Handle percentage conversion
      return;
    }
    if (value == Btn.calculate) {
      calculate(); // Perform the calculation
      return;
    }
    if (value == Btn.sqrt) {
      calculateSquareRoot(); // Handle square root calculation
      return;
    }
    appendValue(value); // Append button value to the input
  }

  // Calculate the square root of the current input
  void calculateSquareRoot() {
    if (number1.isNotEmpty && operand.isEmpty && number2.isEmpty) {
      final number = double.parse(number1);
      setState(() {
        number1 = number >= 0 ? sqrt(number).toStringAsPrecision(3) : "Error"; // Handle negative numbers
        calculationDone = true; // Mark calculation as completed
      });
    }
  }

  // Perform the calculation based on the operator
  void calculate() {
    if (number1.isEmpty || operand.isEmpty || number2.isEmpty) return;

    final double num1 = double.tryParse(number1) ?? 0; // Parse first operand
    final double num2 = double.tryParse(number2) ?? 0; // Parse second operand

    if (operand == Btn.divide && num2 == 0) {
      // Handle division by zero
      setState(() {
        number1 = "Error";
        operand = "";
        number2 = "";
        calculationDone = true;
      });
      return;
    }

    double result = 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2; // Perform addition
        break;
      case Btn.subtract:
        result = num1 - num2; // Perform subtraction
        break;
      case Btn.multiply:
        result = num1 * num2; // Perform multiplication
        break;
      case Btn.divide:
        result = num1 / num2; // Perform division
        result = double.parse(result.toStringAsFixed(3)); // Round off
        break;
    }

    setState(() {
      history.add("$number1 $operand $number2 = ${result.toString()}"); // Add to history
      number1 = result.toString();
      if (number1.endsWith(".0")) {
        number1 = number1.substring(0, number1.length - 2); // Remove unnecessary ".0"
      }
      operand = ""; // Clear operator
      number2 = ""; // Clear second operand
      calculationDone = true; // Mark calculation as completed
    });
  }

  // Convert the current input to a percentage
  void convertToPercentage() {
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      calculate(); // Perform the calculation first
    }

    if (operand.isNotEmpty) return;

    final number = double.parse(number1);
    setState(() {
      number1 = "${(number / 100)}"; // Convert to percentage
      operand = "";
      number2 = "";
      calculationDone = true; // Mark calculation as completed
    });
  }

  // Clear all inputs and reset the calculator
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
      calculationDone = false; // Reset calculation flag
    });
  }

  // Deletes the last character in the current input
  void delete() {
    if (number2.isNotEmpty) {
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }
    setState(() {
      calculationDone = false; // Reset calculation flag
    });
  }

  // Append value to the current input
  void appendValue(String value) {
    if (value == "-" && number1.isEmpty && operand.isEmpty) {
      number1 = "-"; // Handle negative numbers
      setState(() {});
      return;
    }

    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        calculate(); // Perform calculation if both operands are set
      }
      operand = value;  // Set the operator
    } else if (number1.isEmpty || operand.isEmpty) {
      if (value == Btn.dot && number1.contains(Btn.dot)) return;  
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        value = "0.";   // Prepend "0."
      }
      number1 += value;   // Append to first operand
    } else if (number2.isEmpty || operand.isNotEmpty) {
      if (value == Btn.dot && number2.contains(Btn.dot)) return;   
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        value = "0.";   // Prepend "0."
      }
      number2 += value;   // Append to second operand
    }
    setState(() {
      calculationDone = false;   
    });
  }

  // Show calculation history in a modal bottom sheet
  void showHistory(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          children: [
            ListTile(
              title: const Text('History'),     // Title for history modal
              trailing: IconButton(
                icon: const Icon(Icons.delete), // Clear history icon
                onPressed: () {
                  setState(() {
                    history.clear(); // Clear all history
                  });
                  Navigator.pop(context); // Close modal
                },
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: history.length, // Number of history items
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(history[index]), // Display each history entry
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  // Determine button color based on its type
  Color getBtnColor(String value) {
    return [Btn.del, Btn.clr].contains(value)
        ? const Color.fromARGB(255, 145, 145, 145) // color for clear and delete buttons
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate,
            Btn.sqrt,
          ].contains(value)
            ? const Color.fromARGB(230, 22, 131, 109) // color for operation buttons
            : const Color.fromARGB(255, 225, 225, 225); // default color for all buttons
  }
}
