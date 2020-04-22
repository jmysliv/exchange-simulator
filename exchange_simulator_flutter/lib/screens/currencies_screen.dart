import 'package:exchange_simulator_flutter/bloc/currency/currency.dart';
import 'package:exchange_simulator_flutter/models/currency_model.dart';
import 'package:exchange_simulator_flutter/repositories/currency_repository.dart';
import 'package:exchange_simulator_flutter/repositories/user_repository.dart';
import 'package:exchange_simulator_flutter/screens/currency_details_screen.dart';
import 'package:exchange_simulator_flutter/screens/error_screen.dart';
import 'package:exchange_simulator_flutter/screens/loading_screen.dart';
import 'package:exchange_simulator_flutter/widgets/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:page_transition/page_transition.dart';

class CurrenciesScreen extends StatelessWidget {
  final CurrencyRepository _currencyRepository;

  CurrenciesScreen() :
        _currencyRepository = CurrencyRepository(UserRepository.getInstance());


  @override
  Widget build(BuildContext context) {
    return BlocProvider<CurrencyBloc>(
        create: (context) =>
        CurrencyBloc(_currencyRepository)
          ..add(InitCurrency()),
        child: BlocBuilder<CurrencyBloc, CurrencyState>(
            builder: (buildContext, state) {
              if (state is CurrencyInitial)
                return LoadingScreen("Ładowanie pieniędzy na serwer...");
              else if (state is CurrencyError)
                return ErrorScreen(state.message);
              else {
                return CurrenciesList((state as CurrencyFetched).currencies);
              }
            }
        )
    );
  }
}

class CurrenciesList extends StatefulWidget {
  final List<Currency> currencies;
  CurrenciesList(this.currencies);

  State<CurrenciesList> createState() => _CurrenciesListState();
}

class _CurrenciesListState extends State<CurrenciesList>{
  TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Currency> filteredCurrencies;

  @override
  void initState() {
    super.initState();
    filteredCurrencies = widget.currencies;
  }

  @override
  void dispose() {
   _searchController.dispose();
    super.dispose();
  }

  Widget _searchField() {
    return TextField(
      controller: _searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: "Wyszukaj walutę...",
        border: InputBorder.none,
        hintStyle: TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (searchPhrase) =>
        setState(() {
          if(searchPhrase == "") filteredCurrencies = widget.currencies;
          else filteredCurrencies = widget.currencies.where((currency) => currency.name.toLowerCase().contains(searchPhrase.toLowerCase())).toList();
        }),
    );
  }

  List<Widget> _actions() {
    if (_isSearching) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (_searchController == null ||
                _searchController.text.isEmpty) {
              Navigator.pop(context);
              return;
            }
            setState(() {
              _searchController.clear();
              filteredCurrencies = widget.currencies;
            });
          },
        ),
      ];
    }
    return <Widget>[
      IconButton(
        icon: const Icon(Icons.search),
        onPressed: (){
          ModalRoute.of(context).addLocalHistoryEntry(LocalHistoryEntry(onRemove: () =>
              setState((){
                _isSearching = false;
             })
          ));
          setState(() {
            _isSearching = true;
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
            leading: _isSearching ? const BackButton() : null,
            title: _isSearching ? _searchField() : Text("Waluty"),
            actions: _actions(),
        ),
        drawer: HomeDrawer(),
        body: Container(
            child: Center(
                child: ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: false,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemCount: filteredCurrencies.length,
                    itemBuilder: (context, index) {
                      return currencyCard(context, filteredCurrencies[index]);
                    })
            )
        )
    );
  }

  Widget currencyCard(BuildContext context, Currency currency){
    return  Card(
      elevation: 8.0,
      margin: new EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.black54),
        child:ListTile(
          contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 0.0),
          leading: Image.asset('icons/currency/${currency.symbol.toLowerCase()}.png',
                  package: 'currency_icons'),
          title: Text(
            currency.name,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),

          subtitle: Text(currency.symbol,  style: TextStyle(color: Colors.white)),
          trailing: Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.push(context, PageTransition(type: PageTransitionType.downToUp,child: CurrencyDetailScreen(currency.id)));
          },
        ),
      ),
    );
  }
}


