import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'AddEventScreen.dart';

class AdminPanelScreen extends StatefulWidget {
  final Function(Locale)? setLocale;
  const AdminPanelScreen({super.key, this.setLocale});

  @override
  AdminPanelScreenState createState() => AdminPanelScreenState();
}

class AdminPanelScreenState extends State<AdminPanelScreen> {
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref().child('predictions');

  final String tshirt1 = 'assets/tshirts/1.png';
  final String tshirt2 = 'assets/tshirts/2.png';
  final String tshirt3 = 'assets/tshirts/3.png';
  final String tshirt4 = 'assets/tshirts/4.png';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF201E28),
      appBar: AppBar(
        backgroundColor: Color(0xFF201E28),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(AppLocalizations.of(context)!.adminPage,
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'SFPro',
                )),
            GestureDetector(
              onTap: () {
                _showLanguageDialog(context);
              },
              child: Text(AppLocalizations.of(context)!.language,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'SFPro',
                  )),
            ),
          ],
        ),
        leading: Container(
          margin: EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
            padding: EdgeInsets.zero,
            iconSize: 18,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
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
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Color(0xFF2A2834),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              // Команды и дата
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        prediction['team1'] ?? 'Team 1',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image(
                                        image: AssetImage(tshirt1),
                                        width: 20,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      prediction['date'] ?? '21 Sep',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'SFPro',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(8),
                                      child: Image(
                                        image: AssetImage(tshirt2),
                                        width: 20,
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        prediction['team2'] ?? 'Team 2',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontFamily: 'SFPro',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Ставка, прогноз и выплаты
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF3C3A44),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            '${prediction['bet'] ?? '20'}\$',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'SFPro',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            AppLocalizations.of(context)!.bet,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'SFPro',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF3C3A44),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            prediction['score'] ?? '3-1',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'SFPro',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .prediction,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'SFPro',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        color: Color(0xFF3C3A44),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            '${prediction['payout'] ?? '200'}\$',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'SFPro',
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 4),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .payouts,
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontFamily: 'SFPro',
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Кнопки редактирования и удаления
                              Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AddEventScreen(
                                              isEditing: true,
                                              predictionId: key,
                                              predictionData: prediction,
                                            ),
                                          ),
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        foregroundColor:
                                            Colors.white, // Белый текст
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        minimumSize: Size(140, 40),
                                      ),
                                      child: Text(
                                          AppLocalizations.of(context)!.edit),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  Color(0xFF2A2834),
                                              title: Text(
                                                  AppLocalizations.of(context)!
                                                      .confirm,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'SFPro',
                                                  )),
                                              content: Text(
                                                  AppLocalizations.of(context)!
                                                      .confirmDeletePrediction,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: 'SFPro',
                                                  )),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(),
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .cancel,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: 'SFPro',
                                                      )),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    _database
                                                        .child(key)
                                                        .remove();
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: Text(
                                                      AppLocalizations.of(
                                                              context)!
                                                          .delete,
                                                      style: TextStyle(
                                                        color: Colors.red,
                                                        fontFamily: 'SFPro',
                                                      )),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        foregroundColor:
                                            Colors.white, // Белый текст
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                        ),
                                        minimumSize: Size(140, 40),
                                      ),
                                      child: Text(
                                        AppLocalizations.of(context)!.delete,
                                        style: TextStyle(
                                          fontFamily: 'SFPro',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                      child: Text('Ошибка: ${snapshot.error}',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'SFPro',
                          )));
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),

          // Кнопка добавления
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 3,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddEventScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(Icons.home),
                          Text('€0,00', style: TextStyle(fontSize: 16))
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width / 2,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddEventScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        minimumSize: Size(double.infinity, 50),
                      ),
                      child: Text(AppLocalizations.of(context)!.add,
                          style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'SFPro',
                          )),
                    ),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Color(0xFF2A2834),
          title: Text(AppLocalizations.of(context)!.language,
              style: TextStyle(color: Colors.white)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('English',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SFPro',
                    )),
                onTap: () {
                  widget.setLocale?.call(Locale('en'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Русский',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SFPro',
                    )),
                onTap: () {
                  widget.setLocale?.call(Locale('ru'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Ispanis',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SFPro',
                    )),
                onTap: () {
                  widget.setLocale?.call(Locale('es'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Germany',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SFPro',
                    )),
                onTap: () {
                  widget.setLocale?.call(Locale('de'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Italian',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SFPro',
                    )),
                onTap: () {
                  widget.setLocale?.call(Locale('it'));
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                title: Text('Dutch',
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'SFPro',
                    )),
                onTap: () {
                  widget.setLocale?.call(Locale('nl'));
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
