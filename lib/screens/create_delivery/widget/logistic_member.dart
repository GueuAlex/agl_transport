import 'package:flutter/material.dart';

import '../../../config/app_text.dart';
import '../../../config/palette.dart';
import '../../../model/logistic_agent_model.dart';

class LogisticMember extends StatefulWidget {
  const LogisticMember(
      {super.key, required this.logisticMembers, this.shwoTrash = true});
  final List<LogisticAgent> logisticMembers;
  final bool shwoTrash;

  @override
  State<LogisticMember> createState() => _LogisticMemberState();
}

class _LogisticMemberState extends State<LogisticMember> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        widget.logisticMembers.length,
        (index) {
          final LogisticAgent _agent = widget.logisticMembers[index];
          return ListTile(
            contentPadding: EdgeInsets.all(0),
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Palette.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            title: AppText.medium(
              '${_agent.nom} ${_agent.prenoms}',
              maxLine: 1,
              textOverflow: TextOverflow.ellipsis,
            ),
            subtitle: AppText.small(
              '${_agent.numeroCni} ${_agent.typePiece}',
              color: Colors.black54,
            ),
            trailing: widget.shwoTrash
                ? InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    onTap: () {
                      widget.logisticMembers.remove(_agent);
                      setState(() {});
                    },
                    child: Icon(
                      Icons.delete,
                      color: const Color.fromARGB(255, 197, 1, 1),
                    ),
                  )
                : null,
          );
        },
      ),
    );
  }
}
