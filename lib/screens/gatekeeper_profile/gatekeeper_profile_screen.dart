import 'package:double_back_to_close_app/double_back_to_close_app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../config/app_text.dart';
import '../../config/palette.dart';
import '../../model/agent_model.dart';
import '../../model/localisation_model.dart';
import '../../widgets/copy_rigtht.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/gate_keeper_tag.dart';
import '../auth/login/login.dart';
import '../scanner/widgets/infos_column.dart';

class GatekeeperProfileScreen extends StatefulWidget {
  static const routeName = 'gatekeeperProfileScreen';
  const GatekeeperProfileScreen({super.key});

  @override
  _GatekeeperProfileScreenState createState() =>
      _GatekeeperProfileScreenState();
}

class _GatekeeperProfileScreenState extends State<GatekeeperProfileScreen> {
  AgentModel? _agent;

  @override
  void initState() {
    super.initState();
    _fetchAgent();
  }

  Future<void> _fetchAgent() async {
    final userMap = await getUser();
    if (userMap != null) {
      setState(() {
        _agent = AgentModel(
          id: userMap['id'],
          name: userMap['name'],
          email: userMap['email'],
          telephone: userMap['telephone'],
          actif: userMap['actif'] == 1,
          matricule: userMap['matricule'],
          localisationId: userMap['localisation_id'],
          avatar: userMap['avatar'],
          localisation: LocalisationModel(
            id: userMap['localisation_id'],
            siteId: userMap['localisation_id'],
            libelle: userMap['localisation_name'],
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: _agent == null
          ? Center(child: CircularProgressIndicator())
          : DoubleBackToCloseApp(
              snackBar: SnackBar(
                content: AppText.medium(
                  'Double clic pour quitter',
                  color: Colors.grey,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    height: 250,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border(
                        bottom: BorderSide(
                          width: 0.8,
                          color: Palette.separatorColor,
                        ),
                      ),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            width: double.infinity,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.amber,
                              image: DecorationImage(
                                image:
                                    AssetImage('assets/images/agl-banner.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            child: Container(
                              width: double.infinity,
                              height: 120,
                              color: Colors.black.withOpacity(0.15),
                            ),
                          ),
                        ),
                        Positioned(
                          left: 10,
                          child: Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              color: Palette.separatorColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                width: 4,
                                color: Colors.white,
                              ),
                              image: DecorationImage(
                                image: NetworkImage(
                                    'http://194.163.136.227:8079/images/${_agent!.avatar}'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 110,
                          right: 0,
                          child: Container(
                            width: MediaQuery.of(context).size.width - 100,
                            height: 150,
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      tagContainer(),
                                      tagContainer(
                                        icon: CupertinoIcons.arrow_up,
                                        text: 'Entrée G',
                                        color: Color.fromARGB(255, 157, 3, 121),
                                      ),
                                      tagContainer(
                                        icon: CupertinoIcons.arrow_up,
                                        text: 'Team Leader',
                                        color: Color.fromARGB(255, 2, 110, 149),
                                        withIcon: false,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 5),
                                AppText.large(
                                  _agent!.name,
                                  maxLine: 1,
                                  textOverflow: TextOverflow.ellipsis,
                                  color: Color.fromARGB(255, 33, 33, 33),
                                ),
                                AppText.small(
                                  'Agent & Team Leader @ AGL ${_agent!.localisation.libelle}',
                                ),
                                SizedBox(height: 5),
                                AppText.small(
                                  'numéro matricule - ${_agent!.matricule}',
                                  fontWeight: FontWeight.w500,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      color: Colors.white,
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText.medium('Général'),
                            SizedBox(height: 15),
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.8,
                                  color: Palette.separatorColor,
                                ),
                                borderRadius: BorderRadius.circular(5),
                              ),
                              height: 80,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: InfosColumn(
                                            label: 'Nom',
                                            widget: Expanded(
                                              child: AppText.medium(
                                                  _agent!.name.split(' ')[0]),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          child: InfosColumn(
                                            label: 'Prénoms',
                                            widget: Expanded(
                                              child: AppText.medium(
                                                  _agent!.name.split(' ')[1]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border(
                                          top: BorderSide(
                                            width: 0.8,
                                            color: Palette.separatorColor,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              color: Color.fromARGB(
                                                  255, 215, 214, 214),
                                              borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(5),
                                              ),
                                            ),
                                            child: Icon(
                                              CupertinoIcons.envelope_fill,
                                              color: Color.fromARGB(
                                                  255, 57, 57, 57),
                                            ),
                                          ),
                                          SizedBox(width: 5),
                                          Expanded(
                                            child:
                                                AppText.medium(_agent!.email),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Palette.separatorColor,
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 215, 214, 214),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        topLeft: Radius.circular(5),
                                      ),
                                    ),
                                    child: Icon(
                                      CupertinoIcons.phone_fill,
                                      color: Color.fromARGB(255, 65, 65, 65),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: AppText.medium(_agent!.telephone),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Palette.separatorColor,
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.only(top: 2),
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 215, 214, 214),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        topLeft: Radius.circular(5),
                                      ),
                                    ),
                                    child: Center(
                                      child: AppText.medium(
                                        'ID',
                                        fontWeight: FontWeight.w800,
                                        fontSize: 19,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: AppText.medium(_agent!.matricule),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Container(
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: Palette.separatorColor,
                                  width: 0.8,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                      padding: const EdgeInsets.only(top: 2),
                                      width: 40,
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 215, 214, 214),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(5),
                                          topLeft: Radius.circular(5),
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.location_on,
                                        color: Color.fromARGB(255, 65, 65, 65),
                                      )),
                                  SizedBox(width: 5),
                                  Expanded(
                                    child: AppText.medium(
                                        _agent!.localisation.libelle),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 100),
                            CustomButton(
                              color: Colors.red.withOpacity(0.03),
                              textColor: Colors.red,
                              width: double.infinity,
                              height: 35,
                              radius: 5,
                              text: 'Se décoordonner',
                              onPress: () => logout(context),
                            ),
                            SizedBox(height: 30),
                            SizedBox(
                              width: double.infinity,
                              child: CopyRight(),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

Future<Map<String, dynamic>?> getUser() async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'user_database.db');

  final database = await openDatabase(path);

  final List<Map<String, dynamic>> maps = await database.query('user');
  if (maps.isNotEmpty) {
    return maps.first;
  } else {
    return null;
  }
}

Future<void> logout(BuildContext context) async {
  final databasePath = await getDatabasesPath();
  final path = join(databasePath, 'user_database.db');

  final database = await openDatabase(path);

  await database.delete('user');

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.remove('isRemember');

  // Navigate to login page
  Navigator.pushNamedAndRemoveUntil(
    context,
    LoginScreen.routeName,
    (route) => false,
  );
}
