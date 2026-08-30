# Nettoyage de données — Étude vaccin chez des adolescents

*English version below*

---

## 🇫🇷 Français

### C'est quoi ce projet ?

Je suis étudiant en médecine et j'apprends l'analyse de données en parallèle. Ce projet est mon premier vrai exercice de nettoyage de données, fait sur un vrai jeu de données (pas un dataset simulé pour l'exercice).

Le but : montrer comment je m'y prends pour nettoyer des données quand il n'y a aucune documentation pour m'aider, et comment je vérifie mon propre travail.

### D'où viennent les données

Les données viennent d'une vraie étude sur un vaccin COVID chez des adolescents scolarisés, avec des tests sanguins faits à 28 jours, 3 mois et 7 mois après la vaccination. Je les ai récupérées sur le dépôt [OxfordIHTM/messy-data](https://github.com/OxfordIHTM/messy-data), qui propose exprès des données "sales" pour s'entraîner.

### Comment le dossier est organisé

```
vaccine-adolescents-serology/
├── data/
│   ├── raw/         → les données telles que je les ai trouvées, jamais touchées
│   └── clean/        → les données une fois nettoyées (en français et en anglais)
├── dictionary/        → le dictionnaire des variables
├── docs/               → mon journal, où j'ai noté chaque étape et chaque décision
└── outputs/           → pas encore fait (graphiques à venir)
```

### Comment j'ai travaillé

Il n'y avait aucune documentation officielle sur les variables. J'ai donc dû reconstruire un dictionnaire moi-même, en regardant les vraies valeurs dans les colonnes, en cherchant le vocabulaire médical qui correspond, et en vérifiant mes hypothèses en croisant plusieurs colonnes entre elles.

Le nettoyage s'est fait en 7 étapes : renommer les colonnes, gérer les valeurs manquantes, séparer les cellules qui avaient 2 valeurs collées ensemble, gérer les codes bizarres et valeurs limites, vérifier que chaque colonne avait le bon type (nombre, date, texte), reconstruire une variable qui était vide à l'origine, et enfin calculer quelques indicateurs pour vérifier que tout le nettoyage tenait la route.

Tout le détail, action par action, est dans mon journal : [`docs/cleaning_journal_fr.csv`](docs/cleaning_journal_fr.csv).

### Ce que j'ai trouvé d'intéressant en le faisant

- Une colonne avait un code qui ressemblait à un échec de test dans 62% des cas — ça semblait énorme pour une vraie panne. En vérifiant avec une autre colonne, j'ai compris que ce n'était pas un échec, mais simplement que le test n'avait pas été fait pour ces sujets-là. J'ai corrigé l'étiquette en conséquence.
- Une de mes vérifications finales a donné un résultat complètement absurde (une moyenne 10 000 fois trop grande). En creusant, j'ai trouvé un bug de virgule/point resté caché dans une colonne, malgré plusieurs étapes de nettoyage déjà faites. Ça m'a appris à toujours vérifier mes résultats avec des indicateurs de bon sens, pas juste faire confiance à mes propres manipulations.
- Une colonne était complètement vide dans le fichier d'origine. Plutôt que de la supprimer ou d'inventer des valeurs au hasard, je l'ai reconstruite avec une règle claire que j'ai documentée.

### Avec quoi j'ai travaillé

Excel pour tout le nettoyage et la documentation, GitHub pour publier le résultat.

### Une précision sur la langue

Mon journal de nettoyage est en français uniquement (c'est ma trace de travail perso). Le dataset final et le dictionnaire, eux, sont en français ET en anglais.

---

## 🇬🇧 English

### About this project

I'm a medical student learning data analysis on the side. This is my first real data cleaning project, done on a real dataset (not something simulated for the exercise).

The goal: show how I clean data when there's no documentation to rely on, and how I check my own work along the way.

### Where the data comes from

The data comes from a real study on a COVID vaccine in school-aged adolescents, with blood tests done at 28 days, 3 months, and 7 months after vaccination. I got it from the [OxfordIHTM/messy-data](https://github.com/OxfordIHTM/messy-data) repository, which deliberately provides messy data for practice.

### How the folder is organized

```
vaccine-adolescents-serology/
├── data/
│   ├── raw/         → the data as I found it, never touched
│   └── clean/        → the cleaned data (French and English)
├── dictionary/        → the variable dictionary
├── docs/               → my journal, where I noted every step and decision
└── outputs/           → not done yet (charts coming later)
```

### How I worked

There was no official documentation for the variables. So I had to rebuild a dictionary myself, by looking at the actual values in each column, matching them to standard medical vocabulary, and checking my guesses by cross-referencing several columns together.

The cleaning happened in 7 steps: renaming columns, handling missing values, splitting cells that had two values stuck together, dealing with weird codes and threshold values, checking that every column had the right type (number, date, text), rebuilding a variable that was empty from the start, and finally calculating a few indicators to check the whole cleaning actually held up.

Full detail, action by action, is in my journal: [`docs/cleaning_journal_fr.csv`](docs/cleaning_journal_fr.csv) (French only).

### Things I found interesting while doing this

- One column had a code that looked like a test failure in 62% of cases — that seemed way too high for a real equipment issue. By checking against another column, I realized it wasn't a failure at all, just that the test hadn't been run for those subjects. I fixed the label accordingly.
- One of my final checks gave a completely absurd result (an average 10,000 times too big). Digging in, I found a decimal-point bug still hiding in a column, despite several cleaning steps already done. That taught me to always check my results with sanity-check indicators, not just trust my own manipulations.
- One column was completely empty in the original file. Instead of deleting it or making up random values, I rebuilt it with a clear, documented rule.

### Tools I used

Excel for all the cleaning and documentation, GitHub to publish the result.

### A note on language

My cleaning journal is in French only (it's my personal working notes). The final dataset and dictionary are in both French and English.
