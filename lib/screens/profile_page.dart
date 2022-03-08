// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:crypto_raffle/models/users.dart';
// import 'package:crypto_raffle/screens/home_page.dart';
// import 'package:crypto_raffle/services/firestore_services.dart';
// import 'package:crypto_raffle/utils/constants.dart';
// import 'package:crypto_raffle/utils/validators.dart';
// import 'package:flutter/material.dart';
// import 'package:crypto_raffle/widgets/message_dialog_with_ok.dart';
// import 'package:progress_dialog/progress_dialog.dart';
//
// class ProfilePage extends StatefulWidget {
//   static const String routeName = "/ProfilePage";
//
//   const ProfilePage({Key? key}) : super(key: key);
//
//   @override
//   _ProfilePageState createState() => _ProfilePageState();
// }
//
// class _ProfilePageState extends State<ProfilePage> {
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController _nameController = TextEditingController();
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _countryController = TextEditingController();
//
//
//   ProgressDialog? progressDialog;
//   final FirestoreServices _fireStoreServices = FirestoreServices();
//   String? _email, _country, _name, _warning;
//   var profileImage = "";
//   bool isLoginPressed = false;
//   Users? users;
//
//   @override
//   void initState() {
//     super.initState();
//     _getProfile();
//   }
//
//   _getProfile() async {
//     users = await _fireStoreServices.getUserprofile();
//     setState(() {
//       _nameController.text = users!.name;
//       _emailController.text = users!.email;
//       profileImage = users!.profilePhoto;
//       _countryController.text = users!.country;
//     });
//   }
//
//   updateProfile(BuildContext context, ProgressDialog progressDialog) async {
//     progressDialog = ProgressDialog(context);
//     await progressDialog.show();
//
//     Users users = Users(name: _name!, email: _email!, country: _country!);
//     await _fireStoreServices.updateUserProfile(context, users).then((val) {
//       progressDialog.hide();
//       showDialog(
//           barrierDismissible: false,
//           context: context,
//           builder: (context) =>   CustomDialogWithOk(
//                 title: "Profile Updated",
//                 description:
//                     "Your Profile has been Updated, Now You can redeem Your ${Constants.coinName}",
//                 primaryButtonText: "Ok",
//                 primaryButtonRoute: HomePage.routeName,
//               ));
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("My Profile "),
//         elevation: 0,
//         centerTitle: true,
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: <Widget>[
//             Container(
//               height: MediaQuery.of(context).size.height * 0.25,
//               width: MediaQuery.of(context).size.width,
//               decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(20),
//                       bottomRight: Radius.circular(20)),
//                   color: Colors.indigo),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: <Widget>[
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.15,
//                     child: Padding(
//                       padding: const EdgeInsets.all(15),
//                       child: CircleAvatar(
//                         radius: 100,
//                         child: Image.network(
//                           profileImage,
//                           height: MediaQuery.of(context).size.height * 0.2,
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 10,
//                   ),
//                   Text(
//                     _nameController.text,
//                     textAlign: TextAlign.center,
//                   )
//                 ],
//               ),
//             ),
//             const SizedBox(
//               height: 30,
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20),
//               child: Column(
//                 children: <Widget>[
//                   _buildErrorWidget(),
//                   Form(
//                       key: _formKey,
//                       child: Column(
//                         children: _buildWidgets() + _buildButtons(),
//                       )),
//                 ],
//               ),
//             ),
//             const Divider(
//               height: 10,
//               color: Colors.red,
//             ),
//             const SizedBox(
//               height: 10,
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   List<Widget> _buildButtons() {
//     return [
//       SizedBox(
//         width: MediaQuery.of(context).size.width * 0.6,
//         child: ElevatedButton(
//             style: ElevatedButton.styleFrom(
//               shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30)),
//               primary: Colors.blue,
//             ),
//             child: const Text(
//               "Save",
//               style: TextStyle(
//                   color: Colors.white,
//                   fontWeight: FontWeight.w300,
//                   fontSize: 22),
//             ),
//             onPressed: () {
//               submit(context);
//             }),
//       ),
//     ];
//   }
//
//   bool isValid() {
//     final form = _formKey.currentState;
//
//     form!.save();
//     if (form.validate()) {
//       form.save();
//       return true;
//     } else {
//       return false;
//     }
//   }
//
//   void submit(BuildContext context) async {
//     if (isValid()) {
//       try {
//         updateProfile(context, progressDialog!);
//       } catch (error) {
//         setState(() {
//           _warning = error.toString();
//           isLoginPressed = false;
//         });
//         debugPrint(error.toString());
//       }
//     }
//   }
//
//   InputDecoration buildSignUpinputDecoration(
//       String labelHint, String labelText) {
//     return InputDecoration(
//       labelText: labelText,
//       fillColor: Colors.white,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(30.0),
//         borderSide: const BorderSide(),
//       ),
//       //fillColor: Colors.green
//     );
//   }
//
//   List<Widget> _buildWidgets() {
//     List<Widget> textfields = [];
//     textfields.add(TextFormField(
//       style: const TextStyle(fontSize: 22),
//       validator: NameValidator!.validate,
//       controller: _nameController,
//       decoration: buildSignUpinputDecoration("Name", "Enter your Name"),
//       keyboardType: TextInputType.text,
//       onSaved: (String value) => _name = value,
//     ));
//     textfields.add(const SizedBox(
//       height: 20,
//     ));
//     textfields.add(TextFormField(
//       style: const TextStyle(fontSize: 22),
//       validator: NameValidator.validate,
//       controller: _countryController,
//       enabled: true,
//       decoration: buildSignUpinputDecoration("Country", "Enter Your Country"),
//       keyboardType: TextInputType.emailAddress,
//       onSaved: (String value) => _country = value,
//     ));
//     textfields.add(const SizedBox(
//       height: 20,
//     ));
//     textfields.add(TextFormField(
//       style: const TextStyle(fontSize: 22),
//       validator: EmailValidator.validate,
//       controller: _emailController,
//       enabled: false,
//       decoration:
//           buildSignUpinputDecoration("Email", "Enter The Email Address"),
//       keyboardType: TextInputType.emailAddress,
//       onSaved: (String value) => _email = value,
//     ));
//     textfields.add(const SizedBox(
//       height: 20,
//     ));
//
//     return textfields;
//   }
//
//   _buildErrorWidget() {
//     if (_warning != null) {
//       return Container(
//         color: Colors.yellow,
//         width: double.infinity,
//         padding: const EdgeInsets.all(8),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Padding(
//               padding: const EdgeInsets.only(right: 8.0),
//               child:
//                   IconButton(icon: const Icon(Icons.error_outline), onPressed: () {}),
//             ),
//             Expanded(
//               child: AutoSizeText(
//                 _warning,
//                 maxLines: 3,
//                 style: const TextStyle(color: Colors.red, fontSize: 16),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 8),
//               child: IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () {
//                     setState(() {
//                       _warning = null;
//                     });
//                   }),
//             ),
//           ],
//         ),
//       );
//     } else {
//       return const SizedBox.shrink();
//     }
//   }
// }
