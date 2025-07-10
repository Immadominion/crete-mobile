// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'Crete';

  @override
  String get welcome => 'Bienvenue sur Crete';

  @override
  String get loading => 'Chargement...';

  @override
  String get error => 'Erreur';

  @override
  String get retry => 'Réessayer';

  @override
  String get cancel => 'Annuler';

  @override
  String get ok => 'OK';

  @override
  String get close => 'Fermer';

  @override
  String get save => 'Enregistrer';

  @override
  String get delete => 'Supprimer';

  @override
  String get edit => 'Modifier';

  @override
  String get add => 'Ajouter';

  @override
  String get search => 'Rechercher';

  @override
  String get settings => 'Paramètres';

  @override
  String get profile => 'Profil';

  @override
  String get wallet => 'Portefeuille';

  @override
  String get transactions => 'Transactions';

  @override
  String get balance => 'Solde';

  @override
  String get send => 'Envoyer';

  @override
  String get receive => 'Recevoir';

  @override
  String get amount => 'Montant';

  @override
  String get address => 'Adresse';

  @override
  String get confirm => 'Confirmer';

  @override
  String get transaction => 'Transaction';

  @override
  String get pending => 'En attente';

  @override
  String get completed => 'Terminé';

  @override
  String get failed => 'Échec';

  @override
  String get networkError =>
      'Erreur de connexion réseau. Vérifiez votre connexion internet et réessayez.';

  @override
  String get invalidAddress => 'Format d\'adresse invalide';

  @override
  String get insufficientBalance => 'Solde insuffisant';

  @override
  String get transactionFailed => 'La transaction a échoué. Réessayez.';

  @override
  String get connectWallet => 'Connecter le Portefeuille';

  @override
  String get disconnectWallet => 'Déconnecter le Portefeuille';

  @override
  String get walletConnected => 'Portefeuille Connecté';

  @override
  String get walletDisconnected => 'Portefeuille Déconnecté';

  @override
  String get noTransactions => 'Aucune transaction trouvée';

  @override
  String get refresh => 'Actualiser';

  @override
  String get copy => 'Copier';

  @override
  String get copied => 'Copié dans le presse-papiers';

  @override
  String get share => 'Partager';

  @override
  String get back => 'Retour';

  @override
  String get next => 'Suivant';

  @override
  String get previous => 'Précédent';

  @override
  String get done => 'Terminé';

  @override
  String get skip => 'Ignorer';

  @override
  String get continueButton => 'Continuer';

  @override
  String get language => 'Langue';

  @override
  String get theme => 'Thème';

  @override
  String get notifications => 'Notifications';

  @override
  String get security => 'Sécurité';

  @override
  String get about => 'À propos';

  @override
  String get version => 'Version';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get signIn => 'Se connecter';

  @override
  String get signUp => 'S\'inscrire';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mot de passe';

  @override
  String get confirmPassword => 'Confirmer le mot de passe';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get resetPassword => 'Réinitialiser le mot de passe';

  @override
  String get enterEmail => 'Entrez votre adresse email';

  @override
  String get enterPassword => 'Entrez votre mot de passe';

  @override
  String get invalidEmail => 'Veuillez entrer une adresse email valide';

  @override
  String get passwordTooShort =>
      'Le mot de passe doit contenir au moins 8 caractères';

  @override
  String get passwordMismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get accountCreated => 'Compte créé avec succès';

  @override
  String get welcomeBack => 'Bon retour !';

  @override
  String get solanaNetwork => 'Réseau Solana';

  @override
  String get mainnet => 'Réseau Principal';

  @override
  String get devnet => 'Réseau de Développement';

  @override
  String get testnet => 'Réseau de Test';

  @override
  String get blinks => 'Blinks';

  @override
  String get actionRequired => 'Action Requise';

  @override
  String get processingTransaction => 'Traitement de la transaction...';

  @override
  String get transactionSuccess => 'Transaction terminée avec succès';

  @override
  String get configurationError => 'Erreur de Configuration';

  @override
  String get connectionTimeout => 'Délai de connexion dépassé. Réessayez.';

  @override
  String get unknownError => 'Une erreur inconnue s\'est produite. Réessayez.';

  @override
  String get noInternetConnection =>
      'Pas de connexion internet. Vérifiez vos paramètres réseau.';

  @override
  String get serverError => 'Erreur du serveur. Réessayez plus tard.';

  @override
  String get maintenance =>
      'L\'application est en maintenance. Réessayez plus tard.';

  @override
  String get updateRequired =>
      'Mise à jour de l\'application requise. Mettez à jour pour continuer.';

  @override
  String get updateAvailable =>
      'Une nouvelle version est disponible. Mettre à jour maintenant ?';

  @override
  String get later => 'Plus tard';

  @override
  String get update => 'Mettre à jour';

  @override
  String get justNow => 'À l\'instant';

  @override
  String minuteAgo(int count) {
    return 'il y a $count minute';
  }

  @override
  String minutesAgo(int count) {
    return 'il y a $count minutes';
  }

  @override
  String hourAgo(int count) {
    return 'il y a $count heure';
  }

  @override
  String hoursAgo(int count) {
    return 'il y a $count heures';
  }

  @override
  String dayAgo(int count) {
    return 'il y a $count jour';
  }

  @override
  String daysAgo(int count) {
    return 'il y a $count jours';
  }

  @override
  String weekAgo(int count) {
    return 'il y a $count semaine';
  }

  @override
  String weeksAgo(int count) {
    return 'il y a $count semaines';
  }

  @override
  String monthAgo(int count) {
    return 'il y a $count mois';
  }

  @override
  String monthsAgo(int count) {
    return 'il y a $count mois';
  }

  @override
  String yearAgo(int count) {
    return 'il y a $count an';
  }

  @override
  String yearsAgo(int count) {
    return 'il y a $count ans';
  }

  @override
  String get yesterday => 'Hier';

  @override
  String get today => 'Aujourd\'hui';

  @override
  String get tomorrow => 'Demain';

  @override
  String get ended => 'Terminé';

  @override
  String get remaining => 'restant';

  @override
  String get lessThanMinute => 'Moins de 1m restant';
}
