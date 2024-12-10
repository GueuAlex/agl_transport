import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:scanner/config/functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'config/app_text.dart';
import 'config/palette.dart';
import 'model/draggable_menu_model.dart';
import 'screens/delivering/deliverig_screen.dart';
import 'widgets/text_middle.dart';

class DraggableMenu extends StatefulWidget {
  const DraggableMenu({
    super.key,
  });

  @override
  State<DraggableMenu> createState() => _DraggableMenuState();
}

class _DraggableMenuState extends State<DraggableMenu> {
  final DraggableScrollableController _scrollController =
      DraggableScrollableController();

  final TextEditingController _entrepriseNameControler =
      TextEditingController();
  //
  late double screenHeight;
  bool isMaxHeight = false;
  bool _appIsVisiteModule = true;
  @override
  void initState() {
    _setIsVisiteModule();
    super.initState();
    _scrollController.addListener(() {
      // print(_scrollController.size);
      double currentExtent = _scrollController.size;
      double maxExtent = 1.0;
      setState(() {
        isMaxHeight = currentExtent >= maxExtent * 0.8;
      });
    });
  }

  void _setIsVisiteModule() async {
    final prefs = await SharedPreferences.getInstance();
    bool? resul = prefs.getBool('isVisiteModule');
    //print(resul);
    if (resul != null) {
      setState(() {
        _appIsVisiteModule = resul;
      });
    }
  }

  @override
  void dispose() {
    _entrepriseNameControler.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    //final size = MediaQuery.of(context).size;
    final contextRouteName = ModalRoute.of(context)?.settings.name as String;
    return DraggableScrollableSheet(
      initialChildSize: 0.1,
      minChildSize: 0.1,
      maxChildSize: 1,
      controller: _scrollController,
      builder: (BuildContext context, ScrollController scrollController) {
        return Container(
          margin: EdgeInsets.zero,
          decoration: BoxDecoration(
            color: !isMaxHeight
                ? Color.fromARGB(255, 236, 236, 236)
                : Colors.white,
            border: Border(
              top: BorderSide(
                width: 0.8,
                color: Palette.separatorColor,
              ),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 0.5),
                blurRadius: 5,
              ),
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                offset: const Offset(0, 0.5),
                blurRadius: 5,
              ),
            ],
          ),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            physics: BouncingScrollPhysics(),
            controller: scrollController,
            itemCount: 1,
            itemBuilder: (BuildContext context, int index) {
              return SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: !isMaxHeight
                      ? _minChild()
                      : Container(
                          width: double.infinity,
                          height: screenHeight,
                          child: _maxChild(contextRouteName),
                        ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Column _maxChild(String contextRouteName) => Column(
        children: [
          _header(color: Colors.white),
          SizedBox(height: 15),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 290,
                    //color: Colors.red,
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Nombre de colonnes
                        crossAxisSpacing: 15.0, // Espacement entre les colonnes
                        mainAxisSpacing: 15.0, // Espacement entre les lignes
                        childAspectRatio: 3 / 2, // Ratio des enfants du grid
                      ),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        final item = DraggableMenuModel.dragMenuList1[index];
                        return _menuCard(context, item, contextRouteName);
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 60,
                      vertical: 10,
                    ),
                    child: textMidleLine(text: 'ou'),
                  ),
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(10.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // Nombre de colonnes
                        crossAxisSpacing: 15.0, // Espacement entre les colonnes
                        mainAxisSpacing: 15.0, // Espacement entre les lignes
                        childAspectRatio: 3 / 2, // Ratio des enfants du grid
                      ),
                      itemCount: DraggableMenuModel.dragMenuList2.length,
                      itemBuilder: (context, index) {
                        final item = DraggableMenuModel.dragMenuList2[index];
                        return _menuCard(context, item, contextRouteName);
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      );

  GestureDetector _menuCard(
      BuildContext context, DraggableMenuModel item, String contextRouteName) {
    //// Comparer l'état du module de l'item avec celui de l'application

    bool isNotAllowRout = item.isVisiteModule != _appIsVisiteModule;
    return GestureDetector(
      onTap: () {
        /*  if (isNotAllowRout) {
          Functions.showToast(
            msg: 'Non autorisé',
            gravity: ToastGravity.TOP,
          );
          return;
        } */
        if (contextRouteName == item.route) {
          _setDraggableToMinSize();
        } else {
          if (item.route == DeliveringScreen.routeName) {
            if (item.title == 'En cours') {
              Navigator.of(context).pushNamed(
                item.route,
                arguments: true,
              );
            } else {
              Navigator.of(context).pushNamed(
                item.route,
                arguments: false,
              );
            }
          }
          Navigator.of(context).pushNamedAndRemoveUntil(
            item.route,
            ModalRoute.withName('/'),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 10),
        decoration: BoxDecoration(
          color: isNotAllowRout
              ? Colors.grey.withOpacity(0.3)
              : item.color.withOpacity(0.06),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgPicture.asset(
              item.icon,
              height: 20,
              colorFilter: ColorFilter.mode(
                isNotAllowRout ? Colors.grey : item.color,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.title,
              style: TextStyle(
                color: isNotAllowRout
                    ? Colors.grey
                    : const Color.fromARGB(255, 65, 65, 65),
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              item.subTitle,
              style: TextStyle(
                color: isNotAllowRout
                    ? Colors.grey
                    : const Color.fromARGB(255, 65, 65, 65),
                fontSize: 12,
              ),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }

  Column _minChild() {
    return Column(
      children: [
        _header(),
        Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 15,
          ),
        )
      ],
    );
  }

  Container _header({Color color = const Color.fromARGB(255, 236, 236, 236)}) {
    return Container(
      padding: const EdgeInsets.all(10),
      width: double.infinity,
      height: 45,
      decoration: BoxDecoration(
        color: color,
      ),
      child: Row(
        children: [
          SizedBox(width: 45),
          Expanded(
            child: AppText.medium(
              'APP MENU',
              textAlign: TextAlign.center,
              color: const Color.fromARGB(255, 85, 85, 85),
              //fontWeight: FontWeight.w700,
            ),
          ),
          Container(
            // padding: const EdgeInsets.all(5),
            width: 45,
            height: 45,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              /* color: Color.fromARGB(255, 217, 217, 217), */
              color: Palette.primaryColor,
            ),
            child: InkWell(
              onTap:
                  isMaxHeight ? _setDraggableToMinSize : _setDraggableToMaxSize,
              child: Center(
                child: Icon(
                  !isMaxHeight
                      ? CupertinoIcons.chevron_up
                      : CupertinoIcons.chevron_down,
                  size: 14,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _setDraggableToMinSize() {
    _scrollController.animateTo(
      0.1,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }

  void _setDraggableToMaxSize() {
    _scrollController.animateTo(
      1,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );
  }
}
