import 'package:bytebrahmand_codeshastra/models/crops_model.dart';
import 'package:bytebrahmand_codeshastra/models/equipment_model.dart';
import 'package:bytebrahmand_codeshastra/widgets/crops.dart';
import 'package:bytebrahmand_codeshastra/widgets/equipments.dart';
import 'package:bytebrahmand_codeshastra/widgets/my_tab.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';

class MarketPlacePage extends StatefulWidget {
  const MarketPlacePage({super.key});

  @override
  State<MarketPlacePage> createState() => _MarketPlacePageState();
}

class _MarketPlacePageState extends State<MarketPlacePage> {
  @override
  Widget build(BuildContext context) {
    List<EquipmentModel> equipments = [
      EquipmentModel(
          id: '1',
          name: AppLocalizations.of(context)!.tractor,
          description: '',
          image: 'assets/images/tractor.jpeg',
          category: 'Equipment',
          price: '₹ 62,000'),
      EquipmentModel(
          id: '2',
          name: AppLocalizations.of(context)!.harvester,
          description: 'Harvester for farming',
          image: 'assets/images/harvester.jpeg',
          category: 'Equipment',
          price: '₹ 4,30,000'),
      EquipmentModel(
          id: '3',
          name: AppLocalizations.of(context)!.fertilizer,
          description: 'Fertilizers for farming',
          image: 'assets/images/fertilizers.jpeg',
          category: 'Equipment',
          price: '₹ 8,000'),
      EquipmentModel(
          id: '4',
          name: AppLocalizations.of(context)!.pesticides,
          description: 'Pesticides for farming',
          image: 'assets/images/pesticides.jpeg',
          category: 'Equipment',
          price: '₹ 5,000'),
      EquipmentModel(
          id: '5',
          name: AppLocalizations.of(context)!.seeds,
          description: 'Seeder for farming',
          image: 'assets/images/seeds.jpeg',
          category: 'Equipment',
          price: '₹ 2,100'),
      EquipmentModel(
          id: '6',
          name: AppLocalizations.of(context)!.sprayer,
          description: 'Sprayer for farming',
          image: 'assets/images/sprayer.jpeg',
          category: 'Equipment',
          price: '₹ 1,500'),
    ];

    List<CropsModel> crops = [
      CropsModel(
          name: AppLocalizations.of(context)!.wheat,
          image: 'assets/images/wheat.jpeg',
          description: 'Sunita Devi',
          category: 'Crops',
          price: '₹ 200',
          quantity: '10'),
      CropsModel(
          name: AppLocalizations.of(context)!.rice,
          image: 'assets/images/rice.jpeg',
          description: 'Sanjay Kumar',
          category: 'Crops',
          price: '₹ 300',
          quantity: '20'),
      CropsModel(
          name: AppLocalizations.of(context)!.maize,
          image: 'assets/images/maize.jpeg',
          description: 'Anil Sharma',
          category: 'Crops',
          price: '₹ 150',
          quantity: '15'),
      CropsModel(
          name: AppLocalizations.of(context)!.barley,
          image: 'assets/images/barley.jpeg',
          description: 'Deepak Yadav',
          category: 'Crops',
          price: '₹ 250',
          quantity: '25'),
      CropsModel(
          name: AppLocalizations.of(context)!.soybean,
          image: 'assets/images/soyabean.jpeg',
          description: 'Priya Patel',
          category: 'Crops',
          price: '₹ 350',
          quantity: '30'),
      CropsModel(
          name: AppLocalizations.of(context)!.cotton,
          image: 'assets/images/cotton.jpeg',
          description: 'Rajesh Singh',
          category: 'Crops',
          price: '₹ 400',
          quantity: '35'),
    ];
    
    return SafeArea(
      child: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.equipment,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      // IconButton(
                      //     onPressed: () {}, icon: Icon(Icons.location_on)),
                    ],
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                        primary: false,
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: 6,
                        itemBuilder: (context, index) {
                          return Equipments(
                            equipmentModel: equipments[index],
                          );
                        }),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Crops',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      // IconButton(
                      //     onPressed: () {}, icon: Icon(Icons.location_on)),
                    ],
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  ListView.builder(
                      primary: false,
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: 6,
                      itemBuilder: (context, index) {
                        return CropWidget(
                          crops: crops[index],
                        );
                      }),
                ],
              ))),
    );
  }
}
