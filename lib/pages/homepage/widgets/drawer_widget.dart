import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/app_contants/custom_clipper.dart';
import 'package:citylover/pages/profilepage/profile_page.dart';
import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Drawer(
        width: MediaQuery.of(context).size.width * 0.8,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            Stack(
              fit: StackFit.loose,
              alignment: AlignmentDirectional.centerStart,
              children: [
                ClipPath(
                  clipper: MyCustomClipper(),
                  child: Container(
                    color: Theme.of(context).primaryColor,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.25,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Flexible(
                        flex: 2,
                        child: InkWell(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => const ProfilePage(),
                            ));
                          },
                          child: const CircleAvatar(
                            radius: 32,
                            backgroundImage: NetworkImage(
                                'https://randomuser.me/api/portraits/men/75.jpg'),
                          ),
                        ),
                      ),
                      const Flexible(
                        flex: 5,
                        child: Text(
                          'Luser Zıkka',
                          style: TextStyle(
                              fontSize: 24, fontWeight: FontWeight.w500),
                        ),
                      )
                    ],
                  ).separated(const SizedBox(
                    width: 12,
                  )),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).primaryColor,
              ),
              margin: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem(
                          child: Text('Ülke'),
                        ),
                      ],
                      onChanged: (value) {},
                    ),
                    DropdownButtonFormField<String>(
                      items: const [
                        DropdownMenuItem(
                          child: Text('Şehir'),
                        )
                      ],
                      onChanged: (value) {},
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const StadiumBorder()),
                      child: const Text('Lokasyonu Değiştir'),
                    )
                  ],
                ).separated(
                  const SizedBox(
                    height: 16,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  ListTile(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const ProfilePage(),
                        ));
                      },
                      iconColor: Colors.black,
                      tileColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: const Icon(Icons.person),
                      title: const Text(
                        'Profil Sayfası',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      )),
                  ListTile(
                      onTap: () {
                        debugPrint('Oturum Kapatıldı');
                      },
                      iconColor: Colors.black,
                      tileColor: Theme.of(context).primaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      leading: const Icon(Icons.logout),
                      title: const Text(
                        'Oturum Kapat',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ))
                ],
              ).separated(const SizedBox(
                height: 8,
              )),
            )
          ]),
        ),
      ),
    );
  }
}
