import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

import 'package:campusflow/core/utils/dates.dart';
import 'helpers.dart';

/// Téléphone d'entrée de gamme (360 × 740 dp, cible de la séance 1) avec un
/// texte agrandi : aucun écran ne doit déborder (« RenderFlex overflowed »).
void main() {
  setUpAll(Dates.init);

  testWidgets('tous les écrans tiennent sur 360 dp avec texte à 130 %', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.3;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await pumpApp(tester);
    await seConnecter(tester);

    for (final adresse in [
      '/taches',
      '/taches/1',
      '/taches/nouvelle',
      '/cours',
      '/profil',
    ]) {
      await allerA(tester, adresse);
      expect(tester.takeException(), isNull, reason: adresse);
    }
  });
}
