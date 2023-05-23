import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


void main()
{
    runApp(MyApp());
}


class MyApp extends StatelessWidget
{
    const MyApp({super.key});

    @override
    Widget build(BuildContext context)
    {
        return ChangeNotifierProvider(
            create: (context) => MyAppState(),
            child: MaterialApp(
                title: 'Namer App',
                theme: ThemeData(
                    useMaterial3: true,
                    colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
                ),
                home: MyHomePage(),
            ),
        );
    }
}


class MyAppState extends ChangeNotifier
{
    var current   = WordPair.random();
    var favorites = <WordPair>[];

    void getNext()
    {
        current = WordPair.random();
        notifyListeners();
    }

    void toggleFavorite() {
        if (favorites.contains(current))
        {
            favorites.remove(current);
        }
        else
        {
            favorites.add(current);
        }

        notifyListeners();
    }

    bool hasCurrent()
    {
        return favorites.contains(current);
    }
}


class MyHomePage extends StatelessWidget
{
    @override
    Widget build(BuildContext context)
    {
        var appState = context.watch<MyAppState>();
        var pair     = appState.current;

        return Scaffold(
            body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        BigCard(pair: pair),
                        SizedBox(height: 10),
                        Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                                ElevatedButton(
                                    onPressed: () {
                                        appState.toggleFavorite();
                                    },
                                    child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                            Icon(
                                                appState.hasCurrent() 
                                                ? Icons.favorite
                                                : Icons.favorite_border
                                            ),
                                            SizedBox(width: 8),
                                            Text('Like')
                                        ]
                                    ),
                                ),
                                SizedBox(width: 8),
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
}


class BigCard extends StatelessWidget
{
    final WordPair pair;
    
    const BigCard({
        super.key,
        required this.pair,
    });

    @override
    Widget build(BuildContext context)
    {
        var theme = Theme.of(context);
        var style = theme.textTheme.displayMedium!.copyWith(
            color: theme.colorScheme.onPrimary
        ); 

        return Card(
            color: theme.colorScheme.primary,
            child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                    pair.asLowerCase,
                    style: style,
                    semanticsLabel: pair.asPascalCase,
                ),
            ),
        );
    }
}