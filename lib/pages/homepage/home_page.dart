import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/models/sharingmodel.dart';
import 'package:citylover/pages/addsharing/add_sharing_page.dart';
import 'package:citylover/pages/homepage/widgets/drawer_widget.dart';
import 'package:citylover/pages/sharingdetail/detail_sharing_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../viewmodel/user_view_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSharingListReady = false;
  List<SharingModel> sharingList = [];
  @override
  void didChangeDependencies() {
    getSharingsbyLocation(cityName: 'Ankara', countryName: 'Türkiye');
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    return Scaffold(
      floatingActionButton: Visibility(
        visible: userViewModel.user != null,
        child: FloatingActionButton(
          child: const Icon(
            Icons.add_rounded,
            size: 48,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const AddSharingPage(),
            ));
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const DrawerWidget(),
      body: isSharingListReady
          ? SafeArea(
              child: Center(
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemBuilder: (context, index) {
                    var currentSharing = sharingList[index];
                    return ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              DetailSharingPage(sharingModel: currentSharing),
                        ));
                      },
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(currentSharing.userPict),
                      ),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            currentSharing.sharingContent,
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                DateFormat('HH:mm•dd/MM/yyyy')
                                    .format(currentSharing.sharingDate),
                                // '11:12 • 11/02/2023',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black54,
                                ),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Icon(
                                    Icons.comment,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Text(
                                    '16',
                                    style: TextStyle(
                                      color: Colors.black54,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          )
                        ],
                      ).separated(const SizedBox(
                        height: 8,
                      )),
                    );
                  },
                  itemCount: sharingList.length,
                  separatorBuilder: (BuildContext context, int index) {
                    return const Divider(thickness: 1.2);
                  },
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Future<void> getSharingsbyLocation(
      {required String countryName, required String cityName}) async {
    final userViewModel = Provider.of<UserViewModel>(context);
    sharingList =
        await userViewModel.getSharingsbyLocation(countryName, cityName);
    isSharingListReady = true;
    setState(() {});
  }
}
