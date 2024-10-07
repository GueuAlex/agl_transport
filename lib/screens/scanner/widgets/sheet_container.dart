import 'package:flutter/material.dart';

import '../../../model/agent_model.dart';
import '../../../model/visite_model.dart';
import '../../../widgets/all_sheet_header.dart';
import 'get_widget.dart';
import 'sheet_header.dart';

class SheetContainer extends StatefulWidget {
  ///::::::::::::::::::::::::::::::::::::::::::
  ///Traitement de la visite

  final VisiteModel visite;
  final AgentModel agent;
  ////////:::::::::::::////////////////
  const SheetContainer({super.key, required this.visite, required this.agent});

  @override
  State<SheetContainer> createState() => _SheetContainerState();
}

class _SheetContainerState extends State<SheetContainer> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: true,
      body: Container(
        margin: EdgeInsets.only(top: size.height - (size.height / 1.1)),
        height: size.height / 1.1,
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        child: Column(
          children: [
            const AllSheetHeader(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SheetHeader(visite: widget.visite),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: getWidget(
                        visite: widget.visite,
                        agent: widget.agent,
                        context: context,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
