import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/models/country_model.dart';
import 'package:citylover/pages/authentication/login_page.dart';
import 'package:citylover/pages/authentication/signup_page.dart';
import 'package:citylover/pages/homepage/home_page.dart';
import 'package:citylover/viewmodel/place_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  LocationModel? countryValue;
  LocationModel? stateValue;
  bool isErrorVisible = false;
  late PlaceViewModel placeViewModel;
  bool isCountryReady = false;
  bool isStateReady = false;

  @override
  void initState() {
    getCountries();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    placeViewModel = Provider.of<PlaceViewModel>(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final placeViewModel = Provider.of<PlaceViewModel>(context);

    return Scaffold(
        body: SafeArea(
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 36.0),
                child: Column(children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child:
                          Image.asset('assets/images/im_city.png', scale: 2)),
                  isCountryReady
                      ? DropdownButtonFormField<LocationModel>(
                          isExpanded: true,
                          hint: const Text('Ülke'),
                          items: placeViewModel.countryNameList
                              .map((LocationModel value) {
                            return DropdownMenuItem<LocationModel>(
                              value: value,
                              child: Text(value.name),
                            );
                          }).toList(),
                          onChanged: (model) async {
                            if (model != null) {
                              await placeViewModel.loadStates(model.id);
                              countryValue = model;
                              stateValue =
                                  placeViewModel.stateNameList.isNotEmpty
                                      ? placeViewModel.stateNameList.first
                                      : null;

                              isStateReady = true;
                            }
                          },
                        )
                      : const Center(child: CircularProgressIndicator()),
                  DropdownButtonFormField<LocationModel>(
                    isExpanded: true,
                    value: stateValue,
                    hint: const Text('Şehir'),
                    items:
                        placeViewModel.stateNameList.map((LocationModel value) {
                      return DropdownMenuItem<LocationModel>(
                        value: value,
                        child: Text(value.name),
                      );
                    }).toList(),
                    onChanged: (value) {
                      stateValue = value;
                    },
                  )
                ]).separated(const SizedBox(
                  height: 12.0,
                )),
              ),
              Visibility(
                  visible: isErrorVisible,
                  child: const Text(
                    'Lütfen ülke ve şehir seçiniz.',
                    style: TextStyle(color: Colors.red),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (countryValue == null || stateValue == null) {
                        setState(() {
                          isErrorVisible = true;
                        });
                      } else {
                        placeViewModel.savePlace(
                            cityName: stateValue!, countryName: countryValue!);
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SignupPage()));
                        isErrorVisible = false;
                      }
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
                    if (countryValue == null || stateValue == null) {
                      setState(() {
                        isErrorVisible = true;
                      });
                    } else {
                      placeViewModel.savePlace(
                          cityName: stateValue!, countryName: countryValue!);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const HomePage()));
                      isErrorVisible = false;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      shape: const StadiumBorder()),
                  child: const Text('Üye olmadan devam et...'))
            ],
          ).separated(
            const SizedBox(
              height: 24,
            ),
          ),
        ),
      ),
    ));
  }

  void getCountries() async {
    final placeViewModel = Provider.of<PlaceViewModel>(context, listen: false);
    placeViewModel.loadCountries();
    isCountryReady = true;
  }
}
