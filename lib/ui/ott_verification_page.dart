import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photos/services/user_service.dart';
import 'package:photos/ui/common/report_bug_popup.dart';
import 'package:photos/ui/common_elements.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';

class OTTVerificationPage extends StatefulWidget {
  final String email;
  final bool isChangeEmail;

  OTTVerificationPage(
    this.email, {
    this.isChangeEmail = false,
    Key key,
  }) : super(key: key);

  @override
  _OTTVerificationPageState createState() => _OTTVerificationPageState();
}

class _OTTVerificationPageState extends State<OTTVerificationPage> {
  final _verificationCodeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Theme.of(context).iconTheme.color,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Hero(
          tag: "sign_up",
          child: Material(
              type: MaterialType.transparency,
              child: StepProgressIndicator(
                totalSteps: 4,
                currentStep: 1,
                selectedColor: Theme.of(context).buttonColor,
                roundedEdges: Radius.circular(10),
                unselectedColor: Theme.of(context).bottomAppBarColor,
              )),
        ),
      ),
      body: _getBody(),
    );
  }

  Widget _getBody() {
    //return SingleChildScrollView(
    //child:
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 30, 20, 15),
              child: Text('Verify email',
                  style: Theme.of(context).textTheme.headline4),
            ),
            // Text(
            //   "We've sent a mail to " + widget.email,
            //   style: TextStyle(
            //     color: Theme.of(context).buttonColor,
            //     fontSize: 18,
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: RichText(
                              text: TextSpan(
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle1
                                      .copyWith(fontSize: 12),
                                  children: [
                                TextSpan(text: "We've sent a mail to "),
                                TextSpan(
                                    text: widget.email,
                                    style: TextStyle(
                                        color: Theme.of(context).buttonColor))
                              ])),
                        ),
                        Text(
                          'Please check your inbox (and spam) to complete verification',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1
                              .copyWith(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.3,
                    height: 1,
                  )
                ],
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(32),
            //   child: Text(
            //     "please check your inbox (and spam) to complete verification.",
            //     textAlign: TextAlign.center,
            //     style: TextStyle(fontSize: 12),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 15),
              child: TextFormField(
                style: Theme.of(context).textTheme.subtitle1,
                decoration: InputDecoration(
                  filled: true,
                  hintText: 'tap to enter code',
                  contentPadding: EdgeInsets.all(15),
                  border: UnderlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(6)),
                ),
                controller: _verificationCodeController,
                autofocus: false,
                autocorrect: false,
                keyboardType: TextInputType.visiblePassword,
                onChanged: (_) {
                  setState(() {});
                },
              ),
            ),
            Divider(
              thickness: 1.5,
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      //Navigator.of(context).pop();
                      UserService.instance.getOtt(context, widget.email);
                    },
                    child: Text("resend email",
                        style: Theme.of(context).textTheme.subtitle1.copyWith(
                            fontSize: 14,
                            decoration: TextDecoration
                                .underline) //hardcoded //is this okay? //functionality not added
                        ),
                  )
                ],
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Container(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              child: Text('verify'),
              onPressed: _verificationCodeController.text == null ||
                      _verificationCodeController.text.isEmpty
                  ? () {
                      print('yo'); //hardcoded
                    }
                  : () {
                      if (widget.isChangeEmail) {
                        UserService.instance.changeEmail(context, widget.email,
                            _verificationCodeController.text);
                      } else {
                        UserService.instance.verifyEmail(
                            context, _verificationCodeController.text);
                      }
                    },
            ),
          ),
        ),
      ],
    );
    // );
  }
}
