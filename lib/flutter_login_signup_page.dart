library flutter_login_signup_page;

import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_pickers.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

///Returns a <Widget>[] TextFormField
_getTextForm({
  @required Widget icon,
  @required String label,
  @required Color outlineColor,
  @required BuildContext context,
  @required TextEditingController textEditController,
  @required var validator,
  @required Color textFieldBackgroundColor,
  @required bool isPassword,
  @required TextStyle errorTextStyle,
  @required OutlineInputBorder errorBorder,
  double marginTop: 0.0,
  double marginBottom: 0.0,
}) {
  return <Widget>[
    new Row(
      children: <Widget>[
        new Expanded(
          child: new Container(
            margin: EdgeInsets.only(top: marginTop, bottom: 16.0),
            padding: const EdgeInsets.only(left: 40.0),
            child: new Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: outlineColor != null ? outlineColor : Colors.blue,
                fontSize: 15.0,
              ),
            ),
          ),
        ),
      ],
    ),
    new Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(
        left: 30.0,
        right: 30.0,
      ),
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 0.0, right: 0.0),
      child: new Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          new Expanded(
            child: new TextFormField(
              obscureText: isPassword ? true : false,
              controller: textEditController,
              validator: validator,
              decoration: new InputDecoration(
                  errorBorder: errorBorder,
                  errorStyle: errorTextStyle,
                  prefixIcon: icon,
                  prefixStyle: new TextStyle(color: Colors.purple),
                  contentPadding: const EdgeInsets.only(
                      left: 10.0, top: 10.0, bottom: 10.0),
                  border: new OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1.0,
                    ),
                    gapPadding: 1.0,
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(30.0),
                    ),
                  ),
                  filled: true,
                  focusedBorder: new OutlineInputBorder(
                      gapPadding: 1.0,
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                      borderSide: BorderSide(
                          color: outlineColor != null
                              ? outlineColor
                              : Colors.blue)),
                  fillColor: textFieldBackgroundColor != null
                      ? textFieldBackgroundColor
                      : Colors.white70),
            ),
          ),
        ],
      ),
    )
  ];
}

class LoginAndSignUpPage extends StatefulWidget {
  Function imagePickerButtonClickedFunction;
  Color imagePickerBackgroundColor;
  Color textFormOutlineColor;
  String backgroundImageUrl;
  SignInButtonClickedCallback signInButtonCallback;
  SignUpButtonClickedCallback signUpButtonCallback;
  DecorationImage backgroundDecorationImageSignInUpHomePage;
  DecorationImage backgroundDecorationImageSignInPage;
  DecorationImage backgroundDecorationImageSignUpPage;
  TextStyle errorTextStyle;
  OutlineInputBorder errorBorder;

  LoginAndSignUpPage(
      {@required this.imagePickerButtonClickedFunction,
      @required this.imagePickerBackgroundColor,
      @required this.backgroundImageUrl,
      @required this.textFormOutlineColor,
      @required this.signInButtonCallback,
      @required this.signUpButtonCallback,
      @required this.backgroundDecorationImageSignInPage,
      @required this.backgroundDecorationImageSignInUpHomePage,
      @required this.backgroundDecorationImageSignUpPage,
      @required this.errorTextStyle,
      @required this.errorBorder});

  @override
  _LoginAndSignUpPageState createState() => _LoginAndSignUpPageState();
}

class _LoginAndSignUpPageState extends State<LoginAndSignUpPage> {
  final _formKeyLogin = GlobalKey<FormState>();
  final _formKeySignUp = GlobalKey<FormState>();
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  TextEditingController signUpFirstNameController = TextEditingController();
  TextEditingController signUpLastNameController = TextEditingController();
  TextEditingController signUpEmailController = TextEditingController();
  TextEditingController signUpPasswordController = TextEditingController();
  TextEditingController signUpConfirmPasswordController =
      TextEditingController();

//  TextEditingController signUpFirstNaController = TextEditingController();

  final String emailNotValidText = 'Email is not valid';
  final String passwordNotValidText =
      'Password must not be less than 6 characters';
  final String confirmPasswordNotValidText = 'Password does not match';
  final String fieldEmptyText = "Field Must not be empty";

  String password = "";

  PageController _controller =
      new PageController(initialPage: 1, viewportFraction: 1.0);

  String _selectedTitle = "Title";
  Image _selectedTitleIcon = Image.asset(
    "images/mr.png",
    width: 40.0,
    height: 40.0,
  );

  Country _selectedDialogCountry = CountryPickerUtils.getCountryByIsoCode('tr');

  Widget _countryFlag = Image.asset("name");

  Future<File> _imageFile;

  VoidCallback listeneer;

  File imageMainFile;

  @override
  Widget build(BuildContext context) {
//    return _getLoginPage()
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: new BoxDecoration(
          image: widget.backgroundDecorationImageSignInUpHomePage),
      child: PageView(
        children: <Widget>[
          _getLoginPage(),
          _getSignUpSignInHomepage(),
          _getSignUpPage()
        ],
        scrollDirection: Axis.horizontal,
        controller: _controller,
      ),
    );
  }

  ///This method when called sets the image returned by the image picker
  setImage(String imageUrl) {
    setState(() {
      //TODO: Sets the circle avarta for image to the image selected
    });
  }

  Widget _buildDialogItem(Country country) {
    _countryFlag = CountryPickerUtils.getDefaultFlagImage(country);

//    _countryCode = "+${country.phoneCode}";

    return Row(
      children: <Widget>[
        CountryPickerUtils.getDefaultFlagImage(country),
        SizedBox(width: 8.0),
        SizedBox(width: 8.0),
        Flexible(child: Text(country.name))
      ],
    );
  }

  String _confirmPasswordValidator(String value) {
    if (value.isEmpty) return fieldEmptyText;

    if (value != password) return confirmPasswordNotValidText;
  }

  String _emailValidator(String value) {
    //String value = email;
    if (value.isEmpty) {
      return "Email Field cannot be empty";
    }

    // This is just a regular expression for email addresses
    String p = "[a-zA-Z0-9\+\.\_\%\-\+]{1,256}" +
        "\\@" +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,64}" +
        "(" +
        "\\." +
        "[a-zA-Z0-9][a-zA-Z0-9\\-]{0,25}" +
        ")+";
    RegExp regExp = new RegExp(p);

    if (regExp.hasMatch(value)) {
      // So, the email is valid
      return null;
    }

    // The pattern of the email didn't match the regex above.
    return emailNotValidText;
  }

  _getCountryPrefixIcon() {
    return ListTile(
      onTap: _openCountryPickerDialog,
      title: _buildDialogItem(_selectedDialogCountry),
    );
  }

  _getDialogTextForm({
    @required String formTitle,
    @required Widget prefixIcon,
    @required double marginTop: 0.0,
    @required double marginBottom: 0.0,
    @required Color outlineColor,
  }) {
    return <Widget>[
      new Row(
        children: <Widget>[
          new Container(
            margin: EdgeInsets.only(top: marginTop),
            child: new Padding(
              padding: const EdgeInsets.only(left: 40.0),
              child: new Text(
                formTitle,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: outlineColor != null ? outlineColor : Colors.blue,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
      new Container(
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(
          left: 30.0,
          right: 30.0,
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.only(left: 0.0, right: 0.0),
        child: new Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Expanded(
              child: new TextFormField(
                decoration: new InputDecoration(
                    enabledBorder: new OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide(
                        color:
                            outlineColor != null ? outlineColor : Colors.blue,
                        width: 1.0,
                      ),
                    ),
                    prefixIcon: prefixIcon,
                    contentPadding: const EdgeInsets.only(
                        left: 10.0, top: 10.0, bottom: 10.0),
                    border: new OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 1.0,
                      ),
                      gapPadding: 1.0,
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(30.0),
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.white70),
              ),
            ),
          ],
        ),
      ),
    ];
  }

  ///This method returns widget for the image and the iname picker iconButton
  _getImageAndImagePicker({
    String imageUrl,
    Color imagePickerBackgroundColor,
  }) {
    return <Widget>[
//      new Expanded(
      new Container(
        margin: EdgeInsets.only(top: 32.0),
        child: new Stack(
          children: <Widget>[
            new Positioned(
//            height: 100.0,
//            width: 100.0,
              child: new CircleAvatar(
                radius: 70.0,
                child: ClipOval(
                  child: _previewImage(),
                ),
//        backgroundImage: AssetImage(''),
                backgroundColor: Colors.grey,
              ),
            ),
            new Positioned(
                bottom: 0.0,
                right: 0.0,
                child: new CircleAvatar(
                  radius: 18.0,
                  child: new IconButton(
                    icon: new Icon(
                      Icons.add_a_photo,
                      color: Colors.white,
                      size: 24.0,
                    ),

                    ///Lets user manage what happens if the imageButton is clicked
                    onPressed: () {
                      _openImagePicker(ImageSource.gallery);
                    },
                  ),
                  backgroundColor: imagePickerBackgroundColor,
                ))
          ],
        ),
      )
//      )
    ];
  }

  ///This method returns login page
  _getLoginPage() {
    return new Scaffold(
//      resizeToAvoidBottomPadding: true,
      body: Container(
          height: MediaQuery.of(context).size.height,
          decoration: new BoxDecoration(
              image: widget.backgroundDecorationImageSignInPage,
              color: Colors.black54,
              backgroundBlendMode: BlendMode.darken),
          child: ListView(
            shrinkWrap: true,
            children: <Widget>[
//          new Container(
//            child: _getImageAndImagePicker(),
//          ),
              new Container(
                height: MediaQuery.of(context).size.height,
                child: _getSignInForm(),
                alignment: Alignment.center,
              ),
            ],
          )),
    );
  }

  ///This method returns the signIn form for the signIn Page
  _getSignInForm() {
    _setSignUpControllersListeners();

    return new Form(
        key: _formKeyLogin,
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _getImageAndImagePicker(
                    imageUrl: null, imagePickerBackgroundColor: Colors.purple) +
                _getTextForm(
                    icon: new Icon(Icons.email),
                    label: "Email",
                    outlineColor: widget.textFormOutlineColor,
                    context: context,
                    textEditController: loginEmailController,
                    textFieldBackgroundColor: null,
                    isPassword: false,
                    validator: _emailValidator,
                    errorBorder: widget.errorBorder,
                    errorTextStyle: widget.errorTextStyle,
                    marginTop: 32.0) +
                _getTextForm(
                  icon: new Icon(Icons.lock),
                  label: "Password",
                  outlineColor: widget.textFormOutlineColor,
                  context: context,
                  textEditController: loginPasswordController,
                  textFieldBackgroundColor: null,
                  isPassword: true,
                  validator: _passwordValidator,
                  errorBorder: widget.errorBorder,
                  errorTextStyle: widget.errorTextStyle,
                  marginTop: 16.0,
                ) +
                _getLoginButton(widget.signInButtonCallback)));
  }

  _getLoginButton(SignInButtonClickedCallback callback) {
    return <Widget>[
      new Container(
        margin: EdgeInsets.only(left: 32.0, right: 32.0, top: 32.0),
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.all(4.0),
        child: RaisedButton(
            shape: new RoundedRectangleBorder(
                side: new BorderSide(),
                borderRadius: BorderRadius.circular(30.0)),
            onPressed: () {
              if (_formKeyLogin.currentState.validate()) {
                callback(
                    loginEmailController.text, loginPasswordController.text);
              }
            },
            child: new Row(
                children: <Widget>[new Expanded(child: new Text("Login"))])),
      )
    ];
  }

  _getSignUpButton(SignUpButtonClickedCallback callback) {
    return <Widget>[
      new Container(
        margin:
            EdgeInsets.only(left: 32.0, right: 32.0, top: 20.0, bottom: 16.0),
        alignment: Alignment.bottomCenter,
        padding: EdgeInsets.all(4.0),
        child: RaisedButton(
            shape: new RoundedRectangleBorder(
                side: new BorderSide(),
                borderRadius: BorderRadius.circular(30.0)),
            onPressed: () {
              if (_formKeySignUp.currentState.validate()) {
                if (_selectedTitle == "Title") {
                  Scaffold.of(context).showSnackBar(
                      new SnackBar(content: new Text("Please select a title")));
                } else {
                  callback(
                      signUpFirstNameController.text,
                      signUpLastNameController.text,
                      _selectedTitle,
                      _selectedDialogCountry.name,
                      signUpEmailController.text,
                      signUpPasswordController.text,
                      imageMainFile);
                }
              }
            },
            child: new Row(
                children: <Widget>[new Expanded(child: new Text("SignUp"))])),
      )
    ];
  }

  ///This method returns the signUp for signUp page
  _getSignUpForm() {
    return new Form(
        key: _formKeySignUp,
        child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: _getImageAndImagePicker(
                    imageUrl: null, imagePickerBackgroundColor: Colors.purple) +
                _getTextForm(
                    icon: new Icon(Icons.person),
                    label: "First Name",
                    outlineColor: widget.textFormOutlineColor,
                    context: context,
                    textEditController: signUpFirstNameController,
                    textFieldBackgroundColor: null,
                    validator: _nameValidator,
                    isPassword: false,
                    errorBorder: widget.errorBorder,
                    errorTextStyle: widget.errorTextStyle,
                    marginTop: 32.0) +
                _getTextForm(
                    icon: new Icon(Icons.email),
                    label: "Last Name",
                    outlineColor: widget.textFormOutlineColor,
                    context: context,
                    textEditController: signUpLastNameController,
                    validator: _nameValidator,
                    textFieldBackgroundColor: null,
                    isPassword: false,
                    errorBorder: widget.errorBorder,
                    errorTextStyle: widget.errorTextStyle,
                    marginTop: 16.0) +
                _getDialogTextForm(
                    outlineColor: widget.textFormOutlineColor,
                    formTitle: "Title",
                    marginTop: 16.0,
                    prefixIcon: _getTitlePrefixIcon(<String>[
                      "Mr.",
                      "Mrs.",
                      "Brother",
                      "Sister",
                      ""
                    ], <Image>[
                      Image.asset(
                        "images/mr.png",
                        width: 40.0,
                        height: 40.0,
                      ),
                      Image.asset(
                        "images/mrs.png",
                        width: 40.0,
                        height: 40.0,
                      ),
                      Image.asset(
                        "images/mr.png",
                        width: 40.0,
                        height: 40.0,
                      ),
                      Image.asset(
                        "images/mr.png",
                        width: 40.0,
                        height: 40.0,
                      ),
                      Image.asset(
                        "images/pastor.png",
                        width: 40.0,
                        height: 40.0,
                      )
                    ])) +
                _getDialogTextForm(
                    outlineColor: widget.textFormOutlineColor,
                    formTitle: "Country",
                    prefixIcon: _getCountryPrefixIcon()) +
                _getTextForm(
                    icon: new Icon(Icons.email),
                    label: "Email",
                    errorBorder: widget.errorBorder,
                    errorTextStyle: widget.errorTextStyle,
                    outlineColor: widget.textFormOutlineColor,
                    context: context,
                    textEditController: signUpEmailController,
                    validator: _emailValidator,
                    textFieldBackgroundColor: null,
                    isPassword: false,
                    marginTop: 16.0) +
                _getTextForm(
                    icon: new Icon(Icons.lock),
                    label: "Password",
                    errorBorder: widget.errorBorder,
                    errorTextStyle: widget.errorTextStyle,
                    outlineColor: widget.textFormOutlineColor,
                    context: context,
                    textEditController: signUpPasswordController,
                    textFieldBackgroundColor: null,
                    validator: _passwordValidator,
                    isPassword: true,
                    marginTop: 16.0) +
                _getTextForm(
                    icon: new Icon(Icons.lock),
                    errorBorder: widget.errorBorder,
                    errorTextStyle: widget.errorTextStyle,
                    label: "Confirm Password",
                    outlineColor: widget.textFormOutlineColor,
                    context: context,
                    textEditController: signUpConfirmPasswordController,
                    textFieldBackgroundColor: null,
                    isPassword: true,
                    validator: _confirmPasswordValidator,
                    marginTop: 16.0) +
                _getSignUpButton(widget.signUpButtonCallback)));
  }

  ///Thi smethod returns signUp page
  _getSignUpPage() {
    return new Scaffold(
//      resizeToAvoidBottomPadding: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: new BoxDecoration(
            image: widget.backgroundDecorationImageSignUpPage,
            color: Colors.black54,
            backgroundBlendMode: BlendMode.darken),
        child: ListView(
          children: <Widget>[
            new Container(
              child: _getSignUpForm(),
              alignment: Alignment.center,
              margin: EdgeInsets.only(bottom: 32.0),
            ),
          ],
        ),
      ),
    );
  }

  _gotoLoginPage() {
    //controller_0To1.forward(from: 0.0);
    _controller.animateToPage(
      0,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  _gotoSignupPage() {
    //controller_minus1To0.reverse(from: 0.0);
    _controller.animateToPage(
      2,
      duration: Duration(milliseconds: 800),
      curve: Curves.bounceOut,
    );
  }

  _getSignUpSignInHomepage({String backgroundImagePath, Color buttonColor}) {
    return new Scaffold(
      body: new Container(
        alignment: Alignment.bottomCenter,
//        margin: EdgeInsets.only(left: 32.0, right: 32.0),
        height: MediaQuery.of(context).size.height,
        decoration: new BoxDecoration(
            image: widget.backgroundDecorationImageSignInUpHomePage,
            color: Colors.black54,
            backgroundBlendMode: BlendMode.darken),
        child: new Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
//            new Container(
//              child: new Text("WElCOME", style: new TextStyle(fontSize: 24.0),),
//            ),
            new Text("WELCOME!!"),

            new Container(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(left: 32.0, right: 32.0),
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.all(4.0),
                    child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                            side: new BorderSide(),
                            borderRadius: BorderRadius.circular(30.0)),
                        onPressed: _gotoLoginPage,
                        child: new Row(children: <Widget>[
                          new Expanded(child: new Text("Login"))
                        ])),
                  ),
                  new Container(
                    margin:
                        EdgeInsets.only(left: 32.0, right: 32.0, bottom: 40.0),
                    alignment: Alignment.bottomCenter,
                    padding: EdgeInsets.all(4.0),
                    child: RaisedButton(
                        shape: new RoundedRectangleBorder(
                            side: new BorderSide(),
                            borderRadius: BorderRadius.circular(30.0)),
                        onPressed: _gotoSignupPage,
                        child: new Row(children: <Widget>[
                          new Expanded(child: new Text("Sign Up"))
                        ])),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ///This method returns the status dialog box
  _getStatusDialog() {}

  _getTitlePrefixIcon(List<String> titles, List<Image> images) {
    return ListTile(
      onTap: () {
        _openTitleDialog(titles, images);
      },
      title: new Text(_selectedTitle),
      leading: _selectedTitleIcon,
    );
  }

  bool _isTextLengthGreaterThanZero(TextEditingController textC) =>
      textC.text.length > 0;

  String _nameValidator(String value) {
    if (value.isEmpty) return fieldEmptyText;
  }

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: CountryPickerDialog(
                titlePadding: EdgeInsets.all(8.0),
                searchCursorColor: Colors.pinkAccent,
                searchInputDecoration: InputDecoration(hintText: 'Search...'),
                isSearchable: true,
                title: Text('Select your phone code'),
                onValuePicked: (Country country) =>
                    setState(() => _selectedDialogCountry = country),
                itemBuilder: _buildDialogItem)),
      );

  ///This method is called when the image picker button is called
  _openImagePicker(ImageSource source) {
    setState(() {
      _imageFile = ImagePicker.pickImage(source: source);
    });
  }

  ///This method returns the title dialog box
  void _openTitleDialog(List<String> titles, List<Image> images) => showDialog(
      context: context,
      builder: (context) => Theme(
            data: Theme.of(context).copyWith(primaryColor: Colors.pink),
            child: new Dialog(
                child: new ListView.builder(
              shrinkWrap: true,
              itemCount: titles.length,
              itemBuilder: (context, index) {
                _selectedTitle = titles[0];

                return new ListTile(
                  leading: images[index],
                  title: new Text(titles[index], style: new TextStyle()),
                  onTap: () {
                    setState(() {
                      _selectedTitle = titles[index];
                      _selectedTitleIcon = images[index];
                    });
                  },
                );
              },
            )),
          ));
  String _passwordValidator(String value) {
    if (value.isEmpty) return fieldEmptyText;

    if (value.length < 8) return passwordNotValidText;
  }

  String _phoneNumberValidator(String value) {
    if (value.isEmpty) return fieldEmptyText;
  }

  Widget _previewImage() {
    return FutureBuilder<File>(
      future: _imageFile,
      builder: (BuildContext context, AsyncSnapshot<File> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.data != null) {
          imageMainFile = snapshot.data;
          return new Image.file(
            snapshot.data,
            fit: BoxFit.cover,
            height: 140.0,
            width: 140.0,
          );
        } else if (snapshot.error != null) {
          Scaffold.of(context).showSnackBar(
              new SnackBar(content: new Text("Error getting image!")));
          return Container(
            color: Colors.grey,
          );
        } else {
          Scaffold.of(context).showSnackBar(
              new SnackBar(content: new Text("Error getting image!")));
          return Container(
            color: Colors.grey,
          );
        }
      },
    );
  }

  ///This method sets the controller listeners for SignUp page,
  /// so as to listen to changes made and update th validate error
  _setSignUpControllersListeners() {
    signUpFirstNameController.addListener(() {
      if (_isTextLengthGreaterThanZero(signUpFirstNameController))
        setState(() {
          print("firstNameContronller, less than zero ------ ");
          _formKeySignUp.currentState.validate();
        });
    });

    signUpLastNameController.addListener(() {
      if (_isTextLengthGreaterThanZero(signUpLastNameController))
        setState(() {
          _formKeySignUp.currentState.validate();
        });
    });
//    signUpUserNameController.addListener(() {
//      if (_isTextLengthGreaterThanZero(signUpUserNameController))
//        setState(() {
//          _formKeySignUp.currentState.validate();
//        });
//    });
//    signUpDOBController.addListener(() {
//      if (_isTextLengthGreaterThanZero(signUpDOBController))
//        setState(() {
//          _formKeySignUp.currentState.validate();
//        });
//    });
    signUpEmailController.addListener(() {
      if (_isTextLengthGreaterThanZero(signUpEmailController))
        setState(() {
          _formKeySignUp.currentState.validate();
        });
    });
//    signUpPhoneNumberController.addListener(() {
//      if (_isTextLengthGreaterThanZero(signUpPhoneNumberController))
//        setState(() {
//          _formKeySignUp.currentState.validate();
//        });
//    });
    signUpPasswordController.addListener(() {
      if (_isTextLengthGreaterThanZero(signUpPasswordController))
        setState(() {
          password = signUpPasswordController.text;
          _formKeySignUp.currentState.validate();
        });
    });
    signUpConfirmPasswordController.addListener(() {
      if (_isTextLengthGreaterThanZero(signUpConfirmPasswordController))
        setState(() {
          _formKeySignUp.currentState.validate();
        });
    });
  }
}

typedef SignInButtonClickedCallback = void Function(
    String email, String password);

typedef SignUpButtonClickedCallback = void Function(
    String firstname,
    String lastname,
    String title,
    String country,
    String email,
    String password,
    File image);
