![TrackBud_Banner](https://github.com/user-attachments/assets/2212f5c1-dd3c-44ee-bbc8-8d9294e8e506)
# TrackBud

[![Review Assignment Due Date](https://classroom.github.com/assets/deadline-readme-button-22041afd0340ce965d47ae6ef1cefeee28c7c493a6346c4f15d667ab976d596c.svg)](https://classroom.github.com/a/Q_AsCGAw)


![Screenshot_20241003-211058](https://github.com/user-attachments/assets/d5e67feb-9f37-4c0d-b9b3-dae1ba2b18cb)
![Screenshot_20241003-211106](https://github.com/user-attachments/assets/dd38c5a0-4b4c-4a8d-a9de-e6d7db8f2036)
![Screenshot_20241003-211114](https://github.com/user-attachments/assets/5c2d19e1-71f0-4b65-ad63-7659395d7724)
Der Overview-Screen ist der Bildschirm auf dem der Nutzer beim starten der App landet, er ist in verschiedene Tiles gegliedert, die den Nutzer über über die Wichtigsten Werte seiner Finanzen informieren soll.
Ganz oben ist das Tile zu sehen, welches dem Nutzer Informationen über das eigene Ausgabeverhalten gibt. Dabei kann er zwischen Tag, Monat und Jahr wechseln, um angezeigt zu bekommen wieviel Geld in diesem Zeitraum als Ausgabe in den Transaktionen hinzugefügt wurde. Zudem sieht der Nutzer die Verteilung dieser Aufgaben auf die Kategorien als Diagramm. Darunter befindet sich in der Monats- oder Jahresansicht ein weiteres Diagramm, welches Überblick über die einzelnen Tage des Monats gibt, wobei die Werte von Tag zu Tag aufgerechnet werden und das Balkenmaximum das festgelegte Monatsbudget ist. In der Jahresansicht sieht der Nutzer seine Ausgaben für jeden vergangenen Monat, wobei auch hier wieder das Balkenmaximum das Monatsbudget ist.
Im Tile darunter wird dem Nutzer in Worten sowie im Balken angezeigt wie viel Geld er diesen Monat noch zur Verfügung hat, wobei die Farbe des Balkens sich je nach Füllgrad ändert.
Das 3. Tile auf dieser Seite zeigt die generelle Bilanz der Split-Schulden vom Debt-Screen (2. Nav-Page), wobei die Beträge, die man schuldet und die andere einem schulden miteinander verrechnet werden und einem eine Gesamtbilanz angezeigt wird.
Der letzte Bereich des Overview-Screen ist der Transaktions-Verlauf, welcher einem die eigenen Ausgaben als sortierte Liste anzeigt. Diese Liste findet sich auch auf dem Analysis-Screen (3. Nav-Page) wieder. Auf Besonderheiten dieser Liste gehe ich später noch ein.

![Screenshot_20241003-211250](https://github.com/user-attachments/assets/fa90dc34-5261-44ec-9383-e70590466c2d)
Dies ist der Debt-Screen. Auf dieser Seite bekommt der Nutzer genauere Informationen über seine Schulden/Guthaben bei Freunden und in Gruppen. 
Ganz oben findet man die zusammengerechneten Werte aller Freunde und Gruppen wieder, also wieviel man zahlen muss und wieviel man von anderen bekommt um wieder mit alles quitt zu sein.
Darunter befindet sich die Liste einiger Freunde mit Name, Profilbild und Schuldenbetrag, jedes dieser Elemente führt durch einen Klick zum Freunde-Profil. Oben rechts kann sich der Nutzer alle Freunde anzeigen lassen.
Darunter befindet sich äquivalent dazu die Liste einiger Gruppen mit dem gleichen Aufbau und der gleichen Funktionalität wie in der Freundesliste. Zusätzlich werden hier das Gruppenprofilbild, die Mitglieder-Bilder, das Erstelldatum und die Gesamtausgaben der Gruppe angezeigt.

![Screenshot_20241003-211254](https://github.com/user-attachments/assets/26b4fcb3-06ef-4eb3-9045-c345addf2831)
Hier sind wir nun auf der "Deine Freunde" Seite, welche alle Freunde des Nutzers anzeigt und die sich dazu noch durchsuchen lässt. Hier sieht man die gleichen Informationen über die Freunde wie auch schon auf der vorherigen Seite. Oben rechts befindet sich der Knopf mit dem sich neue Freundschaften schließen lassen.

![Screenshot_20241003-211313](https://github.com/user-attachments/assets/df2a77e9-06fd-41f0-93bf-ec5042360227)
Mit dem Klick auf den Knopf öffnet sich ein ModalBottomSheet (je nach Betriebssystem) über welches sich ein Link in unterschiedlichen Apps teilen lässt. Drückt ein anderer Nutzer, der ebenfalls die App besitzt auf diesen geteilten Link, öffnet sich die App bei ihm und die beiden Nutzer werden mittels userId gefunden und als Freunde geaddet. (für eine bessere Implementierung von Freundschaften (Einladungen, etc.) hatten wir leider nicht genug Zeit)

![Screenshot_20241003-211332](https://github.com/user-attachments/assets/df2a492f-a4fe-4cd7-8388-5684e7251414)
Hier sieht man das Freundeprofil, auf welches man kommt wenn man einen Freund aus der Liste anklickt. Auf dieser Seite sieht man den Namen & das Profilbilde des Freundes, den aktuellen Schuldenstand, gemeinsame Gruppen, in denen beide Nutzer sind, einen Knopf zum Schulden begleichen, den Split-Verlauf dieser beiden Nutzer und einen Knopf um einen neuen Split mit diesem Nutzer zu erstellen.
Der Split-Verlauf besteht auch hier wieder aus einzelnen Tiles, welche Kategorie, Name des Zahlenden, Titel, Datum, Gesamtbetrag und persönlichen Betrag des momentanen Nutzers anzeigen. Dabei soll grün zeigen, dass der aktuelle Nutzer durch diesen Split Geld bei seinem Freund gut gemacht hat, wobei rot für das Gegenteil steht. 
Sobald die Nutzer den jeweiligen Schuldenbetrag zu einem beliebigen Zeitpunkt überwiesen haben und somit wieder quitt sind, kann einer der Nutzer den Button 'Schulden begleichen' drücken. Dadurch werden alle bisherigen Splits als 'bezahlt' betrachtet und die Teilsummen druchgestrichen. Die Nutzer sind wieder quitt.

![Screenshot_20241003-211343](https://github.com/user-attachments/assets/3b37781b-7435-4739-90df-447855be7aae)
Äquivalent zum 'Deine Freunde' Screen sehen wir hier den 'Deine Gruppen' Screen, welcher den gleichen Zweck für Gruppen erfüllt. Der Button oben rechnts kann hier ebenfalls gedrückt werden, und leitet zum nächsten 'Bildschirm' weiter.

![Screenshot_20241003-211348](https://github.com/user-attachments/assets/9b642010-6101-4a31-bd43-3f266c055661)
Hier kann der Nutzer eine neue Gruppe erstellen. Leider kann man Gruppen momentan nur einmalig bei der Erstellung bearbeiten. Also kann man noch nicht nachträglich Nutzer hinzufügen oder andere Änderungen vornehmen. 
Das ModalBottomSheet erlaubt es dem Nutzer hier einen Gruppennamen festzulegen, ein Gruppenprofilbild aus der eigenen Gallerie auszuwählen und die eigenen Freunde zur Gruppe hinzuzufügen. Nach der Erstellung muss leider noch die Seite neu geladen werden um die neue Gruppe anzuzeigen.

![Screenshot_20241003-212007](https://github.com/user-attachments/assets/8e98dfdf-4cf7-4a5c-bc30-9c9912e97339)
![Screenshot_20241003-212012](https://github.com/user-attachments/assets/9d5ddc80-f12a-4e59-a3e3-f5dce896f783)
Hier sehen wir nun das äquialent zum Freundeprofil: Das Gruppenprofil einer ausgewählten Gruppe. Hier sieht der Nutzer den Namen der Gruppe, den Gesamtbetrag aller Ausgaben, den Gesamtbetrag der eigenen Ausgaben, seine Schulden/Guthaben, eine Schuldenübersicht, eine Ausgabenübersicht und den Gruppensplit-Verlauf.
Alle Werte errechnen sich aus den Werten des Gruppensplit-Verlaufs. Die oberen drei Werte sollten selbsterklärend sein, die Schuldenübersicht zeigt an, an wen der aktuelle Nutzer Geld zahlen muss bzw. von wem er Geld erhält, um wieder quitt zu sein. Die Ausgabenübersicht gibt einen Überblick über die Kategorien, für welche die Gruppe Geld ausgegeben hat.
Der Split-Verlauf ist hier ähnlich zum Freunde Split, mit dem Unterschied, dass hier zudem die beteiligten Nutzer durch das Profilbild angezeigt werden. Basierend auf der Anzahl der Teilnehmer an einem Split wird auch hier wieder angezeigt welchen Einfluss die Ausgabe für das Schuldenverhältnis des Nutzers hat.
Um detailliertere Informationen über die Rückzahlungen zu bekommen kann der Nutzer bei der Schuldenübersicht auf 'Alle Anzeigen' klicken, was ihn zur folgenden Seite führt.

![Screenshot_20241003-212015](https://github.com/user-attachments/assets/7f524fbd-5458-4d03-b2e9-a7aa6cb7e675)
Hier sieht der Nutzer nicht nur die vorgeschlagenen Zahlungen von sich selbst, sondern auch von allen anderen Mitgliedern der Gruppe. Dabei steht der Schuldner immer links, der Betrag in der Mitte und der Gläubiger auf der linken Seite.

![Screenshot_20241003-212106](https://github.com/user-attachments/assets/e351eb47-2522-4062-87cf-5314e28d060e)
Dies ist die Ansicht, sobald der Nutzer auf den 'Plus' Button klickt. Hier kann man neue Transaktionen (Ausgaben/Einnahmen alleine) Freundesplits oder Gruppensplits hinzufügen. Je nach Auswahl wird man auf einen der folgenden Bildschirme weitergeleitet. 

![Screenshot_20241003-212118](https://github.com/user-attachments/assets/f7112766-2be1-4b1d-97d8-2435c3db0b97)
Im Falle einer neuen Transaktion sieht der Nutzer diesen Bildschirm, wo er zuerst zwischen Einkommen und Ausgabe wählen kann, dann einen Titel eingeben kann, als nächstes einen Betrag eingeben muss, zudem das Datum und die Uhrzeit ändern kann, eine Kategorie auswählen muss und zum Schluss noch eine Notiz eintragen kann.
Erst wenn Betrag und Kategorie festgelegt wurden kann der Nutzer die Transaktion erstellen. 

![Screenshot_20241003-212125](https://github.com/user-attachments/assets/9b6892ac-0e56-49f4-83f7-67740cc3cb8c)
Wenn der Nutzer einen Freundesplit über das + hinzufügen will so landet er hier, wo er zuerste einen seiner Freunde aus der Liste auswählen muss um weiter zu machen. 

![Screenshot_20241003-212138](https://github.com/user-attachments/assets/474cee8a-6bfe-4afd-8b91-9eaf2d495aa0)
![Screenshot_20241003-212145](https://github.com/user-attachments/assets/443059ca-56fd-4fd7-bb3a-3c6a39762dc3)
![Screenshot_20241003-212156](https://github.com/user-attachments/assets/ad3024bc-8c23-40df-830b-9dd2b86069a8)
Nach der Auswahl des Freundes landet der Nutzer hier. Der Großteil der Möglichkeiten ist hier wie bei einer normalen Transaktion, hier die Unterschide: 
+ im Freundesplit können nur Ausgaben getrackt werden, kein Einkommen.
+ Man kann keine Notiz hinzufügen.
+ Der Nutzer kann auswählen wer den Split bezahlt hat.
+ Der Nutzer kann zwischen drei Split-Methoden wählen: gleichmäßig, prozentual oder nach Betrag.


![Screenshot_20241003-212207](https://github.com/user-attachments/assets/5313e30a-d39c-47df-ad44-89764e2832e1)
Dies ist die Auswahl der Gruppen wenn der Nutzer eine Gruppensplit hinzufügen wollte.

![Screenshot_20241003-212218](https://github.com/user-attachments/assets/48f3c1d9-c971-4eb5-9a66-ad7231810736)
Hier landet der Nutzer nach einer Auswahl der Gruppe oder wenn der über den Gruppenscreen einen Split hinzufügen will. Die Eingabemöglichkeiten sind hier wieder ähnlich zum Freunde-Split. Jedoch kann der Nutzer hier natrülich aus allen Gruppenmigliedern den Zahlenden auswählen und danach alle Mitglieder die am Split beteiligt sind. Anders als beim Freundesplit gibt es hier bis jetzt leider nur den gleichmäßigen Split, welcher den Gesamtbetrag auf alle beteiligten gleichmäßig verteilt.

![Screenshot_20241003-212232](https://github.com/user-attachments/assets/6a89d673-9024-46de-ab3d-3c5be3d49df7)
![Screenshot_20241003-212236](https://github.com/user-attachments/assets/eaca3dd6-ade1-476e-a018-3907a125b7d3)
![Screenshot_20241003-212245](https://github.com/user-attachments/assets/068ecebc-2416-4ba6-9f36-d0f3ee42cc65)
Hier sehen wir den Analysis Screen, welcher ganz oben den aktuellen Kontostand anzeigt. Darunter befindet sich ein Dropdown-Menü, mit welchem man zwischen Einnahmen und Ausgaben wechseln kann, und ein Tile, welches die bisherigen Einnahmen/Ausgaben. Mittig befindet sich ein DonutChart, welches die Ausgaben nach Kategorien gliedert, diese Kategorien werden in der Liste darunter noch einmal dargestellt und mit weiteren Informationen versehen. Durch den Klick auf eine Kategorie im Chart oder in der Liste wird der Transaktions Verlauf darunter nach der jeweiligen Kategorie durchsucht und nur Transaktionen der ausgewählten Kategorie angezeigt.

![Screenshot_20241003-212250](https://github.com/user-attachments/assets/3974837e-0b03-4294-b747-e54987944e57)
![Screenshot_20241003-212253](https://github.com/user-attachments/assets/b75c4699-7b03-45f4-9e7a-6f1ca757bed2)
Dies ist die Ansicht wenn man auf eine Transatktion in der Liste drückt (Auch bei der Transaktionsliste auf dem Overview Screen). Hier werden noch einmal die Details der Transaktion hervorgehoben und die Notiz angezeigt. Zudem kann man mit einem Klick auf das 3 Punkte Menü oben links die Transaktion löschen oder bearbeiten.

![Screenshot_20241003-212257](https://github.com/user-attachments/assets/76815150-800a-4f46-b032-4c5e44bb7f90)
Wenn der Nutzer auf bearbeiten klickt, landet er hier. Hier werden die Details der Transaktion angezeigt und können (bis auf den Typ: Einnahme/Ausgabe) verändert und abgespeichert werden. 

![Screenshot_20241003-212307](https://github.com/user-attachments/assets/8436ed9d-32f6-4c5d-9925-4a0ccfaa3e38)
Hier sieht man den letzten Reiter im Nav-Menü, die Einstellungen. Hier sieht der Nutzer seinen Anzeige-Namen, seine E-Mail und sein Profilbild. Zudem kann er zu 3 Seiten weiter navigieren oder sich ausloggen.

![Screenshot_20241003-212311](https://github.com/user-attachments/assets/4fa5625b-3d3a-4fbe-af05-5ba7eeebb7ef)
Wenn der Nutzer auf 'Profil bearbeiten' klickt, landet er hier. Hier kann er sein Pfofilbild ändern indem er auf das Bild klickt, oder seinen Anzeige Namen abändern. Zudem sieht man noch einmal die Account E-Mail, welche man auf diesem Bildschirm auch noch ändern sollte, wozu wir leider nicht mehr gekommen sind.

![Screenshot_20241003-212314](https://github.com/user-attachments/assets/4d49b459-5572-4d51-a4d6-07fb8394b9d7)
Klickt der Nutzer auf 'Konto Anpassungen' so landet er hier. Hier soll man später das Erscheinungsbild ändern können, welches sich momentan nur automatisch ans Systemdesign anpasst. Zudem kann man hier weitergeleitet werden, um seinen Kontostand oder sein Budgetziel zu ändern.

![Screenshot_20241003-212317](https://github.com/user-attachments/assets/69171c98-bb10-4c5f-a1be-cc2ec0e533c2)
Hier kann man seinen Kontostand anpassen, falls er nicht mehr mit dem angezeigten übereinstimmt und man keine Transaktion hinzufügen möchte, die im Verlauf auftaucht.

![Screenshot_20241003-212320](https://github.com/user-attachments/assets/dce80099-df12-4035-8fbb-f393e765d290)
Hier kann man sein Budgetziel nach unten oder nach oben korrigieren, falls man mit dem aktuellen Ziel nicht mehr zufrieden ist. Dieses Ziel beeinflusst die ersten beiden Tiles auf dem Overview Screen.

![Screenshot_20241003-212324](https://github.com/user-attachments/assets/1372880b-37b0-4e76-bd5b-fa0fe7c12181)
Hier erfährt der Nutzer mehr über die Entstehung unserer App und kann sich mit Feature-Wünschen oder Bugs per Mail an uns richten.

![Screenshot_20241003-212330](https://github.com/user-attachments/assets/210b0fb7-642f-4e4b-9ab9-88da2393d596)
Das ist der Screen, der einen Nutzer bei der ersten Öffnung begrüßt, oder wenn sich der Nutzer ausgeloggt hat.
Mit dem Klick auf den Button wird er zum Login Screen weitergeleitet.

![Screenshot_20241003-212334](https://github.com/user-attachments/assets/4a241978-3a66-44e9-aac8-0aec16ddaab4)
Das ist der Login Screen. Hier meldet sich ein bereits registrierter Nutzer mit Email und Passwort an. Zudem kann man sich mit einem Google Account einloggen, oder zur Registrierungs Page wechseln, wenn man noch keinen Account hat.

![Screenshot_20241003-212338](https://github.com/user-attachments/assets/e2f012e9-8e78-4a8e-8d13-4034e45da6c6)
Hier ist der Registrierungs Screen, wo Nutzer mit Name, Email und einem Passwort (2x angeben) einen neuen Account anlegen können, oder wieder zum Anmelde Screen zurückkehren können.

![Screenshot_20241003-212410](https://github.com/user-attachments/assets/f79119e9-ee01-45d7-898b-97d78b876b43)
Nach erfolgreicher Registrierung landet der Nutzer hier, wo er einen Kontostand angeben muss, mit welchem die App in Zukunft arbeiten wird.

![Screenshot_20241003-212415](https://github.com/user-attachments/assets/69a23203-9264-441e-a35b-d260414ca71a)
Nachdem der Kontostand angegeben wird, fehlt nur noch das gesetzte monatliche Limit, welches hier eingestellt werden kann, um dann endlich auf den Overview Screen weitergeleitet zu werden.
