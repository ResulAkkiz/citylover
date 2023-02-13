import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/pages/authentication/login_page.dart';
import 'package:citylover/pages/authentication/signup_page.dart';
import 'package:citylover/pages/homepage/home_page.dart';
import 'package:csc_picker/csc_picker.dart';
import 'package:flutter/material.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  String address = "";
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: CSCPicker(
                  layout: Layout.vertical,

                  ///Enable disable state dropdown [OPTIONAL PARAMETER]
                  showStates: true,

                  /// Enable disable city drop down [OPTIONAL PARAMETER]
                  showCities: false,

                  ///Enable (get flag with country name) / Disable (Disable flag) / ShowInDropdownOnly (display flag in dropdown only) [OPTIONAL PARAMETER]
                  flagState: CountryFlag.SHOW_IN_DROP_DOWN_ONLY,

                  ///Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER] (USE with disabledDropdownDecoration)
                  dropdownDecoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xff000000),
                      width: 1.3,
                      style: BorderStyle.solid,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(8.0)),
                  ),

                  ///Disabled Dropdown box decoration to style your dropdown selector [OPTIONAL PARAMETER]  (USE with disabled dropdownDecoration)
                  disabledDropdownDecoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      color: Colors.grey.shade300,
                      border:
                          Border.all(color: Colors.grey.shade300, width: 1)),

                  countrySearchPlaceholder: "Ülke",
                  stateSearchPlaceholder: "Şehir",
                  citySearchPlaceholder: "İlçe",

                  countryDropdownLabel: "*Ülke",
                  stateDropdownLabel: "*Şehir",
                  cityDropdownLabel: "*İlçe",

                  ///Disable country dropdown (Note: use it with default country)
                  //disableCountry: true,

                  ///Country Filter [OPTIONAL PARAMETER]
                  // countryFilter: const [
                  //   CscCountry.India,
                  //   CscCountry.United_States,
                  //   CscCountry.Canada,
                  //   CscCountry.Turkey,
                  // ],

                  ///selected item style [OPTIONAL PARAMETER]
                  selectedItemStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  dropdownHeadingStyle: const TextStyle(
                      color: Colors.black,
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                  dropdownItemStyle: const TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                  ),
                  dropdownDialogRadius: 10.0,
                  searchBarRadius: 10.0,
                  onCountryChanged: (value) {
                    setState(() {
                      countryValue = value;
                    });
                  },
                  onCityChanged: (value) {},
                  onStateChanged: (value) {
                    setState(() {
                      stateValue = value ?? '';
                    });
                  },
                ),
              ),
              // Padding(
              //   padding: const EdgeInsets.symmetric(horizontal: 36.0),
              //   child: Column(
              //     children: [
              //       DropdownButtonFormField<String>(
              //         items: const [
              //           DropdownMenuItem(
              //             child: Text('Ülke'),
              //           )
              //         ],
              //         onChanged: (value) {},
              //       ),
              //       DropdownButtonFormField<String>(
              //         items: const [
              //           DropdownMenuItem(
              //             child: Text('Şehir'),
              //           )
              //         ],
              //         onChanged: (value) {},
              //       )
              //     ],
              //   ).separated(
              //     const SizedBox(
              //       height: 16,
              //     ),
              //   ),
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const SignupPage()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const StadiumBorder()),
                    child: const Text('Üye Ol'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const LoginPage()));
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: const StadiumBorder()),
                    child: const Text('Oturum Aç'),
                  )
                ],
              ),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const HomePage()));
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const StadiumBorder()),
                  child: const Text('Üye olmadan devam et...'))
            ],
          ).separated(
            const SizedBox(
              height: 36,
            ),
          ),
        ),
      ),
    ));
  }
}


 // fetchDataCountry().then((value) {
    //   if (value["results"] is List) {
    //     List<String> countryList = [];
    //     for (Map<String, dynamic> element in value["results"]) {
    //       countryList.add(element['name']);
    //     }
    //     debugPrint(countryList.length.toString());
    //   }
    // });

    // fetchDataCities().then((value) {
    //   if (value["results"] is List) {
    //     List<String> countryList = [];
    //     for (Map<String, dynamic> element in value["results"]) {
    //       debugPrint(element['name']);
    //       countryList.add(element['name']);
    //     }
    //     debugPrint(countryList.length.toString());
    //   }
    // });