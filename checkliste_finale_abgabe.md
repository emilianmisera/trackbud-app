# AoP Checkliste Abschlussprojekt

---

Die folgende Checkliste soll euch dabei helfen, selbstständig zu überprüfen, ob an alles wichtige gedacht wurde. So erwarten euch auch bei der Bewertung keine unerwarteten Überraschungen. Hakt die einzelnen Punkte gerne auch ab `- [ ]` -> `- [x]`. Das hilft uns ungemein bei der Bewertung. Achtet auch auf letzte Hinweise zur Abgabe auf Discord!

## Veröffentlichung der App für alle Kursteilnehmer:innen

**Hinweis**: Diese Angabe ist optional. Euer Code ist euer geistiges Eigentum und wird von uns nur zur Bewertung benutzt. Was ihr im Anschluss damit macht, ist eure freie Entscheidung.

- [ ] Quellcode und APK-Datei darf für alle Kursteilnehmer:innen verfügbar gemacht werden
- [x] APK-Datei darf für alle Kursteilnehmer:innen verfügbar gemacht werden
- [ ] Wir möchten nicht, dass Quellcode oder APK-Datei für alle Kursteilnehmer:innen verfügbar gemacht werden

## Umsetzung der besprochenen Anforderungen

- [x] Alle in `anforderungen.md` besprochenen Anforderungen wurden umgesetzt. Mögliche Änderungen an den Anforderungen wurden mit Vitus besprochen und finden sich im Dokument wider.

## Codequalität und Struktur

- [x] Code ist modular aufgebaut
  - [x] Einzelne Klassen sind in einzelne Dart-Dateien aufgeteilt
  - [x] Zur besseren Übersicht sind die Dart-Dateien im `lib`-Ordner in Unterordner sortiert (z.B. `widgets`, `screens`, etc.) (siehe Vorlesung 12, Folie 7)
- [x] Im Code finden sich keine Magic Numbers mehr. Stattdessen stehen diese als Konstanten im Code. Es bietet sich an, Konstanten in gesonderte Dateien auszulagern (siehe Vorlesung 12, Folie 9).
- [x] Widget Trees sind nicht zu unübersichtlich. Komplexere Programmlogik innerhalb eines Widget Trees ist in eigene Methoden ausgelagert
- [x] Die bekannten Konventionen zur Benennung von Dateien, Klassen, Methoden, Variablen, Konstanten, etc. wurden eingehalten
- [x] Der Code ist sinnvoll und in ausreichendem Umfang kommentiert (Kommentare erklären den Zweck des Codes und helfen beim besseren Verständnis). Kommentare sind einheitlich auf englisch (oder deutsch) verfasst.
- [-] Toter Code und Unused Imports wurden aus allen Dateien entfernt
- [x] Warnungen im Code (unterringelte Stellen in VS Code) wurden vor der finalen Abgabe vollständig behoben

## Permissions

- [x] Nötige Permissions werden korrekt abgefragt
- [x] Die App frägt nur Permissions für Funktionalitäten ab, die auch wirklich benötigt werden
- [x] Bei fehlenden Permissions funktioniert die App entweder trotzdem, oder der User wird darauf hingewiesen, dass eine Nutzung nur möglich ist, wenn die entsprechende Permission gewährt wird

## Error Handling

- [x] Mögliche Fehler werden mit try-catch-Blöcken abgefangen
- [x] Dem User werden klar und leicht verständliche Fehlermeldungen angezeigt (also z.B. "Es konnte keine Verbindung zum Internet hergestellt werden" statt "Network Error")
- [x] Die App lässt sich ohne Probleme auf einem Android-Emulator oder einem physischen Android-Smartphone starten (Das ist für die Bewertung wichtig. Bei Fragen bitte an Vitus wenden)
- [x] Die App stürzt zu keinem Zeitpunkt während der Nutzung ab oder friert ein
- [x] Bei fehlender Internetverbindung (kann durch Einschalten des Flugmodus getestet werden) funktioniert die App weiterhin, oder der User wird auf das Problem hingewiesen
- [x] Texteingabefelder wurden auf unerwartete Eingaben getestet
  - [x] Es gibt kein unerwartetes Verhalten, wenn eine TextField leer gelassen wird
  - [x] Es gibt kein unerwartetes Verhalten, wenn ein super langer Text, Emojis oder andere unerwartete Zeichen eingefügt werden
- [x] async und await finden sich an nötigen Stellen im Code (v.a. bei allen Operationen, die nicht immer und ausnahmslos in Sekundenbruchteilen abgeschlossen sind; GET Requests, Datenbank Operationen, …)

## User Interface und User Experience

- [x] Falls Daten im UI nicht sofort verfügbar sind (z.B. wenn diese erst aus dem Internet abgerufen werden müssen), wird im UI ein Ladeindikator (z.B. ein `CircularProgressIndicator`) angezeigt
- [x] Die App enthält keine UI-Elemente, die nicht funktionieren (z.B. keine Buttons, die nichts tun).
- [x] Alle in der App angezeigten Widgets und Screens sind ansprechend formatiert. Keine groben Design-Schnitzer (z.B: Text "klebt" nicht am Rand, Text viel zu klein, Kontrast zwischen Text und Hintergrund zu gering)
- [x] Navigation innerhalb der App sinnvoll gestaltet, z.B.:
  - [x] Buttons machen das, was man von ihnen erwartet
  - [x] Navigation von A nach B innerhalb der App sinnvoll durchdacht
  - [x] Falls ein Login möglich ist, muss auch ein Logout möglich sein, etc.
- [x] Die Anwendung zeigt keine Overflow-Warnungen an (orange Warnstreifen)

## Feinschliff

- [x] Die App hat einen eigenen Namen, der auch in der App-Übersicht angezeigt wird (siehe Vorlesung 12, Folie 12)
- [x] Die App hat einen passenden Icon, der auch in der App-Übersicht angezeigt wird (siehe Vorlesung 12, Folie 13)
- [x] Nicht direkt bewertungsrelevant, aber sinnvoll: App-Testing: Freund:innen, Eltern, Großeltern, etc. die App ausprobieren lassen, ohne dass ihr ihnen viel erklärt (eine App soll keine Anleitung brauchen, sondern selbsterklärend sein!)

## Quellenangaben

- [x] Alle aus fremden Quellen übernommene Codeausschnitte sind klar gekennzeichnet (siehe im Kurs besprochene Regeln, insbesondere für Tools wie `ChatGPT`).
- [x] Quellenangeben für nicht selbst erstellte Assets (Bilder, Audio, etc.) sind an passender Stelle (z.B. in der Readme im Repository oder auf eigenem Impressum-Screen in der App) angegeben

## Git & GitHub

- [x] Die finale Version der App befindet sich auf dem main-Branch im Repository
- [x] Die APK-Datei ist im Remote-Repository auf GitHub zu finden (bestenfalls im Parent-Ordner, dort wo auch die Readme Datei liegt) und spiegelt die finale Version des Codes wider
- [x] Auf dem main-Branch finden sich keine weiteren Testprojekte oder sonstiger Code, der nicht direkt zum Abschlussprojekt gehört
- [x] Die Programmierarbeit aller Projektmitglieder wurde durch regelmäßige Commits mit aussagekräftigen Commit-Messages dokumentiert
- [x] Features wurden stets auf eigenen Branches implementiert
- [x] Pull Requests wurden korrekt gestellt und von den eigenen Teammitgliedern bearbeitet
- [x] Die Aufgabenverteilung im Team war fair. Alle Teammitglieder haben in etwa gleich viel zum Endergebnis beigetragen

## Projektdokumentation und Readme

- [x] Im Repository auf GitHub findet sich eine Readme-Datei (siehe Vorlesung 13, Folie 29f). Diese enthält:
  - [x] Name der App
  - [x] Motivation
  - [x] Beschreibung der App
  - [x] Screenshots aller Screens in der App (Screenshots werden auch in der gerenderten Version der Datei auf GitHub korrekt angezeigt)
  - [x] Kurze Beschreibung jedes Screens
  - [x] Aufgabenverteilung im Team (Wer hat an welchen Features mitgearbeitet? Wer war für was haupt-/mitverantwortlich, …)
  - [ ] Optional (da ich vergessen habe das in der Vorlesung zu erwähnen), aber sinnvoll:
    - [ ] Bei Nutzung von Diensten wie Firebase: Kurze Beschreibung, welche Features genutzt wurden, Überblick über die Struktur der Datenbank; Security Rules mit in der Readme Datei dokumentieren
    - [ ] Übersicht über verwendete APIs, Sensoren, Datenbanken, etc.

## Video der App

**Hinweis**: Eventuell ist die Videodatei zu groß für GitHub. In diesem Fall kann das Video z.B. in eine Cloud (Google Drive, Dropbox, etc.) oder auf YouTube hochgeladen und in der Readme verlinkt werden. Prüft in diesem Fall, dass der Dateizugriff auch ohne Anmeldung beim entsprechenden Dienst funktioniert und stellt sicher, dass der Link auch für mindestens ein Jahr aktiv bleibt.

Das Video soll Lust darauf machen, die App ausprobieren zu wollen. Qualität der Produktion, etc. fließen jedoch natürlich nicht in die Bewertung mit ein.

- [x] Im Repository auf GitHub findet sich ein kurzes Projektvideo (Richtwert ca. 1 - 3 Minuten) eurer App (siehe Vorlesung 13, Folie 32f)
- [x] Das Video präsentiert kurz alle Features und Screens der App
- [x] Das Video ist vertont mit Voiceover oder enthält Untertitel. Das Gezeigte wird dadurch anschaulich beschrieben
