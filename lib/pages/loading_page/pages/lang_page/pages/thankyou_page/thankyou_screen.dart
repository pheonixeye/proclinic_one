import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:proklinik_doctor_portal/assets/assets.dart';

class ThankyouPage extends StatelessWidget {
  const ThankyouPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        alignment: Alignment.center,
        children: [
          SvgPicture.asset(
            AppAssets.bgSvg,
            fit: BoxFit.cover,
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  AppAssets.icon,
                  width: 50,
                  height: 50,
                ),
                const SizedBox(width: 10),
                const Text(
                  'ProKliniK',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'شكرا علي اكمال التعاقد',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  ' نود أن نعرب عن امتناننا لإتاحة الفرصة لنا للعمل معك خلال فترة العقد. ان دعمكم وتعاونكم لا يقدر بثمن بالنسبة لنا، ونحن ممتنون للثقة التي وضعتموها في خدماتنا. ومع بداية العقد، نود أن نعرب عن أطيب تمنياتنا لمساعيك المستقبلية. إذا كنت بحاجة إلى أي مساعدة في المستقبل، فلا تتردد في التواصل معنا. نحن ملتزمون بالحفاظ على علاقة إيجابية ومهنية معك. ',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {},
                label: const Text('لوحة التحكم'),
                icon: const Icon(Icons.check),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
