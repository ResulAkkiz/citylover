import 'package:citylover/app_contants/app_extensions.dart';
import 'package:flutter/material.dart';

class AddSharingPage extends StatefulWidget {
  const AddSharingPage({super.key});

  @override
  State<AddSharingPage> createState() => _AddSharingPageState();
}

class _AddSharingPageState extends State<AddSharingPage> {
  TextEditingController sharingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundImage: NetworkImage(
                      'https://randomuser.me/api/portraits/men/75.jpg'),
                ),
                const SizedBox(
                  width: 12,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Luser Zıkka',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                    Text(
                      'Kocaeli/Körfez', //'$country / $province',
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 24 * 8,
              child: TextFormField(
                onChanged: (value) {
                  setState(() {});
                },
                decoration: InputDecoration(
                    fillColor: Theme.of(context).primaryColor, filled: true),
                buildCounter: (context,
                    {required currentLength, required isFocused, maxLength}) {
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
                controller: sharingController,
                maxLines: 8,
                maxLength: 350,
              ),
            ),
            ElevatedButton(
              onPressed: sharingController.text.trim() != '' ? () {} : null,
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, shape: const StadiumBorder()),
              child: const Text('Paylaş'),
            )
          ],
        ).separated(
          const SizedBox(
            height: 16,
          ),
        ),
      ),
    );
  }
}
