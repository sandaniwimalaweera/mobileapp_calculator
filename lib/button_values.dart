//IM-2021-022
//Purpose of this code - defines button codes

class Btn {

  //operators and operations
  static const String del = "X";
  static const String clr = "C";
  static const String per = "%";
  static const String multiply = "×";
  static const String divide = "÷";
  static const String add = "+";
  static const String subtract = "-";
  static const String calculate = "=";
  static const String dot = ".";
  static const String sqrt = "√";


//numbers
  static const String n0 = "0";
  static const String n1 = "1";
  static const String n2 = "2";
  static const String n3 = "3";
  static const String n4 = "4";
  static const String n5 = "5";
  static const String n6 = "6";
  static const String n7 = "7";
  static const String n8 = "8";
  static const String n9 = "9";


//buttons layout
  static const List<String> buttonValues = [
    del, clr, per, multiply,
    n7, n8, n9, divide,
    n4, n5, n6, subtract,
    n1, n2, n3, add,
    dot, n0, sqrt, calculate,
  ];
}
