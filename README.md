# Project Track (diop_mouhamed_l3gl_examen)

Project Track est une application mobile Flutter de gestion collaborative de projets (créée comme projet d'examen). Elle permet la création et le suivi de projets, la gestion des membres, la messagerie de tâche et les notifications.

## Stack
- **Langage :** Dart
- **Framework :** Flutter
- **Services / Backend :** Firebase (Firestore, Auth) et Supabase (initialisation dans main)
- **Librairies notables :** firebase_core, cloud_firestore, supabase_flutter, get, flutter_screenutil

## Organisation principale
```
lib/
  assets/            (images et ressources statiques)
  config/            (thèmes, constantes de configuration)
  controllers/       (GetX controllers pour l'état et la navigation)
  enum/              (énumérations utilisées dans le projet)
  models/            (modèles de données : Project, MyUser, Chat, ...)
  screens/           (écrans UI : login, users, édition, ...)
  services/          (accès aux API / DB : Firestore, Auth, etc.)
  utils/             (utilitaires : formatage, notifications, mapping)
  widgets/           (widgets réutilisables)
  main.dart          (point d'entrée de l'application)
  firebase_options.dart (config Firebase générée)
```

Comment ça s'articule : l'application démarre depuis `lib/main.dart` (initialise Supabase et Firebase), utilise GetMaterialApp pour la navigation et des controllers GetX pour gérer l'état. Les écrans se trouvent dans `lib/screens/` et consomment les services Firestore dans `lib/services/`.

## Prérequis
- Flutter (compatible avec l'entry SDK du projet, voir `pubspec.yaml`)
- Un fichier `.env` à la racine (non commité) contenant au minimum :
  - SUPABASE_URL
  - ANON_KEY

Le projet utilise aussi la configuration Firebase générée (`lib/firebase_options.dart`) — assurez-vous d'avoir les bons fichiers et paramètres pour votre projet Firebase si vous testez les services.

## Installer et lancer
1. Cloner le repo
2. Copier le fichier d'exemple `.env` (ou créer un nouveau) et remplir les clés :

```bash
cp .env.example .env   # (si vous avez un fichier d'exemple), sinon créez .env manuellement
# remplir .env avec SUPABASE_URL et ANON_KEY
```

3. Récupérer les dépendances et lancer sur un device/emulateur :

```bash
flutter pub get
flutter run -d <device>
```

4. Pour construire une release Android :

```bash
flutter build apk --release
```

## Points importants
- L'initialisation de Supabase et Firebase se fait dans `lib/main.dart` — les variables d'environnement sont requises pour Supabase.
- Les notifications locales sont configurées dans `lib/utils/notif_service.dart`.
- Les modèles principaux sont `lib/models/project.dart`, `lib/models/my_user.dart`, `lib/models/chat.dart`.

## Développement & Contribuer
- Respectez les conventions de nommage et l'architecture existante (séparation screens / services / models).
- Ouvrez une issue pour toute fonctionnalité manquante ou bug.

## Ressources utiles
- Fichiers clés à consulter : `lib/main.dart`, `pubspec.yaml`, `lib/services/firestore_db.dart` (accès DB), `lib/screens/`.
- Documentation Flutter : https://docs.flutter.dev/

## Questions fréquentes / À tester
- Où sont stockées les règles de sécurité Firestore ? (vérifier le projet Firebase lié)
- Le projet nécessite-t-il des clés supplémentaires pour certaines fonctionnalités (PDF, partage, stockage) ?
- Y a-t-il des tests automatisés à exécuter ? (répertoire `test/` présent mais contenu minimal)


