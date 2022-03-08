import 'package:auto_size_text/auto_size_text.dart';
import 'package:crypto_raffle/models/coin_address_model.dart';
import 'package:crypto_raffle/services/firestore_services.dart';
import 'package:crypto_raffle/utils/validators.dart';
import 'package:crypto_raffle/widgets/message_dialog_with_ok.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
import 'package:progress_dialog/progress_dialog.dart';

class AddressPage extends StatefulWidget {
  static const String routeName = "/AddressPage";

  const AddressPage({Key? key}) : super(key: key);


  @override
  _AddressPageState createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController coinAddressController = TextEditingController();

  ProgressDialog? progressDialog;
  final FirestoreServices _fireStoreServices = FirestoreServices();
  String? coinAdd, _warning;
  bool isLoginPressed = false;
  CoinAddressModel? addressModel;

  @override
  void initState() {
    super.initState();
    _getUserAddress();
  }

  _getUserAddress() async {
    addressModel = await _fireStoreServices.getUserAddress();
    setState(() {
      coinAddressController.text = addressModel!.coinAddress;
    });
  }

  // showToastt(String message) {
  //   Fluttertoast.showToast(
  //       msg: message,
  //       toastLength: Toast.LENGTH_SHORT,
  //       gravity: ToastGravity.CENTER,
  //       timeInSecForIosWeb: 1,
  //       backgroundColor: Colors.red,
  //       textColor: Colors.white,
  //       fontSize: 16.0);
  // }

  updateAddress(BuildContext context, ProgressDialog progressDialog) async {
    progressDialog = ProgressDialog(context);
    await progressDialog.show();

    CoinAddressModel addressModel = CoinAddressModel(
      coinAddress: coinAdd!,
    );
    await _fireStoreServices.updateAddress(context, addressModel).then((val) {
      progressDialog.hide();
      showDialog(
          context: context,
          builder: (context) =>  CustomDialogWithOk(
                title: "Wallet Address Updated",
                description: "Your Wallet Addresses has been Updated,",
                primaryButtonText: "Ok",
                //primaryButtonRoute: RedeemScreen.routeName,
              ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Wallet Address"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: 30,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Add Your Coinbase Email address that you want to use for withdrawal",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: <Widget>[
                  _buildErrorWidget(),
                  Form(
                      key: _formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        children: _buildWidgets() + _buildButtons(),
                      )),
                ],
              ),
            ),
            const Divider(
              height: 10,
              color: Colors.red,
            ),
            const SizedBox(
              height: 20,
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(
                "Note- Use The correct email address , if you use incorrect  coinbase email address someone else will receive your withdrawal, we will not reponsible for it",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              height: 5,
            ),
            const Padding(
              padding: EdgeInsets.all(5.0),
              child: Text(
                "Note- If you need help regarding withdrawal of funds to your coinbase account, we have a tutorial in youtube channel.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildButtons() {
    return [
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.6,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            primary: Colors.blue,
          ),

            child: const Text(
              "Save",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 22),
            ),
            onPressed: () {
              submit(context);
            }),
      ),
    ];
  }

  bool isValid() {
    final form = _formKey.currentState;

    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit(BuildContext context) async {
    if (isValid()) {
      try {
        updateAddress(context, progressDialog);
      } catch (error) {
        setState(() {
          _warning = error.message;
          isLoginPressed = false;
        });
        debugPrint(error);
      }
    } else {
      showToastt("Please Enter A valid Address");
    }
  }

  InputDecoration buildSignUpinputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: const TextStyle(fontSize: 10),
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10.0),
        borderSide: const BorderSide(),
      ),
      //fillColor: Colors.green
    );
  }

  List<Widget> _buildWidgets() {
    List<Widget> textfields = [];

    textfields.add(const Text(
      "Coinbase Address",
      textAlign: TextAlign.start,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ));
    textfields.add(const SizedBox(
      height: 5,
    ));

    textfields.add(TextFormField(
      style: const TextStyle(fontSize: 22),
      validator: EmailValidator.validate,
      controller: coinAddressController,
      enabled: true,
      decoration: buildSignUpinputDecoration("Enter Your coinbase email"),
      keyboardType: TextInputType.text,
      onSaved: (String value) => coinAdd = value,
    ));
    textfields.add(const SizedBox(
      height: 5,
    ));
    textfields.add(const Divider(
      color: Colors.red,
      height: 5,
    ));
    textfields.add(const SizedBox(
      height: 5,
    ));
    textfields.add(const Divider(
      color: Colors.red,
      height: 5,
    ));
    textfields.add(const SizedBox(
      height: 20,
    ));

    //
    return textfields;
  }

  _buildErrorWidget() {
    if (_warning != null) {
      return Container(
        color: Colors.yellow,
        width: double.infinity,
        padding: const EdgeInsets.all(8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child:
                  IconButton(icon: const Icon(Icons.error_outline), onPressed: () {}),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    setState(() {
                      _warning = null;
                    });
                  }),
            ),
          ],
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
