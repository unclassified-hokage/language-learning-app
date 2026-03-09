import 'package:flutter/material.dart';

/// A just-in-time learning scenario (e.g., "Coffee Shop", "Date Night")
class Scenario {
  final String id;
  final String title;
  final String subtitle;
  final String emoji;
  final String description;
  final String backgroundAsset; // illustration asset path
  final Color accentColor;
  final String cefrLevel;        // A1, A2, B1, B2
  final List<ScenarioPhrase> phrases;
  final String aiRoleplay;       // Description for AI conversation context

  const Scenario({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.emoji,
    required this.description,
    required this.backgroundAsset,
    required this.accentColor,
    required this.cefrLevel,
    required this.phrases,
    required this.aiRoleplay,
  });
}

class ScenarioPhrase {
  final String targetText;     // e.g. "Quiero un café con leche"
  final String nativeText;     // e.g. "I want a coffee with milk"
  final String pronunciation;  // e.g. "KYEH-ro oon ka-FEH kon LE-che"
  final String? culturalNote;  // Optional cultural tip

  const ScenarioPhrase({
    required this.targetText,
    required this.nativeText,
    required this.pronunciation,
    this.culturalNote,
  });
}

/// All built-in MVP scenarios
class ScenarioData {
  static final List<Scenario> all = [
    Scenario(
      id: 'coffee_shop',
      title: 'Coffee Shop',
      subtitle: 'Order your perfect drink',
      emoji: '☕',
      description: 'Order coffee, ask about the menu, and chat with the barista.',
      backgroundAsset: 'assets/images/bg_coffee.png',
      accentColor: const Color(0xFF8B4513),
      cefrLevel: 'A1',
      aiRoleplay: 'You are a friendly barista at a café. Help the customer order.',
      phrases: [
        ScenarioPhrase(
          targetText: 'Un café con leche, por favor.',
          nativeText: 'A coffee with milk, please.',
          pronunciation: 'oon ka-FEH kon LE-che, por fa-VOR',
          culturalNote: 'In Spain, a "café con leche" is half espresso, half warm milk — perfect for breakfast.',
        ),
        ScenarioPhrase(
          targetText: '¿Cuánto cuesta?',
          nativeText: 'How much does it cost?',
          pronunciation: 'KWAN-to KWES-ta',
        ),
        ScenarioPhrase(
          targetText: '¿Tiene algo sin azúcar?',
          nativeText: 'Do you have anything without sugar?',
          pronunciation: 'TYE-ne AL-go sin a-SOO-kar',
        ),
        ScenarioPhrase(
          targetText: 'Para llevar, por favor.',
          nativeText: 'To go, please.',
          pronunciation: 'PA-ra ye-VAR, por fa-VOR',
          culturalNote: 'In many Spanish cafés, sitting down costs more than standing at the bar!',
        ),
        ScenarioPhrase(
          targetText: '¡Muchas gracias!',
          nativeText: 'Thank you very much!',
          pronunciation: 'MOO-chas GRA-syas',
        ),
      ],
    ),

    Scenario(
      id: 'date_night',
      title: 'Date Night',
      subtitle: 'Make a great impression',
      emoji: '❤️',
      description: 'Compliment your date, suggest drinks, and keep the conversation going.',
      backgroundAsset: 'assets/images/bg_restaurant.png',
      accentColor: const Color(0xFFE94560),
      cefrLevel: 'A2',
      aiRoleplay: 'You are on a first date at a nice restaurant. Be warm and friendly.',
      phrases: [
        ScenarioPhrase(
          targetText: 'Estás muy guapo/guapa esta noche.',
          nativeText: 'You look very handsome/beautiful tonight.',
          pronunciation: 'es-TAS mwee GWA-po/GWA-pa ES-ta NO-che',
          culturalNote: 'Use "guapo" for men, "guapa" for women.',
        ),
        ScenarioPhrase(
          targetText: '¿Qué quieres beber?',
          nativeText: 'What do you want to drink?',
          pronunciation: 'ke KYE-res be-BER',
        ),
        ScenarioPhrase(
          targetText: 'Me alegro de estar aquí contigo.',
          nativeText: 'I\'m glad to be here with you.',
          pronunciation: 'me a-LE-gro de es-TAR a-KI kon-TI-go',
        ),
        ScenarioPhrase(
          targetText: '¿A qué te dedicas?',
          nativeText: 'What do you do for work?',
          pronunciation: 'a ke te de-DI-kas',
          culturalNote: 'A natural conversation starter — much smoother than "What\'s your job?"',
        ),
        ScenarioPhrase(
          targetText: '¿Te gustaría repetir esto?',
          nativeText: 'Would you like to do this again?',
          pronunciation: 'te gus-ta-RI-a re-pe-TIR ES-to',
        ),
      ],
    ),

    Scenario(
      id: 'restaurant',
      title: 'Restaurant',
      subtitle: 'Order food like a local',
      emoji: '🍽️',
      description: 'Order food, ask about dishes, and handle the bill.',
      backgroundAsset: 'assets/images/bg_restaurant.png',
      accentColor: const Color(0xFFFF6B35),
      cefrLevel: 'A1',
      aiRoleplay: 'You are a waiter at a traditional restaurant. Take the customer\'s order.',
      phrases: [
        ScenarioPhrase(
          targetText: 'Una mesa para dos, por favor.',
          nativeText: 'A table for two, please.',
          pronunciation: 'OO-na ME-sa PA-ra dos, por fa-VOR',
        ),
        ScenarioPhrase(
          targetText: '¿Qué me recomienda?',
          nativeText: 'What do you recommend?',
          pronunciation: 'ke me re-ko-MYEN-da',
          culturalNote: 'Asking for recommendations shows respect and often gets you the freshest dish!',
        ),
        ScenarioPhrase(
          targetText: 'Soy alérgico/a al gluten.',
          nativeText: 'I\'m allergic to gluten.',
          pronunciation: 'soy a-LER-hi-ko/a al GLOO-ten',
        ),
        ScenarioPhrase(
          targetText: 'La cuenta, por favor.',
          nativeText: 'The bill, please.',
          pronunciation: 'la KWEN-ta, por fa-VOR',
        ),
      ],
    ),

    Scenario(
      id: 'directions',
      title: 'Getting Around',
      subtitle: 'Never get lost again',
      emoji: '🚇',
      description: 'Ask for directions, take public transport, and find your way.',
      backgroundAsset: 'assets/images/bg_street.png',
      accentColor: const Color(0xFF4ECDC4),
      cefrLevel: 'A2',
      aiRoleplay: 'You are a helpful local on the street. Give directions to the tourist.',
      phrases: [
        ScenarioPhrase(
          targetText: '¿Dónde está el metro más cercano?',
          nativeText: 'Where is the nearest metro station?',
          pronunciation: 'DON-de es-TA el ME-tro mas ser-KA-no',
        ),
        ScenarioPhrase(
          targetText: '¿Cómo llego a...?',
          nativeText: 'How do I get to...?',
          pronunciation: 'KO-mo YE-go a',
        ),
        ScenarioPhrase(
          targetText: 'Gire a la derecha / izquierda.',
          nativeText: 'Turn right / left.',
          pronunciation: 'HI-re a la de-RE-cha / is-KYER-da',
        ),
        ScenarioPhrase(
          targetText: 'Está a dos minutos a pie.',
          nativeText: 'It\'s two minutes on foot.',
          pronunciation: 'es-TA a dos mi-NOO-tos a PYE',
        ),
        ScenarioPhrase(
          targetText: 'Perdona, ¿me puedes ayudar?',
          nativeText: 'Excuse me, can you help me?',
          pronunciation: 'per-DO-na, me PWE-des a-yoo-DAR',
        ),
      ],
    ),

    Scenario(
      id: 'shopping',
      title: 'Shopping',
      subtitle: 'Find what you need',
      emoji: '🛒',
      description: 'Ask for items, check sizes, and handle payment.',
      backgroundAsset: 'assets/images/bg_market.png',
      accentColor: const Color(0xFF9B59B6),
      cefrLevel: 'A1',
      aiRoleplay: 'You are a shop assistant. Help the customer find what they need.',
      phrases: [
        ScenarioPhrase(
          targetText: '¿Tiene esto en talla M?',
          nativeText: 'Do you have this in size M?',
          pronunciation: 'TYE-ne ES-to en TA-ya eme',
        ),
        ScenarioPhrase(
          targetText: '¿Puedo probármelo?',
          nativeText: 'Can I try it on?',
          pronunciation: 'PWE-do pro-BAR-me-lo',
        ),
        ScenarioPhrase(
          targetText: '¿Cuánto cuesta esto?',
          nativeText: 'How much does this cost?',
          pronunciation: 'KWAN-to KWES-ta ES-to',
        ),
        ScenarioPhrase(
          targetText: 'Me lo llevo.',
          nativeText: 'I\'ll take it.',
          pronunciation: 'me lo YE-vo',
        ),
      ],
    ),

    Scenario(
      id: 'work_meeting',
      title: 'Work Meeting',
      subtitle: 'Sound professional',
      emoji: '💼',
      description: 'Introduce yourself, discuss projects, and wrap up professionally.',
      backgroundAsset: 'assets/images/bg_office.png',
      accentColor: const Color(0xFF2C3E50),
      cefrLevel: 'B1',
      aiRoleplay: 'You are a colleague in a work meeting. Discuss a project update.',
      phrases: [
        ScenarioPhrase(
          targetText: 'Me llamo... y trabajo en...',
          nativeText: 'My name is... and I work at...',
          pronunciation: 'me YA-mo... i tra-BA-ho en',
        ),
        ScenarioPhrase(
          targetText: '¿Podría explicar eso con más detalle?',
          nativeText: 'Could you explain that in more detail?',
          pronunciation: 'po-DRI-a ex-pli-KAR E-so kon mas de-TA-ye',
        ),
        ScenarioPhrase(
          targetText: 'Estoy de acuerdo.',
          nativeText: 'I agree.',
          pronunciation: 'es-TOY de a-KWER-do',
        ),
        ScenarioPhrase(
          targetText: '¿Cuál es el siguiente paso?',
          nativeText: 'What is the next step?',
          pronunciation: 'kwal es el si-GYEN-te PA-so',
        ),
      ],
    ),
  ];

  static Scenario? findById(String id) {
    try {
      return all.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }
}
