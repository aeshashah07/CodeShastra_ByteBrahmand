import 'package:bytebrahmand_codeshastra/classes/language.dart';
import 'package:bytebrahmand_codeshastra/constants/colors.dart';
import 'package:bytebrahmand_codeshastra/main.dart';
import 'package:bytebrahmand_codeshastra/widgets/profile_info.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Language _selectedLanguage = Language(id: 1, name: "English", code: "en");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.profile,
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: secondaryColorDark,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 30),
              width: MediaQuery.of(context).size.width,
              child: Stack(alignment: AlignmentDirectional.center, children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[200],
                  radius: 85,
                ),
                CircleAvatar(
                  backgroundImage: AssetImage('assets/person.jpg'),
                  radius: 80,
                ),
              ]),
            ),
            Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: ProfileInfo(
                    Title: AppLocalizations.of(context)!.fullname,
                    Info: 'Raj Tiwari',
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: ProfileInfo(
                    Title: AppLocalizations.of(context)!.city,
                    Info: AppLocalizations.of(context)!.mumbai,
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.only(bottom: 15),
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: ProfileInfo(
                    Title: AppLocalizations.of(context)!.phone,
                    Info: '+91 74968 23568',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ProfileInfo(
                      Title: AppLocalizations.of(context)!.gender,
                      Info: AppLocalizations.of(context)!.male,
                    ),
                    ProfileInfo(
                      Title: AppLocalizations.of(context)!.dateOfBirth,
                      Info: '14th March 1982',
                    ),
                  ],
                ),
                SizedBox(
                  height: 15,
                ),
                Card(
                  elevation: 3,
                  shadowColor: Colors.grey[400],
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    padding: EdgeInsets.only(
                        left: 30, right: 30, top: 15, bottom: 15),
                    // width: MediaQuery.of(context).size.width*0.5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Select Language",
                          style: TextStyle(
                              color: secondaryColorDark,
                              fontSize: 12,
                              fontWeight: FontWeight.w700),
                        ),
                        DropdownButton(
                            //value: _selectedLanguage,
                            hint: Text("Select Language"),
                            items: Language.languagesList()
                                .map<DropdownMenuItem<Language>>(
                                    (e) => DropdownMenuItem(
                                          child: Text(e.name),
                                          value: e,
                                        ))
                                .toList(),
                            onChanged: (Language? language) {
                              if (language != null) {
                                MyApp.setLocale(
                                    context, Locale(language.code, ''));
                                setState(() {
                                  _selectedLanguage = language;
                                });
                              }
                            })
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
