import 'package:flutter/material.dart';

import '../../../config/app_text.dart';
import '../../../model/members_model.dart';
import 'infos_column.dart';

Widget showMemberRow(
        {required List<Member> members, required BuildContext context}) =>
    SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: members.map((member) {
          return Container(
            width: MediaQuery.of(context).size.width - 45,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 5,
                  offset: const Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: InfosColumn(
                        label: 'Nom',
                        widget: AppText.medium(member.nom),
                      ),
                    ),
                    Expanded(
                      child: InfosColumn(
                        label: 'Prénoms',
                        widget: AppText.medium(member.prenoms),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InfosColumn(
                        label: 'N° de la pièce',
                        widget: AppText.medium(member.idCard),
                      ),
                    ),
                    Expanded(
                      child: InfosColumn(
                        label: 'type de pièce',
                        widget: AppText.medium(member.typePiece),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: InfosColumn(
                        label: 'Badge',
                        widget: AppText.medium(member.badge),
                      ),
                    ),
                    Expanded(
                      child: InfosColumn(
                        label: 'Gilet',
                        widget: AppText.medium(member.gilet),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
