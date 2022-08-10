import 'package:flutter/material.dart';
import '../../component/widget/telliot_progress_indicator.dart';
import '../../constant/telliot_colors.dart';

class ValidFormField extends StatefulWidget {
  final String networkName;
  final String okLabel;
  final String cancelLabel;
  final String title;
  final String validText;
  final Color okColor;
  final Color cancelColor;
  final Future<dynamic> Function(String password) okFunction;

  ValidFormField({
    this.title = 'Wi-Fi 비밀 번호를 입력해주세요.',
    this.validText = 'Wi-Fi 비밀번호가 일치하지 않습니다.',
    this.cancelColor,
    this.cancelLabel,
    this.networkName,
    this.okColor,
    this.okFunction,
    this.okLabel,
  });

  @override
  _ValidFormFieldState createState() => _ValidFormFieldState();
}

class _ValidFormFieldState extends State<ValidFormField> {
  String _password = '';
  int statusCode = 200;
  bool _starting = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          statusCode != 200 ? widget.validText : widget.title,
          style: TextStyle(
              color:
              statusCode != 200 ? TelliotColors.red : TelliotColors.black,
              height: 17.5 / 15,
              fontSize: 15),
        ),
        Text(
          widget.networkName,
          style: TextStyle(
              color:
              statusCode != 200 ? TelliotColors.red : TelliotColors.gray1,
              height: 14.06 / 12,
              fontSize: 12),
        ),
        if (!_starting)
          Column(
            children: [
              TextFormField(
                obscureText: true,
                obscuringCharacter: '*',
                enableSuggestions: false,
                textAlignVertical: TextAlignVertical.center,
                cursorColor: TelliotColors.black,
                onChanged: (value) {
                  setState(() {
                    _password = value;
                  });
                },
                style: TextStyle(
                    color: TelliotColors.black,
                    height: 21.09 / 18,
                    fontSize: 18),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(bottom: 6),
                  focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: statusCode != 200
                            ? TelliotColors.red
                            : TelliotColors.black,
                      )),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: Feedback.wrapForTap(() {
                      Navigator.pop(context, PasswordDialogResult.cancel);
                    }, context),
                    child: Container(
                      color: Colors.transparent,
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      child: Text(
                        widget.cancelLabel ?? '취소',
                        style: TextStyle(
                          color: widget.cancelColor ?? TelliotColors.black,
                          fontSize: 12,
                          height: 14.06 / 12,
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: Feedback.wrapForTap(() async {
                      if (widget.okFunction != null) {
                        setState(() {
                          _starting = true;
                        });
                        final result = await widget.okFunction(_password);
                        setState(() {
                          statusCode = result;
                          _starting = false;
                        });

                        if (statusCode == 200) {
                          Navigator.pop(context, PasswordDialogResult.ok);
                          return;
                        }
                      }
                    }, context),
                    child: Container(
                      color: Colors.transparent,
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        widget.okLabel ?? '확인',
                        style: TextStyle(
                          color: widget.okColor ?? TelliotColors.black,
                          fontSize: 12,
                          height: 14.06 / 12,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        if (_starting)
          Center(
            child: TelliotProgressIndicator(
              width: 14,
              stroke: 4,
            ),
          ),
      ],
    );
  }
}

enum PasswordDialogResult { ok, cancel, dismissed }

class PasswordDialog extends AlertDialog {
  static Future<PasswordDialogResult> show(
      BuildContext context, {
        String networkName,
        String okLabel,
        String cancelLabel,
        Color okColor,
        Color cancelColor,
        Future<dynamic> Function(String password) okFunction,
      }) async {
    return await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => PasswordDialog(
        context,
        networkName: networkName,
        okLabel: okLabel,
        okColor: okColor,
        cancelLabel: cancelLabel,
        cancelColor: cancelColor,
        okFunction: okFunction,
      ),
    ) ??
        PasswordDialogResult.dismissed;
  }

  PasswordDialog(
      BuildContext context, {
        String networkName,
        String okLabel,
        String cancelLabel,
        Color okColor,
        Color cancelColor,
        Future<dynamic> Function(String password) okFunction,
      }) : super(
    content: ValidFormField(
      networkName: networkName,
      okLabel: okLabel,
      cancelLabel: cancelLabel,
      okColor: okColor,
      cancelColor: cancelColor,
      okFunction: okFunction,
    ),
    actionsPadding: EdgeInsets.only(left: 20),
    contentPadding:
    EdgeInsets.only(left: 20, top: 30, right: 20, bottom: 17),
  );
}
