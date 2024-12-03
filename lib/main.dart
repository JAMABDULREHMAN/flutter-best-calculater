import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const CalculatorApp());
}

class CalculatorApp extends StatelessWidget {
  const CalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CalculatorScreen(),
    );
  }
}

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with SingleTickerProviderStateMixin {
  String _expression = "";
  String _result = "0";
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
  }

  void _onButtonPressed(String value) {
    setState(() {
      if (value == "C") {
        _expression = "";
        _result = "0";
        _animationController.reset();
      } else if (value == "=") {
        try {
          Parser p = Parser();
          Expression exp = p.parse(_expression);
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          _result = eval.toString();
          _animationController.reset();
          _animationController.forward();
        } catch (e) {
          _result = "Error";
          _animationController.reset();
        }
      } else {
        _expression += value;
      }
    });
  }

  Widget _buildButton(String value) {
    return GestureDetector(
      onTap: () => _onButtonPressed(value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.deepPurpleAccent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            value,
            style: const TextStyle(fontSize: 24, color: Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Display Area
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    _expression,
                    style: const TextStyle(fontSize: 32, color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      _result,
                      style: const TextStyle(fontSize: 48, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Buttons
          GridView.count(
            shrinkWrap: true,
            crossAxisCount: 4,
            childAspectRatio: 1.2,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              "7",
              "8",
              "9",
              "C",
              "4",
              "5",
              "6",
              "/",
              "1",
              "2",
              "3",
              "*",
              ".",
              "0",
              "=",
              "-",
              "+",
            ].map(_buildButton).toList(),
          ),
        ],
      ),
    );
  }
}
