import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/models/country_model.dart';
import 'package:citylover/pages/authentication/login_page.dart';
import 'package:citylover/pages/authentication/signup_page.dart';
import 'package:citylover/pages/homepage/home_page.dart';
import 'package:citylover/viewmodel/place_view_model.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({super.key});

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  String countryValue = "";
  String stateValue = "";
  String cityValue = "";
  bool isErrorVisible = false;
  late PlaceViewModel placeViewModel;
  List<LocationModel> countryList = [];
  List<LocationModel> stateList = [];
  bool isCountryReady = false;
  bool isStateReady = false;

  @override
  void initState() {
    //  getCountries();
    loadExcelFile();
    // exportExcelFile();
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
                  isCountryReady
                      ? DropdownButtonFormField<int>(
                          isExpanded: true,
                          hint: const Text('Ülke'),
                          items: placeViewModel.countryList
                              .map((LocationModel value) {
                            return DropdownMenuItem<int>(
                              value: value.id,
                              child: Text(value.name),
                            );
                          }).toList(),
                          onChanged: (value) {},
                        )
                      : const Center(child: CircularProgressIndicator()),
                  DropdownButtonFormField<String>(
                    hint: const Text('Şehir'),
                    items: <String>['A', 'B', 'C', 'D'].map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (value) {},
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
                      debugPrint(countryValue + stateValue);
                      if (countryValue == '' || stateValue == '') {
                        setState(() {
                          isErrorVisible = true;
                        });
                      } else {
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
                      if (countryValue == '' || stateValue == '') {
                        setState(() {});
                        isErrorVisible = true;
                      } else {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                        isErrorVisible = false;
                      }
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
                    if (countryValue == '' || stateValue == '') {
                      setState(() {
                        isErrorVisible = true;
                      });
                    } else {
                      placeViewModel.savePlace(
                          cityName: stateValue, countryName: countryValue);
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

  Future<void> loadExcelFile() async {
    final bytes = await rootBundle.load('assets/tables/countryTable.xlsx');
    final excel = Excel.decodeBytes(bytes.buffer.asUint8List());
    final sheet = excel['country'];
    for (var row in sheet.rows) {
      for (var cell in row) {
        print(cell?.value);
      }
    }

    void getCountries() async {
      /* try {
      final file = File('/assets/tables/countryTable.xlsx');
      final bytes = await file.readAsBytes();
      final excel = Excel.decodeBytes(bytes);
      final sheet = excel['countryTable'];
    } on FileSystemException catch (e) {
      if (e.osError?.errorCode == 2) {
        print('File not found: ${e.path}');
      } else {
        print('Error opening file: $e');
      }
    } catch (e) {
      print('Error: $e');
    } */

      // Read the sheet data here...
    }
    // late var bytes;
    // try {
    //   bytes = File('assets/tables/countryTable.xlsx').readAsBytesSync();
    // } catch (e) {}

    // var excel = Excel.decodeBytes(bytes);
    // var sheet = excel['countryTable'];

    // for (var row in sheet.rows) {
    //   for (var cell in row) {
    //     print(cell?.value);
    //   }
    // }
    // final placeViewModel = Provider.of<PlaceViewModel>(context, listen: false);
    // placeViewModel.fetchDataCountry();
    // isCountryReady = true;
  }

  // void exportExcelFile() {
  //   // Create a new Excel file and add some data to it
  //   var excel = Excel.createExcel();
  //   var sheet = excel['Sheet1'];
  //   sheet.cell(CellIndex.indexByString("A1")).value = "Hello";
  //   sheet.cell(CellIndex.indexByString("B1")).value = "world";

  //   // Write the Excel file to disk
  //   File('assets/tables/deneme.xlsx').writeAsBytesSync(excel.encode()!);
  // }
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
