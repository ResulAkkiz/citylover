// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:citylover/app_contants/app_extensions.dart';
import 'package:flutter/material.dart';

class DetailSharingPage extends StatefulWidget {
  const DetailSharingPage({super.key});

  @override
  State<DetailSharingPage> createState() => _DetailSharingPageState();
}

class _DetailSharingPageState extends State<DetailSharingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNavigationBarWidget(),
      appBar: AppBar(
        title: const Text(
          'Paylaşım',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/75.jpg'),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Luser Zıkka',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Kocaeli/Körfez', //'$country / $province',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.6)),
                    ),
                  ],
                ),
              ],
            ),
            const Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum',
              style: TextStyle(fontSize: 16),
            ),
            const Text('11:12 • 11/02/2023'),
            const Divider(thickness: 1.2),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const DetailSharingPage(),
                      ));
                    },
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          'https://randomuser.me/api/portraits/med/men/$index.jpg'),
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Bahar Gündoğdu',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                        Text(
                          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          '11:12 • 11/02/2023',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ).separated(const SizedBox(
                      height: 4,
                    )));
              },
              itemCount: 25,
              separatorBuilder: (BuildContext context, int index) {
                return const Divider(thickness: 1.2);
              },
            )
          ],
        ).separated(
          const SizedBox(
            height: 8,
          ),
        ),
      ),
    );
  }
}

class BottomNavigationBarWidget extends StatefulWidget {
  const BottomNavigationBarWidget({super.key});

  @override
  State<BottomNavigationBarWidget> createState() =>
      _BottomNavigationBarWidgetState();
}

class _BottomNavigationBarWidgetState extends State<BottomNavigationBarWidget> {
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            direction: Axis.horizontal,
            children: [
              Flexible(
                flex: 8,
                child: TextField(
                  controller: commentController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.only(bottom: -15, left: 4),
                    hintText: 'Yorumunu Paylaş',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(width: 1, color: Colors.black),
                    ),
                  ),
                ),
              ),
              Flexible(
                  flex: 1,
                  child: IconButton(
                    color: Colors.amber,
                    icon: const Icon(Icons.arrow_forward_ios_outlined),
                    onPressed:
                        commentController.text.trim() != '' ? () {} : null,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
