import 'package:bytebrahmand_codeshastra/constants/colors.dart';
import 'package:bytebrahmand_codeshastra/models/schemes_model.dart';
import 'package:bytebrahmand_codeshastra/widgets/lava/lava_clock.dart';
import 'package:flutter/material.dart';
import 'package:bytebrahmand_codeshastra/widgets/youtube_widget.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:glassmorphism/glassmorphism.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:url_launcher/url_launcher.dart';

class MorePage extends StatefulWidget {
  const MorePage({super.key});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  List<String> ytLinks = [
    "https://www.youtube.com/watch?v=NmMlr-wJsjE&pp=ygUkaHdvIHRvIGlycmlnYXRlIGNyb3BzIHByb3Blcmx5IGZhcm1z",
    "https://www.youtube.com/watch?v=AYEo2udXM80&pp=ygUdaG93IGNhbiBhIGZhcm1lciBjaG9vc2UgY3JvcHM%3D",
    "https://www.youtube.com/watch?v=wougJaN_Ha0&pp=ygUjaG93IGNhbiBhIGZhcm1lciBjaG9vc2UgY3JvcHMgaGluZGk%3D"
  ];
  List<String> ytTitles = [];
  List<String> ytDuration = [];
  List<String> ytThumbnails = [];
  getData(url) async {
    String embedUrl = "https://www.youtube.com/oembed?url=$url&format=json";
    var response = await http.get(Uri.parse(embedUrl));
    try {
      if (response.statusCode == 200) {
        // print(response.body);
        return jsonDecode(response.body);
      } else {
        return null;
      }
    } on FormatException catch (e) {
      print('invalid JSON' + e.toString());
      return null;
    }
  }

  getTitles() async {
    int i;
    for (i = 0; i < ytLinks.length; i++) {
      dynamic jsonData = await getData(ytLinks[i]);
      String title = jsonData["title"];
      String thumbnail = jsonData["thumbnail_url"];
      ytTitles.add(title);
      ytThumbnails.add(thumbnail);
    }
  }

  List<SchemeModel> schemes = [
    SchemeModel(
        schemeName: "PM Kisan Yojana",
        schemeDescription:
            "These schemes provide financial protection to farmers in case of crop failure due to natural calamities",
        schemeBenefits: "\u20B9 6000 per year",
        schemeLink: "schemeLink"),
    SchemeModel(
        schemeName: "Pradhan Mantri Kisan Samman Nidhi",
        schemeDescription: "Income support scheme for all farmers.",
        schemeBenefits: "Upto \u20B9 1000 per month",
        schemeLink: "schemeLink"),
    SchemeModel(
        schemeName: "Pradhan Mantri Fasal Bima Yojana",
        schemeDescription: "Crop insurance scheme for farmers.",
        schemeBenefits: "\u20B9 1000 per year",
        schemeLink: "schemeLink"),
    SchemeModel(
        schemeName: "Pradhan Mantri Kisan Maan Dhan Yojana",
        schemeDescription: "Pension scheme for farmers.",
        schemeBenefits: "\u20B9 2000 per year",
        schemeLink: "schemeLink"),
    SchemeModel(
        schemeName: "Pradhan Mantri Kisan Credit Card Yojana",
        schemeDescription: "Credit card scheme for farmers.",
        schemeBenefits: "Free Credit Card",
        schemeLink: "schemeLink"),
    SchemeModel(
        schemeName: "Pradhan Mantri Krishi Sinchai Yojana",
        schemeDescription: "Irrigation scheme for farmers.",
        schemeBenefits: "\u20B9 2000 per year",
        schemeLink: "schemeLink"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              AppLocalizations.of(context)!.governmentSchemes,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          SizedBox(
            height: 240,
            child: ListView.builder(
                shrinkWrap: true,
                primary: false,
                scrollDirection: Axis.horizontal,
                itemCount: schemes.length,
                itemBuilder: (context, index) {
                  return LavaAnimation(
                    color: primaryColor,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: GestureDetector(
                        onTap: () async {
                          if (!await launchUrl(
                              Uri.parse(schemes[index].schemeLink))) {
                            throw Exception('Could not launch');
                          }
                        },
                        child: GlassmorphicContainer(
                          height: MediaQuery.of(context).size.height * 0.26,
                          width: 350,
                          borderRadius: 24,
                          blur: 10,
                          alignment: Alignment.bottomCenter,
                          linearGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.1),
                              Colors.white.withOpacity(0.05)
                            ],
                            // colors: [
                            //   Theme.of(context).textTheme.titleMedium!.color!.withOpacity(0.1),
                            //   Theme.of(context).textTheme.titleMedium!.color!.withOpacity(0.05),
                            // ],
                            stops: const [0.1, 1],
                          ),
                          borderGradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .color!
                                  .withOpacity(0.3),
                              Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .color!
                                  .withOpacity(0.3),
                            ],
                          ),
                          border: 2,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ListTile(
                                  horizontalTitleGap: 0,
                                  title: Text(
                                    schemes[index].schemeName,
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    schemes[index].schemeDescription,
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.grey[700]),
                                  ),
                                  //leading: Icon(Icons.support_agent),
                                  // trailing: onDelete != null
                                  //     ? GestureDetector(
                                  //         onTap: onDelete,
                                  //         child: Icon(
                                  //           Icons.delete,
                                  //           color: Theme.of(context)
                                  //               .colorScheme
                                  //               .onSurface,
                                  //         ),
                                  //       )
                                  //     : const SizedBox.shrink(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Total Benefits"),
                                          Text(
                                            schemes[index].schemeBenefits,
                                            style: GoogleFonts.manrope(
                                              textStyle: Theme.of(context)
                                                  .textTheme
                                                  .headlineSmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text(
              "More",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          ),
          FutureBuilder(
              future: getTitles(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                return ListView.builder(
                    itemCount: 3,
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) => YoutubeWidget(
                          ytChannel: "Gaavatlya Shetkari",
                          ytLink: ytLinks[index],
                          ytThumbnail: ytThumbnails[index],
                          ytTitle: ytTitles[index],
                        ));
              }),
        ]),
      ),
    );
  }
}
