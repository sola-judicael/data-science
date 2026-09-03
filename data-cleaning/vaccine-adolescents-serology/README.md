# Nettoyage de données — Étude vaccin chez des adolescents

*English version below*

---

## Français

Je suis étudiant en médecine et j'apprends l'analyse de données à côté. C'est mon premier vrai projet de nettoyage de données, sur un vrai dataset (pas un truc simulé pour l'exercice).

L'idée : montrer comment je m'y prends pour nettoyer des données quand il n'y a aucune doc pour m'aider, et comment je vérifie mon propre travail après coup.

**D'où viennent les données** : d'une vraie étude sur un vaccin COVID chez des adolescents scolarisés, avec des prises de sang à 28 jours, 3 mois et 7 mois après la vaccination. Récupérées sur le dépôt [OxfordIHTM/messy-data](https://github.com/OxfordIHTM/messy-data), qui propose des données volontairement sales pour s'entraîner.

**Dans ce dossier** :
- **data/raw** — le fichier original, jamais touché
- **data/clean** — les données nettoyées, en français et en anglais
- **dictionary** — le dictionnaire des variables
- **docs** — mon journal, où j'ai noté chaque étape et chaque décision
- **outputs** — vide pour l'instant, les graphiques viendront plus tard

**Comment j'ai travaillé** : il n'y avait aucune documentation officielle sur les variables. J'ai dû reconstruire un dictionnaire moi-même, en regardant les vraies valeurs des colonnes, en cherchant le vocabulaire médical qui correspondait, et en vérifiant mes hypothèses en croisant plusieurs colonnes entre elles.

Le nettoyage s'est fait en 7 étapes : renommer les colonnes, gérer les valeurs manquantes, séparer les cellules qui avaient 2 valeurs collées, gérer les codes bizarres et les valeurs limites, vérifier que chaque colonne avait le bon type, reconstruire une variable qui était vide à l'origine, et calculer quelques indicateurs pour vérifier que tout le nettoyage tenait la route. Le détail complet, action par action, est dans le journal : `docs/cleaning_journal_fr.csv`.

**Ce que j'ai trouvé intéressant en le faisant** :

Une colonne avait un code qui ressemblait à un échec de test dans 62% des cas, ce qui me paraissait énorme pour une vraie panne d'appareil. En croisant avec une autre colonne, j'ai compris que ce n'était pas un échec — le test n'avait simplement pas été fait pour ces sujets-là. J'ai corrigé l'étiquette.

Un de mes calculs de vérification a donné un résultat absurde, une moyenne 10 000 fois trop grande. En creusant, j'ai trouvé un bug de virgule/point resté caché dans une colonne, malgré plusieurs étapes de nettoyage déjà faites avant. Ça m'a appris à toujours vérifier avec des indicateurs de bon sens, pas juste faire confiance à mes propres manipulations précédentes.

Une colonne était complètement vide dans le fichier d'origine. Au lieu de la supprimer ou d'inventer des valeurs, je l'ai reconstruite avec une règle claire, documentée dans le journal.

**Outils** : Excel pour tout le nettoyage et la documentation, GitHub pour publier.

**Sur la langue** : mon journal est en français uniquement, c'est ma trace de travail perso. Le dataset final et le dictionnaire sont en français et en anglais.

---

## English

I'm a medical student learning data analysis on the side. This is my first real data cleaning project, on a real dataset — not something simulated for practice.

The idea: show how I clean data when there's no documentation to lean on, and how I check my own work afterward.

**Where the data comes from**: a real study on a COVID vaccine in school-aged adolescents, with blood tests at 28 days, 3 months, and 7 months after vaccination. Pulled from the [OxfordIHTM/messy-data](https://github.com/OxfordIHTM/messy-data) repository, which deliberately provides messy data for practice.

**In this folder**:
- **data/raw** — the original file, never touched
- **data/clean** — the cleaned data, in French and English
- **dictionary** — the variable dictionary
- **docs** — my journal, where I noted every step and decision
- **outputs** — empty for now, charts will come later

**How I worked**: there was no official documentation for the variables. I had to rebuild a dictionary myself, by looking at the actual values in each column, matching them to standard medical vocabulary, and checking my guesses by cross-referencing several columns.

The cleaning happened in 7 steps: renaming columns, handling missing values, splitting cells with two values stuck together, dealing with weird codes and threshold values, checking that every column had the right type, rebuilding a variable that was empty from the start, and calculating a few indicators to check the whole thing held up. Full detail, step by step, is in the journal: `docs/cleaning_journal_fr.csv` (French only).

**Things I found interesting while doing this**:

One column had a code that looked like a test failure in 62% of cases, which seemed way too high for a real equipment issue. Cross-checking with another column, I realized it wasn't a failure — the test just hadn't been run for those subjects. Fixed the label.

One of my final checks gave an absurd result, an average 10,000 times too big. Digging in, I found a decimal-point bug still hiding in a column, despite earlier cleaning steps. That taught me to always sanity-check with indicators, not just trust my own past work.

One column was completely empty in the original file. Instead of deleting it or making up values, I rebuilt it with a clear rule, documented in the journal.

**Tools**: Excel for the cleaning and documentation, GitHub to publish.

**On language**: my journal is French only, it's my personal working notes. The final dataset and dictionary are in both French and English.
