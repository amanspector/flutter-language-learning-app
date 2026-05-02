import 'package:chatbot_app/appconstants/color_constant.dart';
import 'package:chatbot_app/appconstants/text_constant.dart';
import 'package:chatbot_app/provider/onboard_provider.dart';
import 'package:chatbot_app/provider/vocab_provider.dart';
import 'package:chiclet/chiclet.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class VocabScreen extends StatelessWidget {
  // @override void initState() {
  //   super.initState();

  //   WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
  //     final onboard_provider = context.read<OnboardProvider>();
  //     print("Selected Daily goal :${onboard_provider.selectedDailyGoal}");
  //     print(
  //       "Selected Experince Level : ${onboard_provider.selectedExperienceLevel}",
  //     );
  //     print("Selected language : ${onboard_provider.selectedlanguage}");
  //     print("Selected goal : ${onboard_provider.selectedgoal}");
  //   });
  //   Future.microtask(() {
  //     context.read<VocabProvider>().loadWords();
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    String? language;
    final provider = context.watch<VocabProvider>();
    final onboard_provider = context.read<OnboardProvider>();
    // bulbul artists:v2 are: anushka, abhilash, manisha, vidya, arya, karun, hitesh"
    String speaker = "abhilash";

    final words = provider.allWords;

    if (words.isEmpty) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final word = provider.currentWord;
    if (onboard_provider.selectedlanguage == "Hindi") {
      language = "hi-IN";
    } else if (onboard_provider.selectedlanguage == "Spanish") {
      language = "es-ES";
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorConstant.color_darkblueshade500,
        appBar: AppBar(
          backgroundColor: ColorConstant.color_blueDark_shade,
          surfaceTintColor: ColorConstant.color_transparent,
          leading: SizedBox(),
          title: Text("Word ${provider.currentIndex + 1} / ${words.length}"),
          centerTitle: true,
        ),

        body: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) {
              return;
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: provider.toggleMeaning,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorConstant.color_white_withalpha30,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    height: MediaQuery.heightOf(context) * 0.4,
                    width: MediaQuery.widthOf(context),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 90),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: ColorConstant.color_white_withalpha30,
                          ),
                          child: IconButton(
                            iconSize: 30,
                            onPressed: () {
                              // provider.speak(text: word.word, language: "gu-IN");
                              provider.speak(
                                speaker: speaker,
                                // text: "નમસ્તે! આપનું સ્વાગત છે।",
                                text: word!.word,
                                language: language!,
                              );
                            },
                            icon: const Icon(Icons.volume_up),
                            // label: const Text("Listen"),
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          word!.word,
                          style: const TextStyle(
                            fontSize: 38,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        Container(
                          height: 150,
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),

                          child: provider.showMeaning
                              ? Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      word.translation,
                                      style: Theme.of(
                                        context,
                                      ).textTheme.bodyMedium,
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          word.example,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                        SizedBox(width: 20),
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              25,
                                            ),
                                            color: ColorConstant
                                                .color_white_withalpha30,
                                          ),
                                          child: IconButton(
                                            iconSize: 20,
                                            onPressed: () {
                                              provider.speak(
                                                speaker: speaker,
                                                text: word.example,
                                                language: language!,
                                              );
                                            },
                                            icon: Icon(
                                              // color: ColorConstant.color_white,
                                              Icons.volume_up_outlined,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              : Center(
                                  child: Text(
                                    "Tap to reveal meaning",
                                    style: TextStyle(
                                      color: Colors.white38,
                                      //  Theme.of(
                                      //   context,
                                      // ).colorScheme.primaryContainer,
                                    ),
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Text(
                //   word!.word,
                //   style: const TextStyle(fontSize: 38, fontWeight: FontWeight.bold),
                // ),

                // const SizedBox(height: 20),

                // ElevatedButton.icon(
                //   onPressed: () {
                //     // provider.speak(text: word.word, language: "gu-IN");
                //     provider.speak(
                //       speaker: "hitesh",
                //       // text: "નમસ્તે! આપનું સ્વાગત છે।",
                //       text: word.word,
                //       language: language!,
                //     );
                //   },
                //   icon: const Icon(Icons.volume_up),
                //   label: const Text("Listen"),
                // ),
                // const SizedBox(height: 30),

                // GestureDetector(
                //   onTap: provider.toggleMeaning,
                //   child: Container(
                //     width: double.infinity,
                //     padding: const EdgeInsets.all(18),
                //     decoration: BoxDecoration(
                //       color: Colors.grey.shade200,
                //       borderRadius: BorderRadius.circular(16),
                //     ),
                //     child: provider.showMeaning
                //         ? Column(
                //             mainAxisAlignment: MainAxisAlignment.center,
                //             crossAxisAlignment: CrossAxisAlignment.center,
                //             children: [
                //               Text(
                //                 word.translation,
                //                 style: Theme.of(context).textTheme.labelMedium,
                //               ),
                //               const SizedBox(height: 10),
                //               Row(
                //                 mainAxisAlignment: MainAxisAlignment.center,
                //                 crossAxisAlignment: CrossAxisAlignment.center,
                //                 children: [
                //                   Text(
                //                     word.example,
                //                     style: Theme.of(context).textTheme.labelMedium,
                //                   ),
                //                   IconButton(
                //                     onPressed: () {
                //                       provider.speak(
                //                         speaker: "hitesh",

                //                         text: word.example,
                //                         language: language!,
                //                       );
                //                     },
                //                     icon: Icon(
                //                       color: ColorConstant.color_black,
                //                       Icons.volume_up_outlined,
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ],
                //           )
                //         : Center(
                //             child: Text(
                //               "Tap to reveal meaning",
                //               style: Theme.of(context).textTheme.labelMedium,
                //             ),
                //           ),
                //   ),
                // ),
                const SizedBox(height: 40),

                ChicletOutlinedAnimatedButton(
                  width: MediaQuery.widthOf(context),
                  borderColor: ColorConstant.color_blue,
                  buttonColor: ColorConstant.color_bluelight,
                  backgroundColor: ColorConstant.color_blue,
                  onPressed: provider.nextWord,
                  buttonType: ChicletButtonTypes.roundedRectangle,
                  child: Text(
                    Textconstant.txt_nextword,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),

                // ElevatedButton(
                //   onPressed: provider.nextWord,
                //   child: const Text("Next Word"),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
