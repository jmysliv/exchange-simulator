import 'package:exchange_simulator_flutter/bloc/myProfile/myProfile.dart';
import 'package:exchange_simulator_flutter/models/user_model.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:exchange_simulator_flutter/screens/error_screen.dart';
import 'package:exchange_simulator_flutter/screens/loading_screen.dart';
import 'package:exchange_simulator_flutter/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyProfileScreen extends StatelessWidget{

  MyProfileScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MyProfileBloc>(
      create: (context) => MyProfileBloc(UserRepository.getInstance())..add(InitMyProfile()),
      child: BlocBuilder<MyProfileBloc, MyProfileState>(
        builder: (context, state) {
          if (state is MyProfileInitial)
            return LoadingScreen("Ładowanie pieniędzy na serwer...");
          else if (state is MyProfileError)
            return ErrorScreen(state.message);
          else {
            return buildMyProfile(context, (state as MyProfileFetched).user);
          }
        },
      ),
    );
  }

  Widget buildMyProfile(BuildContext context, User user){
    Size screenSize = MediaQuery.of(context).size;
    return Scaffold(
      drawer: HomeDrawer(),
      appBar: AppBar(
        title: Text( 'Mój Profil' ),
      ),
      body: Stack(
        children: <Widget>[
          _buildCoverImage(screenSize),
          SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: screenSize.height / 2.6),
                _buildName(user.name),
                _buildEmail(context, user.email),
                _buildStatContainer(user.amountOfPLN, 0), //to do when bet repository done, bedzie wykres zmiany stanu konta
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildCoverImage(Size screenSize) {
    return Container(
      height: screenSize.height / 2.6,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/profile.jpg'),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _buildName(String name) {
    TextStyle _nameTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 28.0,
      fontWeight: FontWeight.w700,
    );

    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
        child: Text(
          name,
          style: _nameTextStyle,
        ));
  }

  Widget _buildEmail(BuildContext context, String email) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 6.0),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(4.0),
      ),
      child: Text(
        email,
        style: TextStyle(
          fontFamily: 'Spectral',
          color: Colors.black,
          fontSize: 20.0,
          fontWeight: FontWeight.w300,
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String count) {
    TextStyle _statLabelTextStyle = TextStyle(
      fontFamily: 'Roboto',
      color: Colors.black,
      fontSize: 10.0,
      fontWeight: FontWeight.w200,
    );
    TextStyle _statCountTextStyle = TextStyle(
      color: Colors.black54,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
    );
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              count,
              style: _statCountTextStyle,
            ),
            Text(
              label,
              style: _statLabelTextStyle,
            ),
          ],
        )
    );
  }

  Widget _buildStatContainer(double amount, int numberOfBets) {
    return Container(
        height: 120.0,
        margin: EdgeInsets.only(top: 8.0),
        decoration: BoxDecoration(
          color: Color(0xFFEFF4F7),
        ),
        child: Column(
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                      flex: 1,
                      child: _buildStatItem("Liczba zakładów", "$numberOfBets"),
                    ),
                    Container(height: 54, child: VerticalDivider(color: Colors.black54, thickness: 1.0, indent: 8.0, endIndent: 1.0,)),
                    Expanded(
                      flex: 1,
                      child: _buildStatItem("Zysk/strata", "${amount - 1000}"),
                    )
                  ]
              ),
              Divider(color: Colors.black54, thickness: 1.0, indent: 8.0, endIndent: 8.0,),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _buildStatItem("Stan konta", "$amount"),
                  ]
              )
            ]
        )
    );
  }



}