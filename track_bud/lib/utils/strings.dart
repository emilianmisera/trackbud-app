// all used and non-changeable Text of app
class AppTexts {
// ONBOARDING, AUTHENTICATION, BANK ACCOUNT & BUDGET GOAL SCREENS
  // onboarding
  static String start = "Beginnen";
  static String signIn = "Anmelden";
  static String signUp = "Registrieren";
  static String onboardingTitle = "Verwalte deine Finanzen einfach und effizient an einem Ort.";
  static String onboardingDescription =
      "Tracke mühelos deine Ein-/Ausgaben, behalte deine Schulden mit Freunden im Blick und Teile deine Ausgaben in Freundesgruppen.";
  // sign in & sign up
  static String signInDescription = "Melde dich an, um deine Finanzen im Blick zu behalten.";
  static String signUpDescription = "Beginne jetzt, deine Finanzen mühelos zu verwalten.";
  static String email = "Email";
  static String hintEmail = "Email eingeben";
  static String password = "Passwort";
  static String hintPassword = "Passwort eingeben";
  static String or = "oder";
  static String signInWithGoogle = 'mit Google fortfahren';
  static String signInWithApple = 'mit Apple fortfahren';
  static String newHere = 'neu Hier? ';
  static String notNew = 'bereits einen Account? ';
  static String firstName = 'Vorname';
  static String hintFirstName = 'Vorname eingeben';
  static String confirmPassword = "Passwort bestätigen";
  static String forgotPassword = "Passwort vergessen?";
  static String resetPassword = "Passwort zurücksetzen";
  static String resetPasswordDescription = "Gib deine E-Mail Adresse an, um dein Passwort zurückzusetzen.";
  static String continueText = "Weiter";
  static String loginFailedSnackbar = "Anmeldung fehlgeschlagen";
  static String successfulLogin = "Erfolgreiche Anmeldung!";
  static String emptyLoginInput = "Bitte gib deine E-Mail und dein Passwort an.";
  static String signupEmptyField = "Bitte fülle alle Felder aus.";
  static String signupPasswordsDontMatch = "Deine Passwörter unterscheiden sich.";
  static String signupSucessful = "Bestätige die gesendete Verifizierungs E-Mail um dich anzumelden.";
  static String signupFailedSnackbar = "Registrierung fehlgeschlagen";
  // bank acc info screen & budget goal
  static String bankAccInfoHeading = "Wieviel befindet sich auf deinem Konto?";
  static String bankAccInfoDescription =
      "Gib deinen aktuellen Kontostand ein, um einen vollständigen Überblick über deine Finanzen zu erhalten.";
  static String budgetGoalHeading = "Wie hoch ist dein monatliches Budget?";
  static String budgetGoalDescription =
      "Definiere deine monatliche Ausgabengrenze, um deine Finanzen besser zu kontrollieren und Sparziele zu erreichen.";
  static String lines = "--";

//----------------------------------------------------------------------------------

// NAVIGATION PAGES
  // settings screen
  static String preferences = "Präferenzen";
  static String editProfile = "Profil bearbeiten";
  static String accAdjustments = "Konto Anpassungen";
  static String notifications = "Benachrichtigungen";
  static String abouTrackBud = "über TrackBud";
  static String logout = "Ausloggen";
  static String deleteAcc = "Konto löschen";
  static String deleteAccDescribtion = "Gib dein Passwort ein um dein Konto zu löschen.";
  //analysis page
  static String balance = 'Kontostand';
  static String history = 'Verlauf';
  static String workIncome = 'Gehalt';
  static String day = 'Tag';
  static String month = 'Monat';
  static String week = 'Woche';
  static String year = 'Jahr';
  //debts screen
  static String debts = 'Schulden';
  static String credits = 'Guthaben';
  static String showAll = 'alle Anzeigen';
  static String friends = 'Freunde';
  static String groups = 'Gruppen';
  //overview screen
  static String remainingText = 'verbleiben diesen Monat';
  static String inTotal = 'Gesamt:';
  static String toFriends = 'An Freunde:';
  static String toYou = 'An Dich:';
  static String spent = 'ausgegeben';
  static String of = 'von';

//----------------------------------------------------------------------------------

// SETTING SUBPAGES
  //profile settings
  static String currentPassword = 'aktuelles Passwort';
  static String currentPasswordHint = 'aktuelles Passwort eingeben';
  static String changePassword = 'Passwort ändern';
  static String newPassword = 'Neues Passwort eingeben';
  static String confirmNewPasswort = 'neues Passwort bestätigen';
  static String save = 'Speichern';
  static String currentEmail = 'aktuelle Email';
  static String currentEmailHint = 'aktuelle Email eingeben';
  static String changeEmail = 'Email ändern';
  static String newEmail = 'neue Email';
  static String newEmailHint = 'neue Email eingeben';
  static String changeEmailDesscribtion = 'Ändere deine Email.';
  static String changePasswordDesscribtion = 'Ändere dein Passwort.';
  //account settings screen
  static String budget = 'Budget';
  static String changeBankAcc = 'Kontostand ändern';
  static String changeBudgetGoal = 'Budgetziel ändern';
  static String changeCurrency = 'Standardwährung';
  static String appearance = 'Erscheinungsbild';
  static String systemMode = 'automatisch (System)';
  //change bankaccount
  static String changeBankAccHeading = "Ändere deinen Kontostand";
  static String changeBankAccDescribtion = "Stimmt dein angegebener Kontostand nicht mehr? Ändere ihn, um auf Kurs zu bleiben!";
  //change budgetgoal
  static String changeBudgetGoalHeading = "Ändere dein Budget Ziel";
  static String changeBudgetGoalDescribtion = "Zu sparsam oder doch eher zu optimistisch gewesen? Bearbeite dein Budgetziel.";

//----------------------------------------------------------------------------------

// ADD ITEM
  //
  static String addNewTransaction = 'Neue Transaktion';
  static String addNewFriendSplit = 'Neuer Freundesplit';
  static String addNewGroupSplit = 'Neuer Gruppensplit';
  //new transaction
  static String newTransaction = 'Neue Transaktion';
  static String expense = 'Ausgabe';
  static String income = 'Einnahme';
  static String title = 'Titel';
  static String hintTitle = 'Titel eingeben';
  static String amount = 'Betrag';
  static String date = 'Datum';
  static String categorie = 'Kategorie';
  static String recurrency = 'Wiederkehrende Transaktion';
  static String note = 'Notiz';
  static String noteHint = 'Notiz hinzufügen';
  static String addTransaction = 'Transaktion hinzufügen';
  //edit transaction page
  static String editTransaction = "Transaktion bearbeiten";
  //new split
  static String newFriendSplit = 'Split mit:';
  static String newGroupSplit = 'Gruppensplit in:';
  static String debt = 'Schulde';
  static String giveOut = 'Ausgegeben';
  static String payedBy = 'Bezahlt von';
  static String distribution = 'Verteilung';
  static String equal = 'gleichmäßig';
  static String percent = 'prozentual';
  static String byAmount = 'nach Betrag';
  static String addSplit = 'Split hinzufügen';

//----------------------------------------------------------------------------------

// DEBTS SCREEN SUBPAGES
  //your_friends_screen & your_groups_screen
  static String yourFriends = 'Deine Freunde';
  static String search = 'Suchen...';
  static String shareFriendLink = 'Link teilen';
  static String addFriend = 'Freund suchen';
  static String yourGroups = 'Deine Gruppen';
  static String createGroup = 'Gruppe erstellen';
  static String groupNameHint = 'Gruppenname';
  static String addMembers = 'Mitglieder hinzufügen';
  // friendProfile screen
  static String sameGroups = 'Gemeinsame Gruppen';
  static String payOffDebts = 'Schulden begleichen';
  // split group overview
  static String overall = 'Insgesamt';
  static String debtsOverview = 'Schuldenübersicht';
  static String transactionOverview = 'Ausgabenübersicht';
  static String perPerson = 'pro Person';
  static String addDebt = 'Rechnung hinzufügen';
  static String payOff = 'begleichen';
  static String payOffDebtsDescribtion = 'Begleiche die Bilanz.';

//----------------------------------------------------------------------------------

// CATEGORIES
  static String lebensmittel = 'Lebensmittel';
  static String drogerie = 'Drogerie';
  static String restaurants = 'Restaurant';
  static String mobility = 'Mobilität';
  static String shopping = 'Shopping';
  static String unterkunft = 'Unterkunft';
  static String entertainment = 'Entertainment';
  static String geschenke = 'Geschenk';
  static String sonstiges = 'Sonstiges';
  static String loan = 'Gehalt';

//----------------------------------------------------------------------------------

// ABOUT TRACKBUD
  static String aboutTrackBudText =
      'Wir sind ein motiviertes Team von zwei Studierenden, die es satt hatten, ständig den Überblick über unsere Finanzen zu verlieren (und ehrlich gesagt auch keine Lust auf überteuerte Premium-Apps hatten). Also dachten wir uns: Warum nicht einfach selbst eine App bauen? Gesagt, getan!\nUnsere Mission? Dein Geld im Griff zu bekommen – und das ohne ständige Panikattacken vor Monatsende. Mit unserer App kannst du ganz entspannt deine Ausgaben im Blick behalten und Schulden unter Freunden regeln (kein böses Blut mehr bei den geteilten Pizzarechnungen!). Wir wollen, dass Finanzen wieder Spaß machen… na ja, so viel Spaß, wie Finanzen eben machen können. 😅\nWenn du Fragen hast oder uns einfach sagen möchtest, wie genial wir sind – schreib uns! Wir beißen nicht, nur unsere Prüfungen tun das.';
  static String laurenzEmail = 'laurenz.ueckert@stud.uni-regensburg.de';
  static String emilianEmail = 'emilian.misera@stud.uni-regensburg.de';
  static String madeWithLove = 'Made with ❤ by Emilian & Laurenz';
  static String supportUs = 'Buy us a coffee ☕';
}
