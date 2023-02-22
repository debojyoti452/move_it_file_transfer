/*
 * *
 *  * * MIT License
 *  * *******************************************************************************************
 *  *  * Created By Debojyoti Singha
 *  *  * Copyright (c) 2023.
 *  *  * Permission is hereby granted, free of charge, to any person obtaining a copy
 *  *  * of this software and associated documentation files (the "Software"), to deal
 *  *  * in the Software without restriction, including without limitation the rights
 *  *  * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 *  *  * copies of the Software, and to permit persons to whom the Software is
 *  *  * furnished to do so, subject to the following conditions:
 *  *  *
 *  *  * The above copyright notice and this permission notice shall be included in all
 *  *  * copies or substantial portions of the Software.
 *  *  *
 *  *  * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 *  *  * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 *  *  * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 *  *  * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 *  *  * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 *  *  * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 *  *  * SOFTWARE.
 *  *  * Contact Email: support@swingtechnologies.in
 *  * ******************************************************************************************
 *
 */

import 'package:flutter/material.dart';
import 'package:move_db/move_db.dart';

class StartScreen extends StatefulWidget {
  static const id = 'START_SCREEN';

  const StartScreen({Key? key}) : super(key: key);

  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  late MoveDb moveDb;

  @override
  void initState() {
    moveDb = MoveDb()..initialize();
    super.initState();
  }

  void insertData() async {
    final data = {
      'name': 'Debojyoti Singha',
      'email': 'deb@swing.com',
    };

    final result = await moveDb.insert(data);
    debugPrint('Insert Result: $result');
  }

  void updateData() async {
    final data = {
      'name': 'Ananya Singha',
      'email': 'ananya@swing',
      'relation': 'spouse',
      'children': [
        {'name': 'Ananya Singha', 'age': 2},
        {'name': 'Ananya Singha', 'age': 2},
      ]
    };

    final result = await moveDb.update(data);
    debugPrint('Update Result: $result');
  }

  void findData() async {
    final result = await moveDb.find('email');
    debugPrint('Find Result: $result');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 10.0),
              OutlinedButton(
                  onPressed: () {
                    insertData();
                  },
                  child: const Text('Insert')),
              const SizedBox(height: 10.0),
              OutlinedButton(
                  onPressed: () {
                    updateData();
                  },
                  child: const Text('Update')),
              const SizedBox(height: 10.0),
              OutlinedButton(
                  onPressed: () {
                    findData();
                  },
                  child: const Text('Find')),
            ],
          ),
        ),
      ),
    );
  }
}
