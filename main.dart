import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:editable/editable.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MyAppState(),
      child: MaterialApp(
        title: 'Namer App',
        theme: ThemeData(
          useMaterial3: true,
          // 
          colorScheme: ColorScheme.dark()
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyAppState extends ChangeNotifier {
  var current = WordPair.random();

  void getNext() {
    current = WordPair.random();
    notifyListeners();
  }

  var favorites = <WordPair>[];

  void toggleFavorite() {
    if (favorites.contains(current)) {
      favorites.remove(current);
    } else {
      favorites.add(current);
    }
    notifyListeners();
  }
}

// ...

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = GeneratorPage();
      case 1:
        page = FavoritesPage();
      case 2:
        page = EssayEditPage();
      default:
        throw UnimplementedError('no widget for $selectedIndex');
    }
    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        body: Row(
          children: [
            SafeArea(
              child: NavigationRail(
                extended: constraints.maxWidth >= 600,
                destinations: [
                  NavigationRailDestination(
                    icon: Icon(Icons.home),
                    label: Text('Home'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.favorite),
                    label: Text('Favorites'),
                  ),
                  NavigationRailDestination(
                    icon: Icon(Icons.escalator),
                    label: Text('Edit Essay'),
                  ),
                ],
                selectedIndex: selectedIndex,
                onDestinationSelected: (value) {
                  setState(() {
                    selectedIndex = value;
                  });
                },
              ),
            ),
            Expanded(
              child: Container(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: page,
              ),
            ),
          ],
        ),
      );
    });
  }
}

class GeneratorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();
    var pair = appState.current;

    IconData icon;
    if (appState.favorites.contains(pair)) {
      icon = Icons.favorite;
    } else {
      icon = Icons.favorite_border;
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () {
                  appState.toggleFavorite();
                },
                icon: Icon(icon),
                label: Text('Like'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ...

@override
Widget build(BuildContext context) {
  var appState = context.watch<MyAppState>();
  var pair = appState.current;

  IconData icon;
  if (appState.favorites.contains(pair)) {
    icon = Icons.favorite;
  } else {
    icon = Icons.favorite_border;
  }

  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('A random AWESOME idea:'),
          BigCard(pair: pair),

          // added code from the tutorial
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    appState.toggleFavorite();
                  },
                  icon: Icon(icon),
                  label: Text('Like')),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  appState.getNext();
                },
                child: Text('Next'),
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class FavoritesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var appState = context.watch<MyAppState>();

    return Column(
      children: [
        //Text('test'),
        for (var pair in appState.favorites) Text(pair.asLowerCase)
      ],
    );
  }
}


class EssayEditPage extends StatefulWidget {
 @override
 // ignore: library_private_types_in_public_api
 _EssayEditPageState createState() => _EssayEditPageState();
}
class _EssayEditPageState extends State<EssayEditPage> {


//row data
List rows = [
   {"name": 'James Peter', "date":'01/08/2007',"month":'March',"status":'beginner'}, 
   {"name": 'Okon Etim', "date":'09/07/1889',"month":'January',"status":'completed'}, 
   {"name": 'Samuel Peter', "date":'11/11/2002',"month":'April',"status":'intermediate'}, 
   {"name": 'Udoh Ekong', "date":'06/3/2020',"month":'July',"status":'beginner'}, 
   {"name": 'Essien Ikpa', "date":'12/6/1996',"month":'June',"status":'completed'}, 
 ];
//Headers or Columns
List headers = [
   {"title":'Name', 'index': 1, 'key':'name'},
   {"title":'Date', 'index': 2, 'key':'date'},
   {"title":'Month', 'index': 3, 'key':'month'},
   {"title":'Status', 'index': 4, 'key':'status'},
 ];

@override
 Widget build(BuildContext context) {
   return Scaffold(
     body: Editable(
       columns: headers, 
       rows: rows,
       showCreateButton: true,
       tdStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
       showSaveIcon: false,
      //  borderColor: Colors.grey.shade300,
      borderColor: Theme.of(context).colorScheme.primaryContainer,
        onSubmitted: (value){ //new line
            print(value); //you can grab this data to store anywhere
        }
      ),
    );
 }
}


class BigCard extends StatelessWidget {
  const BigCard({
    super.key,
    required this.pair,
  });

  final WordPair pair;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final style = theme.textTheme.displayMedium!
        .copyWith(color: theme.colorScheme.onPrimary);
    return Card(
      color: theme.colorScheme.primary,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(pair.asLowerCase, style: style),
      ),
    );
  }
}
