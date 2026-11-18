
import 'package:flutter_test/flutter_test.dart';
import 'package:mello_template/main.dart';

void main() {
  testWidgets('Mello affiche la page de bienvenue', (WidgetTester tester) async {
    await tester.pumpWidget(const MelloApp());

    expect(find.text('Bienvenue à Mello'), findsOneWidget);
    expect(find.text('Se connecter'), findsOneWidget);
    expect(find.text('Créer un compte'), findsOneWidget);
  });
}
