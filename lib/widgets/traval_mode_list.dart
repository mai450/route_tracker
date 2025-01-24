import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:route_tracker/models/traval_mode_model.dart';

class TravalModeList extends StatefulWidget {
  const TravalModeList({super.key, required this.onTravalModeSelected});
  final Function(String) onTravalModeSelected;

  @override
  State<TravalModeList> createState() => _TravalModeListState();
}

class _TravalModeListState extends State<TravalModeList> {
  int selectedButtonIndex = 0;
  List<TravalModeModel> travalModeList = [
    TravalModeModel(travalMode: 'DRIVE', travalIcon: FontAwesomeIcons.car),
    TravalModeModel(
        travalMode: 'WALK', travalIcon: FontAwesomeIcons.personWalking),
    // TravalModeModel(
    //     travalMode: 'MOTORCYCLE', travalIcon: FontAwesomeIcons.bicycle),
    // TravalModeModel(travalMode: 'TRANSIT', travalIcon: FontAwesomeIcons.bus),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: travalModeList.length,
        itemBuilder: (context, index) {
          return CustomTravalModeCard(
            travalModeModel: travalModeList[index],
            i: index,
            selected: selectedButtonIndex,
            onTap: () {
              setState(() {
                selectedButtonIndex = index;
              });
              widget.onTravalModeSelected(travalModeList[index].travalMode);
            },
          );
        });
  }
}

class CustomTravalModeCard extends StatelessWidget {
  const CustomTravalModeCard({
    super.key,
    required this.i,
    required this.selected,
    this.onTap,
    required this.travalModeModel,
  });
  final int i, selected;
  final void Function()? onTap;
  final TravalModeModel travalModeModel;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: IntrinsicWidth(
        child: Container(
          margin: EdgeInsets.only(top: 8, right: 10),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            shape: BoxShape.rectangle,
            color: i == selected ? Colors.grey[200] : null,
          ),
          child: Center(
            child: Row(
              children: [
                Icon(travalModeModel.travalIcon,
                    size: 18,
                    color: i == selected ? Colors.green : Colors.black),
                SizedBox(
                  width: 10,
                ),
                Text(
                  travalModeModel.travalMode,
                  style: TextStyle(
                      fontSize: 14,
                      color: i == selected ? Colors.green : Colors.black),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
