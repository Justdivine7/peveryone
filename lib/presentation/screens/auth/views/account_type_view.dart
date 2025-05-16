import 'package:flutter/material.dart';
import 'package:peveryone/core/constants/ui_helpers.dart';
import 'package:peveryone/presentation/screens/chat/views/inbox_view.dart';
import 'package:peveryone/presentation/widgets/account_table.dart';
import 'package:peveryone/presentation/widgets/app_big_button.dart';

class AccountTypeView extends StatelessWidget {
  static const routeName = '/account-type';
  const AccountTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).indicatorColor,
      appBar: AppBar(
        title: Text(
          'Account Type',
          // style: TextStyle(color: Colors.black)
        ),
        centerTitle: true,
        forceMaterialTransparency: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: width(context, 0.425),
                    height: height(context, 0.2),
                    padding: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: width(context, 0.1),
                          decoration: BoxDecoration(
                            color: Theme.of(context).indicatorColor,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Image.asset('assets/images/user.png'),
                        ),
                        Text(
                          'Free Account',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            // color: Colors.black,
                            fontSize: 12,
                          ),
                        ),

                        Text(
                          "(\$0.00/month)",
                          // style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Container(
                        width: width(context, 0.425),
                        height: height(context, 0.2),

                        padding: EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          border: Border.all(
                            color: Theme.of(context).hoverColor,
                            width: 2.5,
                          ),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: width(context, 0.1),
                              decoration: BoxDecoration(
                                color: Theme.of(context).indicatorColor,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Image.asset('assets/images/crown.png'),
                            ),
                            // SizedBox(height: height(context, 0.01)),
                            Text(
                              'Anonymous Account',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                // color: Colors.black,
                              ),
                            ),

                            // SizedBox(height: height(context, 0.01)),
                            RichText(
                              text: TextSpan(
                                style: TextStyle(color: Colors.black),

                                children: [
                                  TextSpan(
                                    text: '\$2',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      // color: Colors.black,
                                    ),
                                  ),
                                  TextSpan(text: ' /Month'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: -10,
                        left: 20,
                        right: 20,
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context).hoverColor,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Text(
                              textAlign: TextAlign.center,
                              'Recommended',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: height(context, 0.03)),
              Text(
                'Choose Your Subscription',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  // color: Colors.black,
                ),
              ),
              SizedBox(height: height(context, 0.03)),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: AccountTable(),
              ),
              SizedBox(height: height(context, 0.1)),
              AppBigButton(
                label: 'Next',
                onPressed: () {
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => InboxView()));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
