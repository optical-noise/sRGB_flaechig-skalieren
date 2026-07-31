# sRGB_flaechig-skalieren
Shell-Skript, welches die Bilder in einem Ordner nach Wunsch skaliert / verkleinert (per ImageMagick) und in den sRGB-Farbraum bringt.



# WAS MACHT DAS SKRIPT?
– Es bringt die Bilder in einem Ordner in den sRGB-Farbraum.
– Es skaliert die Bilder so, dass sie am Schluss die gleiche Fläche aufweisen.
– Es speichert die Bilder als JPG in einem Ausgabe-Ordner.
– Sehr kleine Bilder, d.h. beide Bildseitenlängen kleiner als die Zielgrössen, werden unbearbeitet in einen "zu klein"-Ordner gelegt.

Drei Parameter können am Anfang des Skripts bestimmt werden:
– Zielgrösse für die längere Bildseite 
– Zielgrösse für die kürzere Bildseite
– Qualität der ausgegebenen JPGs


# 0) Voraussetzung: 

    ImageMagick ist installiert (https://imagemagick.org/). 
    Das Tool wird hier verwendet.
    (Installation mit Homebrew: brew install imagemagick)


# 1) Terminal: Dem Skript Ausführungsberechtigung erteilen

    Per "cd" ins Directory mit dem Skript gehen und:
    chmod +x Bilder__sRGB_flaechig-skalieren_JPG [ENTER]


# 2) Das Skript (im Directory, in welchem es liegt) ausführen:

    ./Bilder__sRGB_flaechig-skalieren_JPG [ENTER]

    Ein Dialog erscheint, in dem der Bilderordner ausgewählt werden kann.
    Danach skaliert es die Bilder.
    Die bearbeitet landen in einem Ordner "_OUTPUT (skaliert)",
    die unbearbeiteten, weil zu klein, in einem Ordner "_Zu klein (unbearbeitet)"

    Im Terminal wird ein Fortschrittsbalken angezeigt.


   

--
Masus, 31. Juli 2026
