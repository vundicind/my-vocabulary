// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

void main() => runApp(MyApp());

// #docregion MyApp
class MyApp extends StatelessWidget {
  // #docregion build
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      home: RandomWords(),
    );
  }
  // #enddocregion build
}
// #enddocregion MyApp

// #docregion RWS-var
class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <TermDefinition>[];
  final _saved = Set<TermDefinition>();
  final _biggerFont = TextStyle(fontSize: 18.0);
  // #enddocregion RWS-var

  // #docregion _buildSuggestions
  Widget _buildSuggestions(List<TermDefinition> generatedTermDefinitions) {
    return ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemBuilder: /*1*/ (context, i) {
          if (i.isOdd) return Divider(); /*2*/

          final index = i ~/ 2; /*3*/
          if (index >= _suggestions.length) {
//            _suggestions.addAll(_generateTermDefinitions().take(10)); /*4*/
            _suggestions.addAll(generatedTermDefinitions); /*4*/
          }
          return _buildRow(_suggestions[index]);
        });
  }
  // #enddocregion _buildSuggestions

  // #docregion _buildRow
  Widget _buildRow(TermDefinition pair) {
    final alreadySaved = _saved.contains(pair);
    return ListTile(
      title: Text(
        pair.term,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
  // #enddocregion _buildRow

  // #docregion RWS-build
  @override
  Widget build(BuildContext context) {
    // https://stackoverflow.com/questions/49930180/flutter-render-widget-after-async-call
    return FutureBuilder<List<TermDefinition>>(
        future: _generateTermDefinitions().take(10).toList(),
        builder: (context, AsyncSnapshot<List<TermDefinition>> snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text('My Vocabulary'),
                actions: [
                  IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
                ],
              ),
              body: _buildSuggestions(snapshot.data),
            );
          } else {
            return CircularProgressIndicator();
          }
        }
    );
  }
  // #enddocregion RWS-build

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
                (TermDefinition pair) {
              return ListTile(
                title: Text(
                  pair.term + '\n'  + pair.definition + '\nfrom: ' + pair.book,
                  style: _biggerFont,
                ),
              );
            },
          );
          final divided = ListTile.divideTiles(
            context: context,
            tiles: tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text('Saved Suggestions'),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }

  // #docregion RWS-var
}
// #enddocregion RWS-var

class RandomWords extends StatefulWidget {
  @override
  State<RandomWords> createState() => _RandomWordsState();
}

// https://flutter.dev/docs/cookbook/persistence/reading-writing-files
Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

// Randomly generates nice-sounding combinations of words (compounds).
Stream<TermDefinition> _generateTermDefinitions() async* {
//  final path = await _localPath;
//  final File file = File('$path/the-dark-tower-s-king.adoc');
//  final exists = await file.exists();
//
//  if (!exists) {
//    HttpClient client = new HttpClient();
//    client.getUrl(Uri.parse("https://raw.githubusercontent.com/vundicind/readings/master/the-dark-tower-s-king.adoc"))
//        .then((HttpClientRequest request) {
//      // Optionally set up headers...
//      // Optionally write to the request object...
//      // Then call close.
//      return request.close();
//    })
//    .then((HttpClientResponse response) {
//      // Process the response.
//      response.pipe(file.openWrite());
//    });
//  }
//  yield new TermDefinition(path, path);
  //

  var fileNames = ["the-dark-tower-s-king.adoc", "the-silmarillion-jrr-tolkien.adoc", "the-war-of-the-worlds-h-g-wells.adoc"];
  var fileContents = {
    "the-dark-tower-s-king.adoc": '''= The Dark Tower V: Wolves of the Calla, by Stephen King

plow:: (American spelling) Alternative spelling of plough; plug
to plow::  a ara
harness:: hamuri
to grunt:: a grohăi, a mormăi 
to yank:: a sunci
to verge:: a se mărgini
overalls:: pantaloi lungi pentru muncă
damp:: umed, umezeală
to toss:: a se zvârcoli
deaf:: surd
to heave:: a se ridica, a ridica, a sălta
stumbeld:: impleticit, poticnit
harked:: ascultat, auzit
shin:: fluierul piciorului, tibie
whirled::  s-a invârtit, s-a rotit
to lurch::  a se clătina, a se prăvăli
sturdy:: ferm, hotărât
gasp:: icnet
clawed:: zgâriat
jerked:: smucit
buttocks:: fese, fund''',
    "the-silmarillion-jrr-tolkien.adoc": '''
= The Silmarillion, by J.R.R. Tolkine

hearkened:: 3 https://en.wiktionary.org/wiki/hearkened 

dwelling:: 3 https://en.wiktionary.org/wiki/dwelling locuință

brethren:: 3 https://en.wiktionary.org/wiki/brethren

mighty:: 3 https://en.wiktionary.org/wiki/mighty

bowed:: 3 https://en.wiktionary.org/wiki/bowed

ye:: 3 https://en.wiktionary.org/wiki/ye

kindled:: 3 https://en.wiktionary.org/wiki/kindled

forth:: 3 https://en.wiktionary.org/wiki/forth

woven:: 3 https://en.wiktionary.org/wiki/woven țesut

utterance:: 4 https://en.wiktionary.org/wiki/utterance rostire uuter - ro say

despondent:: 4 https://en.wiktionary.org/wiki/despondent descurajat From Latin despondere (“to give up, to abandon”).

faltered:: 4 https://en.wiktionary.org/wiki/faltered se clătina

attune:: 4 https://en.wiktionary.org/wiki/attune acorda

foundered:: 4 https://en.wiktionary.org/wiki/foundered scufundat From Middle French fondrer (“send to the bottom”), from Latin fundus (“bottom”)

raging:: 4 https://en.wiktionary.org/wiki/raging  in a state of rage

wrath:: 4 https://en.wiktionary.org/wiki/wrath mînie great anger (formal or old-fashioned)''',
    "the-war-of-the-worlds-h-g-wells.adoc": '''= The War of the Worlds, by H. G. Wells

eve:: 1 ajun

keenly:: 1 cu mare atenție

scrutinised:: 1 scrutat

transient:: 1 trecător

swarm:: 1 mișuna

complacency:: 1 mulțumire de sine

serene:: 1 calmi

fro:: 1

infusoria:: 1infuzorii'''
  };

  var rnd = new Random();
  var fileName = fileNames[rnd.nextInt(fileNames.length - 1)];
  String fileContent = fileContents[fileName];
  LineSplitter ls = new LineSplitter();
  List<String> lines = ls.convert(fileContent);
  while(true) {
    int line = rnd.nextInt(lines.length - 1);
    var pair = lines[line].split("::");
    if (pair.length == 2) {
      yield new TermDefinition(pair[0], pair[1], fileName);
    }
  }
}

class TermDefinition {
  final String term;
  final String definition;
  final String book;

  // Create a [TermDefinition] from the strings [term] and [definition].
  TermDefinition(this.term, this.definition, [this.book]) {
    if (term == null || definition == null) {
      throw ArgumentError("Words of TermDefinition cannot be null. "
          "Received: '$term', '$definition'");
    }
    if (term.isEmpty || definition.isEmpty) {
      throw ArgumentError("Words of TermDefinition cannot be empty. "
          "Received: '$term', '$definition'");
    }
  }
}
