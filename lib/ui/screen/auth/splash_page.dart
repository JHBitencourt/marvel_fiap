import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marvel/ui/utils/colors.dart';

class SplashPage extends StatelessWidget {
  const SplashPage();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: MarvelColors.black,
        body: _SplashBody(),
      ),
    );
  }
}

class _SplashBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: <Widget>[
          const SizedBox(height: 12.0),
          Text(
            'Marvel FIAP',
            style: GoogleFonts.bangers().copyWith(
              color: MarvelColors.white,
              fontSize: 38,
            ),
          ),
          Expanded(
            child: Center(
              child: Image.asset(
                'assets/graphics/gifs/loading.gif',
                fit: BoxFit.fitWidth,
                // width: 240.0,
              ),
            ),
          ),
          const SizedBox(height: 12.0),
          const Text(
            'Julio Bitencourt\nMarcos Apóstolo\nRaul Ferreira',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: MarvelColors.white,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 26.0),
        ],
      ),
    );
  }
}
