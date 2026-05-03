// // import 'package:flutter/material.dart';
// //
// // class TextFieldInpute extends StatelessWidget {
// //   const TextFieldInpute({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
// //       child: TextField(
// //         decoration: InputDecoration(
// //         border:InputBorder.none,filled: true,
// //         fillColor: const Color(0xFFedf0f8),
// //         enabledBorder: OutlineInputBorder(borderSide: BorderSide.none,
// //         borderRadius:BorderRadius.circular(30),
// //         ),
// //          focusedBorder: const OutlineInputBorder(
// //             borderSide:BorderSide(width: 2,color: Colors.blue ),
// //           )
// //       ),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'package:flutter/material.dart';
//
// class TextFieldInput extends StatelessWidget {
//   final TextEditingController textEditingController;
//   final bool isPass;
//   final String hintText;
//   final IconData? icon;
//   final TextInputType textInputType;
//   const TextFieldInput({
//     super.key,
//     required this.textEditingController,
//     this.isPass = false,
//     required this.hintText,
//     this.icon,
//     required this.textInputType,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//       child: TextField(
//         style: const TextStyle(fontSize: 20),
//         controller: textEditingController,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon, color: Colors.black54),
//           hintText: hintText,
//           hintStyle: const TextStyle(color: Colors.black45, fontSize: 18),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide.none,
//             borderRadius: BorderRadius.circular(30),
//           ),
//           border: InputBorder.none,
//           focusedBorder: OutlineInputBorder(
//             borderSide: const BorderSide(color: Colors.blue, width: 2),
//             borderRadius: BorderRadius.circular(30),
//           ),
//           filled: true,
//           fillColor: const Color(0xFFedf0f8),
//           contentPadding: const EdgeInsets.symmetric(
//             vertical: 15,
//             horizontal: 20,
//           ),
//         ),
//         keyboardType: textInputType,
//         obscureText: isPass,
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final IconData? icon;
  final TextInputType textInputType;
  const TextFieldInput({
    super.key,
    required this.textEditingController,
    this.isPass = false,
    required this.hintText,
    this.icon,
    required this.textInputType,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        style: const TextStyle(fontSize: 20),
        controller: textEditingController,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.black54),
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.black45, fontSize: 18),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide.none,
            borderRadius: BorderRadius.circular(30),
          ),
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.blue, width: 2),
            borderRadius: BorderRadius.circular(30),
          ),
          filled: true,
          fillColor: const Color(0xFFedf0f8),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 15,
            horizontal: 20,
          ),
        ),
        keyboardType: textInputType,
        obscureText: isPass,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showTextField = false; // Control the visibility of text field and button

  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Double Tap to Show UI'),
        centerTitle: true,
      ),
      body: GestureDetector(
        onDoubleTap: () {
          setState(() {
            showTextField = !showTextField; // Toggle visibility on double tap
          });
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showTextField) ...[
                TextFieldInput(
                  textEditingController: _textEditingController,
                  hintText: 'Enter your text',
                  icon: Icons.text_fields,
                  textInputType: TextInputType.text,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ElevatedButton(
                    onPressed: () {
                      // Your login action goes here
                      print('Login button pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text('Login'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
