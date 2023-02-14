// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:citylover/app_contants/app_extensions.dart';
import 'package:citylover/models/sharingmodel.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailSharingPage extends StatefulWidget {
  const DetailSharingPage({super.key, required this.sharingModel});
  final SharingModel sharingModel;

  @override
  State<DetailSharingPage> createState() => _DetailSharingPageState();
}

class _DetailSharingPageState extends State<DetailSharingPage> {
  late SharingModel sharingModel;
  @override
  void initState() {
    sharingModel = widget.sharingModel;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: const CommentBox(),
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
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(sharingModel.userPict),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${sharingModel.userName} ${sharingModel.userSurname}',
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      '${sharingModel.countryName} / ${sharingModel.cityName}', //'$country / $province',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.black.withOpacity(0.6)),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              sharingModel.sharingContent,
              style: const TextStyle(fontSize: 16),
            ),
            Text(
              DateFormat('HH:mm•dd/MM/yyyy').format(sharingModel.sharingDate),
            ),
            const Divider(thickness: 1.2),
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return ListTile(
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

class CommentBox extends StatefulWidget {
  const CommentBox({super.key});

  @override
  State<CommentBox> createState() => _CommentBoxState();
}

class _CommentBoxState extends State<CommentBox> {
  TextEditingController commentController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: MediaQuery.of(context).viewInsets,
      child: Material(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(
            right: 8.0,
            left: 8.0,
            bottom: 2.0,
          ),
          child: Flex(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            direction: Axis.horizontal,
            children: [
              Flexible(
                flex: 8,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: TextField(
                    maxLength: 350,
                    buildCounter: (context,
                        {required currentLength,
                        required isFocused,
                        maxLength}) {
                      return Builder(builder: (context) {
                        Color color;
                        if (maxLength! - currentLength < 20 &&
                            maxLength - currentLength != 0) {
                          color = Colors.amber;
                        } else if (maxLength - currentLength == 0) {
                          color = Colors.red;
                        } else {
                          color = Colors.black54;
                        }
                        return Text(
                          '$currentLength / $maxLength',
                          style: TextStyle(color: color),
                        );
                      });
                    },
                    controller: commentController,
                    onChanged: (value) {
                      setState(() {});
                    },
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.only(bottom: 0, left: 4),
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
