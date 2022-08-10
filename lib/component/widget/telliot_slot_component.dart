import 'package:flutter/material.dart';
import '../../constant/telliot_colors.dart';

class TelliotSlotComponent extends StatelessWidget {
  final String _profileImage;
  final String _deviceName;
  final Color backgroundColor;
  final int historySeq;

  TelliotSlotComponent(this._deviceName, this._profileImage,
      {this.backgroundColor = TelliotColors.gray3, this.historySeq});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Image.asset(
            _profileImage,
            width: 49.8,
            height: 49.8,
          ),
          SizedBox(
            width: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width - 36 - 49.8 - 15 - 40 - 40,
            child: Text(
              _deviceName,
              style: TextStyle(
                fontSize: 18,
                color: historySeq != null
                    ? TelliotColors.white
                    : TelliotColors.gray1,
                height: 21.09 / 18,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
