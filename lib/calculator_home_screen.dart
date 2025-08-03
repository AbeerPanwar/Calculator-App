import 'package:flutter/material.dart';

class CalculatorHomeScreen extends StatefulWidget {
  const CalculatorHomeScreen({super.key});

  @override
  State<CalculatorHomeScreen> createState() => _CalculatorHomeScreenState();
}

class _CalculatorHomeScreenState extends State<CalculatorHomeScreen> {

  late String number1 = '';
  late String operand = '';
  late String number2 = '';


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        centerTitle: true,
        title: Text(
          'Calculator',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.bottomRight,
              padding: EdgeInsets.only(bottom: 60, right: 16,),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  '$number1$operand$number2',
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 70,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            rowWidget(),
          ],
        ),
      ),
    );
  }
  
  Widget rowWidget(){
    
    return Wrap(
      children: [
        rowItem(
          info1: 'AC',
          size1: 31,
          info2: '( )',
          info3: '%',
          size3: 50,
          info4: '÷',
          size4: 60,
          color1: Colors.blueGrey.shade900,
          color2: Colors.grey.shade700,
          color3: Colors.grey.shade700,
          color4: Colors.grey.shade700,
        ),
        rowItem(
          info1: '7',
          info2: '8',
          info3: '9',
          info4: '×',
          size4: 60,
          color4: Colors.grey.shade700,
        ),
        rowItem(
          info1: '4',
          info2: '5',
          info3: '6',
          info4: '-',
          size4: 60,
          color4: Colors.grey.shade700,
        ),
        rowItem(
          info1: '1',
          info2: '2',
          info3: '3',
          info4: '+',
          size4: 60,
         color4: Colors.grey.shade700,
        ),
        rowItem(
          info1: '0',
          info2: '.',
          info3: 'DEL',
          size3: 23,
          info4: '=',
          size4: 60,
          color4: Colors.blueGrey.shade900,
        ),
      ],
    );
  }

  Widget rowItem(
    {required String info1, 
    required String info2, 
    required String info3, 
    required String info4, 
    double ?size1, 
    double ?size2, 
    double ?size3, 
    double ?size4, 
    Color ?color1, 
    Color ?color2, 
    Color ?color3, 
    Color ?color4,}
  ){

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buttonItem(
            info: info1,
            size: size1,
            color: color1,
          ),
          buttonItem(
            info: info2,
            size: size2,
            color: color2,
          ),
          buttonItem(
            info: info3,
            size: size3,
            color: color3,
          ),
          buttonItem(
            info: info4,
            size: size4,
            color: color4,
          ),
        ],
      ),
    );
  }

  Widget buttonItem({required String info, double ?size, Color ?color,}){

    final screenSize = MediaQuery.of(context).size;
    return SizedBox(
      width: screenSize.width/4.5,
      height: screenSize.width/4.5,
      child: ElevatedButton(
        onPressed:()=> onTap(info),
        style: ElevatedButton.styleFrom(
          backgroundColor: color?? Colors.grey.shade900,
        ),
        child: Center(
          child: Text(
            maxLines: 1,
            overflow: TextOverflow.fade,
            info,
            style: TextStyle(
              color: Colors.white,
              fontSize: size?? 40,
            ),
          ),
        ),
      ),
    );
  }

  void onTap(String value){
    if(value == 'DEL'){
      delete(value);
      return;
    }

    if(value == 'AC'){
      clearAll();
      return;
    }

    if(value == '%'){
      convertToPercent();
      return;
    }

    if(value == '='){
      calculate();
      return;
    }
    
    appendValue(value);
  }

  void calculate(){
    if(number1.isEmpty){return;}
    if(operand.isEmpty){return;}
    if(number2.isEmpty){return;}

    final double num1 = double.parse(number1); 
    final double num2 = double.parse(number2);

    var res = 0.0;
    switch (operand) {
      case '+':
        res = num1 + num2;
        break;
      case '-':
        res = num1 - num2;
        break;
      case '×':
        res = num1*num2;
        break;
      case '÷':
        res = num1/num2;
        break;
      default:
    }

    setState(() {
      number1 = '$res';

      if(number1.endsWith('.0')){
        number1 = number1.substring(0, number1.length - 2);
      }

      operand = '';
      number2 = '';
    });
  }

  void convertToPercent(){
    if(number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty){
      calculate();
    }
    if(operand.isNotEmpty){
      return;
    }

    final number = double.parse(number1);
    setState(() {
      number1 = '${(number /100 )}';
      operand = '';
      number2 = '';
    });

  }

  void clearAll(){
    setState(() {
      number1 = '';
      operand = '';
      number2 = '';
    });
  }


  void delete(String value){
    if(number2.isNotEmpty){
      number2 = number2.substring(0, number2.length-1);
    }else if(operand.isNotEmpty){
      operand = '';
    }else if(number1.isNotEmpty){
      number1 = number1.substring(0, number1.length-1);
    }

    setState(() {});
  }

  void appendValue(String value){

    if(value != '.' && int.tryParse(value) == null){
      if(operand.isNotEmpty && number2.isNotEmpty){

      }
      operand = value;
    }else if (number1.isEmpty || operand.isEmpty){
      if(value == '.' && number1.contains('.')) return;
      if(value == '.' && (number1.isEmpty || number1 == '0')){
        value = '0.';
      }
      number1 += value;
    }else if (number2.isEmpty || operand.isNotEmpty){
      if(value == '.' && number2.contains('.')) return;
      if(value == '.' && (number2.isEmpty || number2 == '0')){
        value = '0.';
      }
      number2 += value;
    }
    setState(() {});
  }
}
