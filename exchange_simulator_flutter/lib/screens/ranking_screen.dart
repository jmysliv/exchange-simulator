import 'package:exchange_simulator_flutter/bloc/ranking/ranking.dart';
import 'package:exchange_simulator_flutter/models/user_model.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:exchange_simulator_flutter/screens/error_screen.dart';
import 'package:exchange_simulator_flutter/screens/loading_screen.dart';
import 'package:exchange_simulator_flutter/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RankingScreen extends StatelessWidget {

  RankingScreen();

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RankingBloc>(
      create: (context) =>
      RankingBloc(UserRepository.getInstance())
        ..add(InitRanking()),
      child: BlocBuilder<RankingBloc, RankingState>(
        builder: (buildContext, state) {
          if (state is RankingInitial)
            return LoadingScreen("Ładowanie pieniędzy na serwer...");
          else if (state is RankingError)
            return ErrorScreen(state.message);
          else {
            List<User> users;
            if(state is RankingFetched) users = state.users;
            else users = (state as RankingLoading).oldUsers;
            return buildRankingList(buildContext, users);
          }
        },
      ),
    );
  }

  Widget buildRankingList(BuildContext context, List<User> users){
    return Scaffold(
        appBar: AppBar(
          title: Text("Ranking"),
        ),
        drawer: HomeDrawer(),
        body: RefreshIndicator(
          onRefresh: (){
            BlocProvider.of<RankingBloc>(context).add(RefreshRanking(users));
            return Future.delayed(Duration(seconds: 0));
          },
          child: BlocListener<RankingBloc, RankingState>(
            listener: (context, state){
              if (state is RankingLoading){
                Scaffold.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(
                      SnackBar(
                        content: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Ładowanie...', style: TextStyle(color: Colors.white)),
                            CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Colors.cyanAccent))
                          ],
                        ),
                        backgroundColor: Colors.black,
                        duration: Duration(seconds: 5),
                      ));
              } else{
                Scaffold.of(context).removeCurrentSnackBar();
              }
            },
            child: Container(
                child: Center(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: false,
                        physics: AlwaysScrollableScrollPhysics(),
                        itemCount: users.length,
                        itemBuilder: (context, index) {
                          return rankingCard(context, users[index], index + 1);
                        })
                )
            ),
          )
        )
    );
  }

  Widget rankingCard(BuildContext context, User user, int position){
    return  Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.black54),
        child:ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          leading: Text("$position .", style: TextStyle(color: Colors.white, fontSize: 20),),
          title: Text(
            user.name ,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            user.email ,
            style: TextStyle(color: Colors.white, fontSize: 10),
          ),
          trailing: Text("${user.amountOfPLN.round()} PLN",  style: TextStyle(color: Colors.white)),
          onTap: () {},
        ),
      ),
    );
  }
}