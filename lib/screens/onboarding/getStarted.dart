import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:chatbot_app/appconstants/color_constant.dart';
import 'package:chatbot_app/appconstants/text_constant.dart';
import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';

class Getstarted extends StatefulWidget {
  const Getstarted({super.key});

  @override
  State<Getstarted> createState() => _GetstartedState();
}

class _GetstartedState extends State<Getstarted> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        bottomNavigationBar: SizedBox(
          height: 150,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Divider(color: ColorConstant.color_white_withalpha30),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: ChicletOutlinedAnimatedButton(
                  width: MediaQuery.widthOf(context),
                  borderColor: ColorConstant.color_blue,
                  buttonColor: ColorConstant.color_bluelight,
                  backgroundColor: ColorConstant.color_blue,
                  onPressed: () {},
                  buttonType: ChicletButtonTypes.roundedRectangle,
                  child: Text(
                    Textconstant.txt_getstarted,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
              SizedBox(height: 10),

              TextButton(
                onPressed: () {},
                child: Text(
                  Textconstant.txt_alreadyhaveanaccount,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        backgroundColor: ColorConstant.color_darkblueshade500,
        appBar: AppBar(
          backgroundColor: ColorConstant.color_blueDark_shade,
          surfaceTintColor: ColorConstant.color_transparent,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Image.asset('assets/icon/appicon.png'),
          ),
          title: Text(
            Textconstant.txt_appname,
            style: TextStyle(
              color: ColorConstant.color_white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 30.0),
                child: SizedBox(
                  height: 130,
                  child: AnimatedTextKit(
                    repeatForever: true,
                    displayFullTextOnTap: true,
                    pause: Duration(seconds: 2),
                    animatedTexts: [
                      TyperAnimatedText(
                        Textconstant.txt_heading1,
                        speed: Duration(milliseconds: 90),
                        textStyle: Theme.of(context).textTheme.displayLarge,
                      ),

                      TyperAnimatedText(
                        Textconstant.txt_heading2,
                        speed: Duration(milliseconds: 90),
                        textStyle: Theme.of(context).textTheme.displayLarge,
                      ),
                      TyperAnimatedText(
                        Textconstant.txt_heading3,
                        speed: Duration(milliseconds: 90),
                        textStyle: Theme.of(context).textTheme.displayLarge,
                      ),
                    ],
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(left: 14.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: ColorConstant.color_white_withalpha30,
                          border: Border.all(
                            width: 2,
                            color: ColorConstant.color_white_withalpha30,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  'assets/icon/icon_fasttrack.png',
                                ),
                              ),
                            ),
                            Text(
                              Textconstant.txt_fasttrack,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10.0,
                        vertical: 20,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(15),

                        decoration: BoxDecoration(
                          color: ColorConstant.color_white_withalpha30,

                          border: Border.all(
                            color: ColorConstant.color_white_withalpha30,

                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: SizedBox(
                                height: 30,
                                width: 30,
                                child: Image.asset(
                                  'assets/icon/icon_deepfocus.png',
                                ),
                              ),
                            ),
                            Text(
                              Textconstant.txt_deepfocus,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              cardLayout(
                imageurl: "assets/icon/icon_book.png",
                title: Textconstant.txt_curatedcontent,
                content: Textconstant.txt_lessonbuild,
              ),

              cardLayout(
                imageurl: "assets/icon/icon_tree.png",
                title: Textconstant.txt_smartprogress,
                content: Textconstant.txt_visualyourjourney,
              ),

              cardLayout(
                imageurl: "assets/icon/icon_stars.png",
                title: Textconstant.txt_aestheticfocus,
                content: Textconstant.txt_minimalistUI,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget cardLayout({
    required String imageurl,
    required String title,
    required String content,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: ColorConstant.color_white_withalpha30,
          ),
          borderRadius: BorderRadius.circular(30),
          color: ColorConstant.color_white_withalpha30,
        ),
        height: 200,
        width: 80,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 30,
                  width: 30,
                  child:
                      // Image.asset("assets/icon/icon_book.png"),
                      Image.asset(imageurl),
                ),
              ),
              Text(
                // Textconstant.txt_curatedcontent,
                title,
                style: Theme.of(context).textTheme.displayMedium,
              ),
              Text(
                content,
                // Textconstant.txt_lessonbuild,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
