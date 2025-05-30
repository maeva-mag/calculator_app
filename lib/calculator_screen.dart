 import 'package:flutter/material.dart';
 import 'button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen ({super.key});

  @override
  State<CalculatorScreen > createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen > {
  String number1 = ""; // for values with . or 0-9
  String operand = ""; // +-*/
  String number2 = ""; //. 0-9
  @override
  Widget build(BuildContext context) {
    final screenSize= MediaQuery.of(context).size; //to make page responsive
    return  Scaffold(
      body: SafeArea(
        bottom: false,
        child: Column(
        children: [ 
          // Display the result
        Expanded(
          child: SingleChildScrollView(
            reverse: true, //make the 0 display at burron
              child: Container(
                alignment: Alignment.bottomRight,
                padding: const EdgeInsets.all(16),
                child: Text(
                  "$number1$operand$number2".isEmpty?"0":"$number1$operand$number2",
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.end,
                ),
              ),
            ),
        ),
        //button
        Wrap(
          children: Btn.buttonValues.map(
            (value)=>SizedBox(
              width: value== Btn.n0? screenSize.width/2: (screenSize.width/4),
              height: screenSize.width/5,
              child: buildButton(value),
              ),
              )
              .toList(), 
        )

         ],
        ),
      ),
    );
  }
  Widget buildButton(value){
    //for the buttons not to touch each other
    return Padding(
      padding: const EdgeInsets.all(4.0),
      //to add styling
      child: Material (
        color: getBtnColor(value),
        clipBehavior: Clip.hardEdge,  // for the shadow to remain on the button border
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Color.fromARGB(255, 65, 65, 64)
          ),
          borderRadius: BorderRadius.circular(100)),
        child: InkWell(
        onTap: () => onBtnTap(value),//to be able to add tap
      
        child: Center(// to set elements at the center
          child: Text(value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          )
          ),
          )
          ),
    );
  }
  //to make sure only numbers and operands are displayed
  
  void onBtnTap(String value){ 
    if(value==Btn.del){
      delete();
      return;
    }
    if(value==Btn.clr){
      clearALL();
      return;
    }
    if(value==Btn.per){
      convertToPercentage();
      return;

    }
    if(value==Btn.calc){
      calculate();
      return;
    }
    appendValue(value); 
  }
  //calculating after cliccking =
  void calculate(){
    if(number1.isEmpty)return;
    if(operand.isEmpty)return;
    if(number2.isEmpty)return;

    double num1 = double.parse(number1);
    double num2 = double.parse(number2);

    var result= 0.0;
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
        case Btn.sub:
        result = num1 - num2;
        break;
        case Btn.mul:
        result = num1 * num2;
        break;
        case Btn.div:
        result = num1 / num2;
        break;
      default:
    }
    setState(() {
      number1="$result";

      if(number1.endsWith(".0")){
        number1=number1.substring(0,number1.length-2);
      }

      operand="";
      number2="";
    });
  }
  //converting output to percentage
  void convertToPercentage(){
    if(number1.isNotEmpty&&operand.isNotEmpty&&number2.isNotEmpty){
      //calculate before convertion
      calculate();
       }
       if(operand.isNotEmpty){
        //cannot be converted 
        return;
       }
       final number= double.parse(number1);
       setState(() {
         number1 ="${(number/100)}";
         operand ="";
         number2 ="";
       });
  }
  //Clear all output
  void clearALL(){
    setState(() {
      number1="";
      operand="";
      number2="";
    });
  }
  //deleting

  void delete(){
    if(number2.isNotEmpty){
      //to delete from the end
      number2=number2.substring(0,number2.length-1);
    }else if(operand.isNotEmpty){
      operand="";
    }else if(number1.isNotEmpty){
       number1=number1.substring(0,number1.length-1);
    }
   setState(() {});
  }
  void appendValue( String value){
    //checking if it is operand and not dot 
    if( value!=Btn.dot&&int.tryParse(value)==null){
      //checking operand pressed
      if(operand.isNotEmpty&&number2.isNotEmpty){
       calculate();
      }
      operand = value;
      //checking if number1 or operand are not empty
    }else if(number1.isEmpty|| operand.isEmpty){
      if(value==Btn.dot && number1.contains(Btn.dot)) return;
        if(value==Btn.dot && number1.isEmpty || number1==Btn.n0) {
          value = "0.";
        }
       number1+=value;   
       //checking if number2 or operand are not empty
    }else if(number2.isEmpty|| operand.isNotEmpty){
      if(value==Btn.dot && number2.contains(Btn.dot)) return;
        if(value==Btn.dot && number2.isEmpty || number2==Btn.n0) {
          value = "0.";
        }
       number2+=value;   
    }
    setState(() {
      
    });

  }
    
   


  Color getBtnColor(value){
    return [Btn.del, Btn.clr].contains(value)?Colors.blueGrey:[Btn.add,Btn.mul,Btn.div,Btn.sub,Btn.calc,Btn.per].contains(value)?Colors.orangeAccent: Colors.black87;
  }
}