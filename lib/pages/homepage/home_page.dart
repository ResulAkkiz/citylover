import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/pages/addsharing/add_sharing_page.dart';
import 'package:citylover/pages/homepage/widgets/drawer_widget.dart';
import 'package:citylover/pages/sharingdetail/detail_sharing_page.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
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
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: const DrawerWidget(),
      body: SafeArea(
        child: Center(
            child: ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const DetailSharingPage(),
                ));
              },
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://randomuser.me/api/portraits/men/75.jpg'),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        '11:12 • 11/02/2023',
                        style: TextStyle(
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
          itemCount: 100,
          separatorBuilder: (BuildContext context, int index) {
            return const Divider(thickness: 1.2);
          },
        )),
      ),
    );
  }
}
