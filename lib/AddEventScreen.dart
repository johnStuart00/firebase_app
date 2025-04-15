// MODIFIED: Allow image to be picked and shown live in preview

import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddEventScreen extends StatefulWidget {
  final String? predictionId;
  final Map<dynamic, dynamic>? predictionData;
  final bool isEditing;

  const AddEventScreen({
    this.predictionId,
    this.predictionData,
    this.isEditing = false,
  });

  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  final _formKey = GlobalKey<FormState>();
  DateTime? _selectedDate;
  final TextEditingController _team1Controller = TextEditingController();
  final TextEditingController _team2Controller = TextEditingController();
  final TextEditingController _predictionController = TextEditingController();
  final TextEditingController _betController = TextEditingController();
  final TextEditingController _payoutController = TextEditingController();

  String? _imageUrl1;
  String? _imageUrl2;
  File? _imageFile1;
  File? _imageFile2;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.predictionData != null) {
      _team1Controller.text = widget.predictionData!['team1'] ?? '';
      _team2Controller.text = widget.predictionData!['team2'] ?? '';
      _predictionController.text = widget.predictionData!['score'] ?? '';
      _betController.text = widget.predictionData!['bet'] ?? '';
      _payoutController.text = widget.predictionData!['payout'] ?? '';
      _imageUrl1 = widget.predictionData?['image1'];
      _imageUrl2 = widget.predictionData?['image2'];

      if (widget.predictionData!['date'] != null) {
        try {
          String dateStr = widget.predictionData!['date'];
          dateStr = "$dateStr \${DateTime.now().year}";
          _selectedDate = DateFormat('dd MMM yyyy').parse(dateStr);
        } catch (e) {
          print('Date parsing error: $e');
        }
      }
    }
  }

  @override
  void dispose() {
    _team1Controller.dispose();
    _team2Controller.dispose();
    _predictionController.dispose();
    _betController.dispose();
    _payoutController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null) {
      setState(() {
        _selectedDate = pickedDate;
      });
    }
  }

  Future<void> _pickAndUploadImage(int index) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final ref = FirebaseStorage.instance.ref().child('images/$fileName');
      await ref.putFile(file);
      final url = await ref.getDownloadURL();

      setState(() {
        if (index == 1) {
          _imageFile1 = file;
          _imageUrl1 = url;
        } else {
          _imageFile2 = file;
          _imageUrl2 = url;
        }
      });
    }
  }

  Future<void> _savePredictionToFirebase() async {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Пожалуйста, выберите дату')),
      );
      return;
    }

    try {
      final predictionsRef = FirebaseDatabase.instance.ref('predictions');
      String formattedDate = DateFormat('dd MMM').format(_selectedDate!);

      Map<String, dynamic> predictionData = {
        'team1': _team1Controller.text,
        'team2': _team2Controller.text,
        'date': formattedDate,
        'score': _predictionController.text,
        'bet': _betController.text,
        'payout': _payoutController.text,
        'image1': _imageUrl1,
        'image2': _imageUrl2,
      };

      if (widget.isEditing && widget.predictionId != null) {
        await predictionsRef.child(widget.predictionId!).update(predictionData);
      } else {
        predictionData['createdAt'] = ServerValue.timestamp;
        final predictionId = predictionsRef.push().key!;
        await predictionsRef.child(predictionId).set(predictionData);
      }

      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка: $error')),
      );
    }
  }

  Widget _buildTeamImage({required int index}) {
    String? imageUrl = index == 1 ? _imageUrl1 : _imageUrl2;
    File? imageFile = index == 1 ? _imageFile1 : _imageFile2;

    return GestureDetector(
      onTap: () => _pickAndUploadImage(index),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: imageFile != null
            ? Image.file(imageFile, width: 40, height: 40, fit: BoxFit.cover)
            : imageUrl != null
                ? Image.network(imageUrl, width: 40, height: 40)
                : Image.asset('assets/tshirts/$index.png',
                    width: 40, height: 40),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF201E28),
      appBar: AppBar(
        backgroundColor: Color(0xFF201E28),
        title: Text(widget.isEditing ? 'Редактировать' : 'Добавить',
            style: TextStyle(color: Colors.white)),
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
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ElevatedButton(
                onPressed: () => _selectDate(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF2A2834),
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                child: Text(
                  _selectedDate == null
                      ? 'Выбрать дату'
                      : DateFormat('dd MMM').format(_selectedDate!),
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  _buildTeamImage(index: 1),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFF2A2834),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _team1Controller,
                        validator: (val) =>
                            val!.isEmpty ? 'Введите команду 1' : null,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Команда 1',
                          labelStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: Color(0xFF2A2834),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _team2Controller,
                        validator: (val) =>
                            val!.isEmpty ? 'Введите команду 2' : null,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: 'Команда 2',
                          labelStyle: TextStyle(color: Colors.white),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  _buildTeamImage(index: 2),
                ],
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Color(0xFF2A2834),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  controller: _predictionController,
                  validator: (val) => val!.isEmpty ? 'Введите прогноз' : null,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Прогноз',
                    labelStyle: TextStyle(color: Colors.white),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _betController,
                        validator: (val) =>
                            val!.isEmpty ? 'Ставка обязательна' : null,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                        decoration: InputDecoration(
                          hintText: 'Ставка',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: TextFormField(
                        controller: _payoutController,
                        validator: (val) =>
                            val!.isEmpty ? 'Выплата обязательна' : null,
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 24),
                        decoration: InputDecoration(
                          hintText: 'Выплата',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Spacer(),
              ElevatedButton(
                onPressed: _savePredictionToFirebase,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text(
                  widget.isEditing ? 'Сохранить' : 'Добавить',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
