import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Startup",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: RandomWords(),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  _RandomWordsState createState() => _RandomWordsState();
}

class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _saved = Set<WordPair>();
  final _biggerFont = TextStyle(fontSize: 16);

  void _pushSaved() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final _tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );

          final _divided = ListTile.divideTiles(
            context: context,
            tiles: _tiles,
          ).toList();

          return Scaffold(
            appBar: AppBar(
              title: Text("Preferiti"),
            ),
            body: ListView(
              children: _divided,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Startup"),
        actions: [
          IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
        ],
      ),
      body: _buildSuggestions(),
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemBuilder: (context, i) {
        /**
         * Ritorna "true" se e solo se questo numero intero è dispari.
         */
        if (i.isOdd) return Divider();

        /**
         * L'espressione "~/ 2" divide i per 2 e restituisce un risultato intero.
         * Questo ci permette di calcolare il numero effettivo dei widget,
         * escludendo i divisori.
         */
        final index = i ~/ 2;

        if (index >= _suggestions.length) {
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final _alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        _alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: _alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(
          () {
            if (_alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          },
        );
      },
    );
  }
}
