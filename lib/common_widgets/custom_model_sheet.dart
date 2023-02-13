import 'package:flutter/material.dart';

Future<dynamic> buildShowModelBottomSheet(
    BuildContext context, String text, IconData icon) {
  return showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0), topRight: Radius.circular(24.0)),
      ),
      backgroundColor: Theme.of(context).primaryColor,
      context: context,
      builder: (builder) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox.square(
                dimension: MediaQuery.of(context).size.width * 0.3,
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 60,
                ),
              ),
              Flexible(
                child: Container(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(text,
                      overflow: TextOverflow.clip,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 24,
                        color: Colors.white,
                      )),
                ),
              ),
            ],
          ),
        );
      });
}
