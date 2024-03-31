import 'package:bytebrahmand_codeshastra/constants/colors.dart';
import 'package:bytebrahmand_codeshastra/models/equipment_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Equipments extends StatelessWidget {
  EquipmentModel equipmentModel;
  Equipments({
    super.key,
    required this.equipmentModel,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(0, 12, 8, 12),
      child: Container(
        width: MediaQuery.sizeOf(context).width * 0.45,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(4, 4, 4, 12),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 12),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    equipmentModel.image,
                    width: double.infinity,
                    height: 120,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 0, 8, 4),
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(0, 0, 12, 0),
                      child: Icon(
                        Icons.category,
                        color: Color(0xFF57636C),
                        size: 24,
                      ),
                    ),
                    Text(AppLocalizations.of(context)!.equipment,
                        style:
                            TextStyle(fontSize: 12, color: Color(0xFF57636C))),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                child: Text(
                  equipmentModel.name,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
              // Padding(
              //   padding: EdgeInsetsDirectional.fromSTEB(8, 4, 0, 0),
              //   child: Text(
              //     equipmentModel.description,
              //     style: TextStyle(
              //       fontSize: 12,
              //       color: Color(0xFF57636C),
              //     ),
              //   ),
              // ),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      equipmentModel.price,
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(secondaryColorDark),
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
