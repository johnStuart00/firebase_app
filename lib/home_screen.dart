import 'dart:async';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'login_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer _timer;
  int _secondsElapsed = 0;
  final int _maxSeconds = 10 * 60; // 10 minutes

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

// Start the timer
  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_secondsElapsed < _maxSeconds) {
          _secondsElapsed++;
        } else {
          _timer.cancel();
        }
      });
    });
  }

// Format time to MM:SS
  String get formattedTime {
    int minutes = _secondsElapsed ~/ 60;
    int seconds = _secondsElapsed % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('predictions');

  int _currentIndex = 0;

  final String tshirt1 = 'assets/tshirts/1.png';
  final String tshirt2 = 'assets/tshirts/2.png';
  final String tshirt3 = 'assets/tshirts/3.png';
  final String tshirt4 = 'assets/tshirts/4.png';

  final String soccerFieldIcon = 'assets/icons/soccerfield.png';
  final String casinoIcon = 'assets/icons/casino.png';
  final String searchIcon = 'assets/icons/search.png';
  final String homeIcon = 'assets/icons/home.png';
  final String click = 'assets/icons/click.png';

  int _counter = 5;

  void updateCounter(int newValue) {
    setState(() {
      _counter = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF282828),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF168163),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  'Sessie $formattedTime',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: 'SFPro',
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  AppLocalizations.of(context)!.licensee,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontFamily: 'SFPro',
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.gamblingControlBody,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'SFPro',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: _getCurrentScreen(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFE5E5E5),
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFF168163),
        unselectedItemColor: Colors.black.withOpacity(0.5),
        selectedLabelStyle: TextStyle(
          fontFamily: 'SFPro',
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'SFPro',
        ),
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          } else {
            setState(() {
              _currentIndex = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Image.asset(
              homeIcon,
              width: 40,
              height: 25,
              color: _currentIndex == 0
                  ? Color(0xFF168163)
                  : Colors.black.withOpacity(0.5),
            ),
            label: '€0,00',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              searchIcon,
              width: 40,
              height: 25,
              color: _currentIndex == 1
                  ? Color(0xFF168163)
                  : Colors.black.withOpacity(0.5),
            ),
            label: AppLocalizations.of(context)!.sport,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              soccerFieldIcon,
              width: 45,
              height: 30,
              color: _currentIndex == 2
                  ? Color(0xFF168163)
                  : Colors.black.withOpacity(0.7),
            ),
            label: AppLocalizations.of(context)!.live,
          ),
          BottomNavigationBarItem(
            icon: Stack(
              children: [
                Image.asset(
                  click,
                  width: 40,
                  height: 25,
                  color: _currentIndex == 3
                      ? Color(0xFF168163)
                      : Colors.black.withOpacity(0.5),
                ),
                if (_counter >
                    0) // Only show the counter if it's greater than 0
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 15,
                      height: 15,
                      padding: EdgeInsets.all(4),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Color(0xFF168163),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$_counter',
                        style: TextStyle(
                          fontSize: 6,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: AppLocalizations.of(context)!.myReview,
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              casinoIcon,
              color: _currentIndex == 4
                  ? Color(0xFF168163)
                  : Colors.black.withOpacity(0.5),
            ),
            label: AppLocalizations.of(context)!.casino,
          ),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  /// Switch between different screens based on current index
  Widget _getCurrentScreen() {
    switch (_currentIndex) {
      case 0:
        return _overviewScreen();
      case 1:
        return _placeholderScreen(AppLocalizations.of(context)!.myReview);
      case 2:
        return _placeholderScreen(AppLocalizations.of(context)!.live);
      case 3:
        return _placeholderScreen(AppLocalizations.of(context)!.sport);
      default:
        return _overviewScreen();
    }
  }

  /// Overview screen with predictions list (same as before)
  Widget _overviewScreen() {
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: Container(
          color: Color(0xFF282828),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                AppLocalizations.of(context)!.myReview,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'SFPro',
                ),
              ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 550,
          child: StreamBuilder(
            stream: _database.onValue,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData &&
                  !snapshot.hasError &&
                  snapshot.data.snapshot.value != null) {
                Map<dynamic, dynamic> predictions =
                    Map<dynamic, dynamic>.from(snapshot.data.snapshot.value);
                return ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    String key = predictions.keys.elementAt(index);
                    Map<dynamic, dynamic> prediction =
                        Map<dynamic, dynamic>.from(predictions[key]);

                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 5.0, right: 5.0, top: 5.0),
                      child: Container(
                        height: 530,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(51, 55, 54, 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Stack(children: [
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                width: double.infinity,
                                height: 45,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFF168163),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                ),
                                child: Text(
                                  '${AppLocalizations.of(context)!.withdraw} €${prediction['bet'] ?? '20,00'}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'SFPro',
                                  ),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, left: 22.0, right: 22.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '€20,0 ${AppLocalizations.of(context)!.doubleBet}',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 38, 190, 147),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SFPro',
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.share,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 38, 190, 147),
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        Color.fromARGB(255, 38, 190, 147),
                                    fontFamily: 'SFPro',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 22.0, right: 22.0, bottom: 22.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 40),
                                Divider(color: Colors.white24),
                                SizedBox(height: 20),
                                SizedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.radio_button_off,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                // '${prediction['team1'] ?? 'Team'} ${prediction['score'] ?? '1-0'}',
                                                'PEC Zwolle 1-0',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'SFPro',
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            prediction['odds']?.toString() ??
                                                '9.50',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'SFPro',
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 35.0),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .correctScore,
                                          style: TextStyle(
                                            color: Colors.grey[300],
                                            fontSize: 12,
                                            fontFamily: 'SFPro',
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12),

                                      // Match info

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image(
                                                      image:
                                                          AssetImage(tshirt1),
                                                      width: 20,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    // prediction['team1'] ??
                                                    //     'Team 1',
                                                    'PEC Zwolle',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'SFPro',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image(
                                                      image:
                                                          AssetImage(tshirt2),
                                                      width: 20,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    // prediction['team2'] ??
                                                    //     'Team 2',
                                                    'RKC Waahwijk',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'SFPro',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                prediction['date'] ??
                                                    'za 29 mrt',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'SFPro',
                                                ),
                                              ),
                                              Text(
                                                prediction['time'] ?? '21:00',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'SFPro',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),

                                Divider(color: Colors.white24),
                                SizedBox(height: 12),
                                SizedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.radio_button_off,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                // '${prediction['team1'] ?? 'Team'} ${prediction['score'] ?? '1-0'}',
                                                'N.E.C. 1-0',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'SFPro',
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 15.0),
                                          Text(
                                            prediction['odds']?.toString() ??
                                                '12.00',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'SFPro',
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 35.0),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .correctScore,
                                          style: TextStyle(
                                            color: Colors.grey[300],
                                            fontSize: 12,
                                            fontFamily: 'SFPro',
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12),

                                      // Match info

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image(
                                                      image:
                                                          AssetImage(tshirt3),
                                                      width: 20,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    // prediction['team1'] ??
                                                    //     'Team 1',
                                                    'N.E.C.',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'SFPro',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image(
                                                      image:
                                                          AssetImage(tshirt4),
                                                      width: 20,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    // prediction['team2'] ??
                                                    //     'Team 2',
                                                    'AZ',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'SFPro',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                prediction['date'] ??
                                                    'za 29 mrt',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'SFPro',
                                                ),
                                              ),
                                              Text(
                                                prediction['time'] ?? '21:00',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'SFPro',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 40),

                                // Bet and Payout
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.bet,
                                          style:
                                              TextStyle(color: Colors.white54),
                                        ),
                                        Text(
                                          // '€${prediction['bet'] ?? '20,00'}',
                                          '€20,00',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'SFPro',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.payout,
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontFamily: 'SFPro',
                                          ),
                                        ),
                                        Text(
                                          // 'Вывод €${prediction['payout'] ?? '2280,00'}',
                                          '€2.280,00',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'SFPro',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 35),

                                // Cash Out Button
                              ],
                            ),
                          ),
                        ]),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                      '${AppLocalizations.of(context)!.error}: ${snapshot.error}',
                      style: TextStyle(color: Colors.white)),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: SizedBox(
          height: 550,
          child: StreamBuilder(
            stream: _database.onValue,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.hasData &&
                  !snapshot.hasError &&
                  snapshot.data.snapshot.value != null) {
                Map<dynamic, dynamic> predictions =
                    Map<dynamic, dynamic>.from(snapshot.data.snapshot.value);
                return ListView.builder(
                  itemCount: predictions.length,
                  itemBuilder: (context, index) {
                    String key = predictions.keys.elementAt(index);
                    Map<dynamic, dynamic> prediction =
                        Map<dynamic, dynamic>.from(predictions[key]);

                    return Padding(
                      padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                      child: Container(
                        height: 530,
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(51, 55, 54, 1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Stack(children: [
                          Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                width: double.infinity,
                                height: 45,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Color(0xFF168163),
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(5),
                                      bottomRight: Radius.circular(5)),
                                ),
                                child: Text(
                                  '${AppLocalizations.of(context)!.withdraw} €${prediction['bet'] ?? '20,00'}',
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'SFPro',
                                  ),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, left: 22.0, right: 22.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '€20,0 ${AppLocalizations.of(context)!.doubleBet}',
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 38, 190, 147),
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'SFPro',
                                  ),
                                ),
                                Text(
                                  AppLocalizations.of(context)!.share,
                                  style: TextStyle(
                                    color: Color.fromARGB(255, 38, 190, 147),
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    decorationColor:
                                        Color.fromARGB(255, 38, 190, 147),
                                    fontFamily: 'SFPro',
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 22.0, right: 22.0, bottom: 22.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(height: 40),
                                Divider(color: Colors.white24),
                                SizedBox(height: 20),
                                SizedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.radio_button_off,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                // '${prediction['team1'] ?? 'Team'} ${prediction['score'] ?? '1-0'}',
                                                'PEC Zwolle 1-0',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'SFPro',
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 15),
                                          Text(
                                            prediction['odds']?.toString() ??
                                                '9.50',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'SFPro',
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 35.0),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .correctScore,
                                          style: TextStyle(
                                            color: Colors.grey[300],
                                            fontSize: 12,
                                            fontFamily: 'SFPro',
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12),

                                      // Match info

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image(
                                                      image:
                                                          AssetImage(tshirt1),
                                                      width: 20,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    // prediction['team1'] ??
                                                    //     'Team 1',
                                                    'PEC Zwolle',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'SFPro',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image(
                                                      image:
                                                          AssetImage(tshirt2),
                                                      width: 20,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    // prediction['team2'] ??
                                                    //     'Team 2',
                                                    'RKC Waahwijk',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'SFPro',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                prediction['date'] ??
                                                    'za 29 mrt',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'SFPro',
                                                ),
                                              ),
                                              Text(
                                                prediction['time'] ?? '21:00',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'SFPro',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 20),

                                Divider(color: Colors.white24),
                                SizedBox(height: 12),
                                SizedBox(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.radio_button_off,
                                                color: Colors.white,
                                                size: 10,
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                // '${prediction['team1'] ?? 'Team'} ${prediction['score'] ?? '1-0'}',
                                                'N.E.C. 1-0',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'SFPro',
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: 15.0),
                                          Text(
                                            prediction['odds']?.toString() ??
                                                '12.00',
                                            style: TextStyle(
                                              color: Colors.grey,
                                              fontFamily: 'SFPro',
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: 8),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 35.0),
                                        child: Text(
                                          AppLocalizations.of(context)!
                                              .correctScore,
                                          style: TextStyle(
                                            color: Colors.grey[300],
                                            fontSize: 12,
                                            fontFamily: 'SFPro',
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 12),

                                      // Match info

                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image(
                                                      image:
                                                          AssetImage(tshirt3),
                                                      width: 20,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    // prediction['team1'] ??
                                                    //     'Team 1',
                                                    'N.E.C.',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'SFPro',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              SizedBox(height: 8),
                                              Row(
                                                children: [
                                                  ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
                                                    child: Image(
                                                      image:
                                                          AssetImage(tshirt4),
                                                      width: 20,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  Text(
                                                    // prediction['team2'] ??
                                                    //     'Team 2',
                                                    'AZ',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontFamily: 'SFPro',
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                prediction['date'] ??
                                                    'za 29 mrt',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'SFPro',
                                                ),
                                              ),
                                              Text(
                                                prediction['time'] ?? '21:00',
                                                style: TextStyle(
                                                  color: Colors.grey,
                                                  fontFamily: 'SFPro',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),

                                SizedBox(height: 40),

                                // Bet and Payout
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.bet,
                                          style:
                                              TextStyle(color: Colors.white54),
                                        ),
                                        Text(
                                          // '€${prediction['bet'] ?? '20,00'}',
                                          '€20,00',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'SFPro',
                                          ),
                                        ),
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!.payout,
                                          style: TextStyle(
                                            color: Colors.white54,
                                            fontFamily: 'SFPro',
                                          ),
                                        ),
                                        Text(
                                          // 'Вывод €${prediction['payout'] ?? '2280,00'}',
                                          '€2.280,00',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 22,
                                            fontWeight: FontWeight.w500,
                                            fontFamily: 'SFPro',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: 35),

                                // Cash Out Button
                              ],
                            ),
                          ),
                        ]),
                      ),
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Center(
                  child: Text(
                      '${AppLocalizations.of(context)!.error}: ${snapshot.error}',
                      style: TextStyle(color: Colors.white)),
                );
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ),
      ),
    ]);
  }

  /// Placeholder for other tabs
  Widget _placeholderScreen(String title) {
    return Center(
      child: Text(
        '$title ',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
          fontFamily: 'SFPro',
        ),
      ),
    );
  }

  Widget _buildTeamBox(String team) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        team,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontFamily: 'SFPro',
        ),
      ),
    );
  }

  Widget _buildInfoBox(String value, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Color(0xFF343837),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontFamily: 'SFPro',
            ),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontFamily: 'SFPro',
            ),
          ),
        ],
      ),
    );
  }
}
