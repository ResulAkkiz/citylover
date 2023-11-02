import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/app_contants/image_enums.dart';
import 'package:citylover/app_contants/theme_colors.dart';
import 'package:citylover/common_widgets/error_toast.dart';
import 'package:citylover/common_widgets/icon_elevated_button.dart';
import 'package:citylover/common_widgets/location_dropdown_search.dart';
import 'package:citylover/models/country_model.dart';
import 'package:citylover/pages/authentication/login_page.dart';
import 'package:citylover/pages/authentication/signup_page.dart';
import 'package:citylover/pages/homepage/home_page.dart';
import 'package:citylover/viewmodel/place_view_model.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
  bool isStateEnabled = false;
  GlobalKey key = GlobalKey<DropdownSearchState>();

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
        body: SingleChildScrollView(
            child: Container(
      constraints: BoxConstraints(
        minHeight: MediaQuery.of(context).size.height,
      ),
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Container(
              height: MediaQuery.sizeOf(context).height * 0.4,
              decoration: BoxDecoration(
                color: ThemeColors.primary400,
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.elliptical(100, 100),
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          flex: 3,
                          child: AspectRatio(
                            aspectRatio: 20 / 9,
                            child: Image.asset(
                              ImageEnum.cloud.toPath,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Image.asset(
                            ImageEnum.register.toPath,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.only(
                          left: 12,
                          right: MediaQuery.sizeOf(context).width * 0.2,
                          bottom: 12),
                      child: const Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tekrar Hoşgeldin",
                            style: TextStyle(
                                letterSpacing: 0.6,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w900,
                                fontSize: 32,
                                color: Colors.white),
                          ),
                          SizedBox.square(
                            dimension: 4,
                          ),
                          Text(
                            "Seni, burada tekrar gördüğümüz için çok mutluyuz. Ülkeni ve şehrini seçerek, serüvene başlayabilirsin.",
                            style: TextStyle(
                                height: 1.2,
                                letterSpacing: 0.6,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w300,
                                fontSize: 14,
                                color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).separated(const SizedBox.square(
                  dimension: 12,
                )),
              )),
          Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(children: [
              if (isCountryReady)
                LocationDropDownSearch(
                  enabled: true,
                  selectedItem: countryValue,
                  hintText: "Ülke Seç...",
                  onChanged: (item) async {
                    await placeViewModel.loadStates(item!.id);
                    setState(() {
                      countryValue = item;
                      isStateEnabled = true;
                    });
                  },
                  items: placeViewModel.countryNameList,
                  showSearch: true,
                )
              else
                const Center(child: CircularProgressIndicator()),
              LocationDropDownSearch(
                key: key,
                enabled: isStateEnabled,
                selectedItem: stateValue,
                hintText: "Şehir Seç",
                onChanged: (item) {
                  stateValue = item;
                },
                items: placeViewModel.stateNameList,
                showSearch: true,
              )
            ]).separated(const SizedBox(
              height: 12.0,
            )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconElevatedButton(
                icon: const Icon(
                  Icons.person,
                  color: Colors.white, // İkon rengi
                  size: 18, // İkon boyutu
                ),
                onPressed: () {
                  if (countryValue == null || stateValue == null) {
                    showErrorToast(
                        "Lütfen ilerlemeden  önce bir ülke ve şehir seçiniz.",
                        context);
                  } else {
                    placeViewModel.savePlace(
                        cityName: stateValue!, countryName: countryValue!);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SignupPage()));
                    isErrorVisible = false;
                  }
                },
                text: "Üye Ol",
              ),
              IconElevatedButton(
                icon: const Icon(
                  Icons.key,
                  color: Colors.white, // İkon rengi
                  size: 18, // İkon boyutu
                ),
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const LoginPage()));
                },
                text: "Oturum Aç",
              ),
            ],
          ).separated(const SizedBox(
            width: 15,
          )),
          const SizedBox.square(
            dimension: 75,
          ),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.sizeOf(context).width * 0.7),
            child: IconElevatedButton(
              icon: const Icon(
                Icons.bolt_rounded,
                color: Colors.white,
                size: 18,
              ),
              onPressed: () {
                if (countryValue == null || stateValue == null) {
                  showErrorToast(
                      "Lütfen ilerlemeden  önce bir ülke ve şehir seçiniz.",
                      context);
                } else {
                  placeViewModel.savePlace(
                      cityName: stateValue!, countryName: countryValue!);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => const HomePage()));
                  isErrorVisible = false;
                }
              },
              text: "Üye olmadan devam et...",
            ),
          )
        ],
      ),
    )));
  }

  void getCountries() async {
    final placeViewModel = Provider.of<PlaceViewModel>(context, listen: false);
    placeViewModel.loadCountries();
    isCountryReady = true;
  }
}
