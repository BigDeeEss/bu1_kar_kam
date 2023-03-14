// Import flutter packages.
import 'package:flutter/material.dart';

// Import project-specific files.
import 'package:kar_kam/base_page.dart';
import 'package:kar_kam/lib/get_it_service.dart';

/// KarKam is the root widget of this application.
///
/// KarKam is just a StatelessWidget wrapper for an instance of FutureBuilder.
/// FutureBuilder waits for the async process of loading saved app settings.
class KarKam extends StatelessWidget {
  const KarKam({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KarKam Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Material(
        child: FutureBuilder(
          future: GetItService.allReady(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              // Present a progress indicator when snapshot has no data.
              // Case where async load of app settings is still in progress.
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('Initialising Kar Kam...',),
                  SizedBox(height: 16,),
                  CircularProgressIndicator(),
                ],
              );
            } else {
              // For the 'has data' case continue with building BasePage.
              return const MaterialApp(
                title: '_KarKam',
                // BasePage invokes a generic page layout so that a similar
                // UI is presented for each page (route).
                home: BasePage(),
              );
            }
          },
        ),
      ),
    );
  }
}

