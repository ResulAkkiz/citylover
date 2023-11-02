import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class ErrorDialogWidget extends StatelessWidget {
  const ErrorDialogWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      child: Dialog(
        child: Stack(
          fit: StackFit.loose,
          alignment: Alignment.topCenter,
          children: [
            Container(
              width: MediaQuery.sizeOf(context).width * 0.7,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.amber),
              child: const Text(
                "Hata: Lorem ipsum sit amet amk",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
            Container(
              color: Colors.blue,
              child: Lottie.network(
                  'https://lottie.host/c0daee69-391c-4176-8de5-9b264b279827/N1D5xuFKES.json',
                  width: 150,
                  height: 150),
            )
          ],
        ),
      ),
    );
  }
}
