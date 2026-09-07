# Installation des libraries
library (tidyverse)
library(readxl)

# Importation de la base de données

vaccine_raw <- read_excel("data/raw/vaccine_raw.xlsx")

# Inspection de la base
View(vaccine_raw)

# Nouvelle indexation
vaccine <- vaccine_raw

# Inspection
## Résumé de la base
dim(vaccine)
glimpse(vaccine)
summary(vaccine)


## Valeurs manquantes
library(naniar)

gg_miss_var(vaccine) # visualisation graphique
miss_var_summary(vaccine)
View(miss_var_summary(vaccine)) # vue complète

## Documentation
# Dictionnaire de données déjà construit lors du nettoyage Excel du même dataset (absence de documentation officielle sur les données sources)
# Voir dictionary/data_dictionary.csv pour le détail complet

# Renommage des noms de colonnes
names(vaccine)

vaccine <- vaccine %>% 
  rename(
    ID_sujet = D,
    Sexe = Gender,
    Comorbidite_naissance = BirthComor,
    Valeur_IMC = `BMI measure`,
    Classe_IMC = BMI,
    Statut_vaccinal = Vacstat,
    Date_dose1 = `Date 1`,
    Date_dose2 = `Date 2`,
    Age = Age,
    Classe_scolaire = Class,
    Infection_anterieure = `Infected prior to vaccination`,
    Titre_AC_28j = `Quantivac at 28 days`,
    Resultat_qual_28j = `Q 28 Result`,
    DensiteOptique_28j = ODQ28Days,
    CapaciteNeutralisation_28j = `NCPat28 days`,
    Resultat_neutralisation_28j = N28Results,
    Titre_AC_3mois = `Quantivacat3 months`,
    Resultat_qual_3mois = `Q3 Result`,
    DensiteOptique_3mois = ODQ4months,
    CapaciteNeutralisation_3mois = NCPat3months,
    Resultat_neutralisation_3mois = N3Result,
    Titre_AC_7mois = `Quantivacat7months`,
    Resultat_qual_7mois = Q7Result,
    DensiteOptique_7mois = ODQ7months,
    CapaciteNeutralisation_7mois = NCPat7months,
    Resultat_neutralisation_7mois = N7Result,
    Temps_suivi_jours = Time,
    Statut_evenement = Status,
    Titre_tronque = TruncatedTiter
  )

names(vaccine)

# Traitement des valeurs manquantes
## Variables concernées Comorbidite_naissance, Date_dose1, Date_dose2

vaccine %>%
  select(Comorbidite_naissance, Date_dose1, Date_dose2) %>%
  glimpse()

vaccine <- vaccine %>%
  mutate(Comorbidite_naissance = na_if(Comorbidite_naissance, "NA"))

vaccine %>%
  select(Comorbidite_naissance, Date_dose1, Date_dose2) %>%
  glimpse()

# Note : contrairement à Excel, readxl convertit automatiquement les erreurs #N/A en vrai NA à l'import
# Date_dose1/Date_dose2 n'ont donc pas nécessité de traitement supplémentaire. Seul "NA" en texte de Comorbidite_naissance a demandé un na_if()


# Traitement des vaeleurs dupliquées
## Variables concernées : CapaciteNeutralisation_(28j, 3mois, 7mois) et Titre_AC_7mois

vaccine %>% 
  select(CapaciteNeutralisation_28j, CapaciteNeutralisation_3mois, CapaciteNeutralisation_7mois, Titre_AC_7mois) %>% 
  glimpse()

vaccine <- vaccine %>%
  separate(CapaciteNeutralisation_28j, 
           into = c("CapaciteNeutralisation_28j_mesure1", "CapaciteNeutralisation_28j_mesure2"),
           sep = "/", fill = "right", remove = FALSE)


vaccine <- vaccine %>%
  separate(CapaciteNeutralisation_3mois, 
           into = c("CapaciteNeutralisation_3mois_mesure1", "CapaciteNeutralisation_3mois_mesure2"),
           sep = "/", fill = "right", remove = FALSE)

vaccine <- vaccine %>%
  separate(CapaciteNeutralisation_7mois, 
           into = c("CapaciteNeutralisation_7mois_mesure1", "CapaciteNeutralisation_7mois_mesure2"),
           sep = "/", fill = "right", remove = FALSE)

vaccine <- vaccine %>%
  separate(Titre_AC_7mois, 
           into = c("Titre_AC_7mois_mesure1", "Titre_AC_7mois_mesure2"),
           sep = "/", fill = "right", remove = FALSE)

vaccine %>% 
  select(CapaciteNeutralisation_28j_mesure1, CapaciteNeutralisation_28j_mesure2,
         CapaciteNeutralisation_3mois_mesure1, CapaciteNeutralisation_3mois_mesure2,
         CapaciteNeutralisation_7mois_mesure1, CapaciteNeutralisation_7mois_mesure2
         ) %>% 
  glimpse()


# Traitement des censures et codes spéciaux
## Création de deux nouvelles colonnes "_statut" et "_valeur"
## Rappel : Colonnes d'origine mélangeaient valeurs numériques réelles et codes texte (">120", "*****")
##conserver l'info qualitative plutôt que de la supprimer ou d'inventer une valeur

### Création des colonnes "_statut"
View(vaccine %>% 
  select(Titre_AC_28j, Titre_AC_3mois, Titre_AC_7mois_mesure1, Titre_AC_7mois_mesure2) %>% 
  unique())

vaccine <- vaccine %>%
  mutate(
    Titre_AC_28j_statut = case_when(
      is.na(Titre_AC_28j) ~ "Manquant",
      str_starts(Titre_AC_28j, ">") ~ "Censure haute",
      Titre_AC_28j == "*****" ~ "Non testé",
      TRUE ~ "Normal"
    ),
    Titre_AC_3mois_statut = case_when(
      is.na(Titre_AC_3mois) ~ "Manquant",
      str_starts(Titre_AC_3mois, ">") ~ "Censure haute",
      Titre_AC_3mois == "*****" ~ "Non testé",
      TRUE ~ "Normal"
    ),
    Titre_AC_7mois_mesure1_statut = case_when(
      is.na(Titre_AC_7mois_mesure1) ~ "Manquant",
      str_starts(Titre_AC_7mois_mesure1, ">") ~ "Censure haute",
      Titre_AC_7mois_mesure1 == "*****" ~ "Non testé",
      TRUE ~ "Normal"
    ),
    Titre_AC_7mois_mesure2_statut = case_when(
      is.na(Titre_AC_7mois_mesure2) ~ "Manquant",
      str_starts(Titre_AC_7mois_mesure2, ">") ~ "Censure haute",
      Titre_AC_7mois_mesure2 == "*****" ~ "Non testé",
      TRUE ~ "Normal"
    )
  )

View(vaccine %>% 
       select(Titre_AC_28j, Titre_AC_28j_statut, Titre_AC_3mois,Titre_AC_3mois_statut,
              Titre_AC_7mois_mesure1, Titre_AC_7mois_mesure1_statut, Titre_AC_7mois_mesure2,
              Titre_AC_7mois_mesure2_statut) %>% 
       unique())

# Commentaire :
## Le test is.na() en premier dans case_when() sert surtout pour Titre_AC_7mois_mesure2 
## Après séparation des cellules "x/y" avec fill = "right", la plupart des sujets n'avaient qu'une seule mesure, donc mesure2 est vide pour eux
## Ces cas doivent ressortir "Manquant", pas être classés à tort en "Normal" (piège déjà rencontré sur Excel).
## Sur Titre_AC_28j/3mois/7mois_mesure1, "Manquant" doit rester à 0, ces colonnes n'ayant aucune vraie cellule vide à l'origine.


### Création des colonnes "_valeur"
vaccine <- vaccine %>%
  mutate(
    Titre_AC_28j_valeur = as.numeric(Titre_AC_28j),
    Titre_AC_3mois_valeur = as.numeric(Titre_AC_3mois),
    Titre_AC_7mois_mesure1_valeur = as.numeric(Titre_AC_7mois_mesure1),
    Titre_AC_7mois_mesure2_valeur = as.numeric(Titre_AC_7mois_mesure2)
  )

View(vaccine %>% 
       select(Titre_AC_28j, Titre_AC_28j_valeur, Titre_AC_3mois,Titre_AC_3mois_valeur,
              Titre_AC_7mois_mesure1, Titre_AC_7mois_mesure1_valeur, Titre_AC_7mois_mesure2,
              Titre_AC_7mois_mesure2_valeur) %>% 
       unique())

# Commentaire
## Les avertissements "NAs introduits lors de la conversion automatique" sont normaux et attendus ici 
## as.numeric() transforme les codes texte
## (">120", "*****") en NA, exactement l'équivalent du SIERREUR(CNUM(...)) utilisé sur Excel. Ce n'est pas une erreur à corriger


# Correction des labels N, R, * et ?
## Variables concernées : Titre_AC_28j/_3mois/_7mois_mesure1/_mesure2 (statut)

vaccine <- vaccine %>%
  mutate(
    Resultat_qual_28j = case_when(
      Resultat_qual_28j == "N" ~ "Négatif",
      Resultat_qual_28j == "R" ~ "Réactif",
      Resultat_qual_28j == "*" ~ "Non testé",
      Resultat_qual_28j == "?" ~ "Incertain",
      TRUE ~ Resultat_qual_28j
    ),
    Resultat_qual_3mois = case_when(
      Resultat_qual_3mois == "N" ~ "Négatif",
      Resultat_qual_3mois == "R" ~ "Réactif",
      Resultat_qual_3mois == "*" ~ "Non testé",
      Resultat_qual_3mois == "?" ~ "Incertain",
      TRUE ~ Resultat_qual_3mois
    ),
    Resultat_qual_7mois = case_when(
      Resultat_qual_7mois == "N" ~ "Négatif",
      Resultat_qual_7mois == "R" ~ "Réactif",
      Resultat_qual_7mois == "*" ~ "Non testé",
      Resultat_qual_7mois == "?" ~ "Incertain",
      TRUE ~ Resultat_qual_7mois
    )
  )

vaccine %>% 
  select (Resultat_qual_28j, Resultat_qual_3mois, Resultat_qual_7mois) %>% 
  glimpse()


# Standardisation catégorielle

vaccine <- vaccine %>%
  mutate(
    Sexe = case_when(
      Sexe == "F" ~ "Femme",
      Sexe == "M" ~ "Homme",
      TRUE ~ Sexe
    ),
    Comorbidite_naissance = case_when(
      Comorbidite_naissance == "Y" ~ "Oui",
      Comorbidite_naissance == "N" ~ "Non",
      TRUE ~ Comorbidite_naissance
    ),
    Infection_anterieure = case_when(
      Infection_anterieure == "N" ~ "Négatif",
      Infection_anterieure == "R" ~ "Réactif",
      TRUE ~ Infection_anterieure
    ),
    Resultat_neutralisation_28j = case_when(
      Resultat_neutralisation_28j == "N" ~ "Négatif",
      Resultat_neutralisation_28j == "R" ~ "Réactif",
      TRUE ~ Resultat_neutralisation_28j
    ),
    Resultat_neutralisation_3mois = case_when(
      Resultat_neutralisation_3mois == "N" ~ "Négatif",
      Resultat_neutralisation_3mois == "R" ~ "Réactif",
      TRUE ~ Resultat_neutralisation_3mois
    ),
    Resultat_neutralisation_7mois = case_when(
      Resultat_neutralisation_7mois == "N" ~ "Négatif",
      Resultat_neutralisation_7mois == "R" ~ "Réactif",
      TRUE ~ Resultat_neutralisation_7mois
    ),
    Classe_IMC = case_when(
      Classe_IMC == "Overweight" ~ "Surpoids",
      Classe_IMC == "Normal Weight" ~ "Poids normal",
      Classe_IMC == "Underweight" ~ "Insuffisance pondérale",
      Classe_IMC == "Obese" ~ "Obésité",
      TRUE ~ Classe_IMC
    ),
    Statut_vaccinal = case_when(
      Statut_vaccinal == "Vaccinated" ~ "Vacciné",
      Statut_vaccinal == "Non Vaccinated" ~ "Non vacciné",
      TRUE ~ Statut_vaccinal
    )
  )

glimpse(vaccine)


# Vérifiacation des types de chaque colonne

sapply(vaccine, class)

# sapply(vaccine, class) montre que la quasi-totalité des colonnes ont le bon type après les étapes précédentes.
## Deux exceptions à corriger : CapaciteNeutralisation_..._mesure1/2 (6 colonnes) et Titre_tronque en logical (colonne 100% vide à l'origine,
## R devine "logique" par défaut sur une colonne sans aucune valeur)
## Les colonnes brutes conservées (remove = FALSE) restent volontairement en character

vaccine <- vaccine %>%
  mutate(
    CapaciteNeutralisation_28j_mesure1 = as.numeric(CapaciteNeutralisation_28j_mesure1),
    CapaciteNeutralisation_28j_mesure2 = as.numeric(CapaciteNeutralisation_28j_mesure2),
    CapaciteNeutralisation_3mois_mesure1 = as.numeric(CapaciteNeutralisation_3mois_mesure1),
    CapaciteNeutralisation_3mois_mesure2 = as.numeric(CapaciteNeutralisation_3mois_mesure2),
    CapaciteNeutralisation_7mois_mesure1 = as.numeric(CapaciteNeutralisation_7mois_mesure1),
    CapaciteNeutralisation_7mois_mesure2 = as.numeric(CapaciteNeutralisation_7mois_mesure2)
  )

vaccine %>% 
  select(CapaciteNeutralisation_28j_mesure1, CapaciteNeutralisation_28j_mesure2, 
         CapaciteNeutralisation_3mois_mesure1, CapaciteNeutralisation_3mois_mesure2,
         CapaciteNeutralisation_7mois_mesure1, CapaciteNeutralisation_7mois_mesure2) %>% 
  sapply(class)


# Construction variable dérivée : Titre_tronque

## Colonne reconstruite (vide à l'origine)
## valeur=120 si le statut de censure au temps correspondant
## Temps_suivi_jours est "Censure_haute", vide sinon

vaccine <- vaccine %>%
  mutate(
    Titre_tronque_derivee = case_when(
      is.na(Temps_suivi_jours) ~ NA_real_,
      Temps_suivi_jours == 92 & Titre_AC_3mois_statut == "Censure haute" ~ 120,
      Temps_suivi_jours != 92 & Titre_AC_7mois_mesure1_statut == "Censure haute" ~ 120,
      TRUE ~ NA_real_
    )
  )

vaccine %>% 
  select(Titre_tronque_derivee) %>% 
  str()


# Verification des indicateurs

## Cohérencde de l'intégrité
nrow(vaccine)
n_distinct(vaccine$ID_sujet)

## Censure_haute par temps
vaccine %>% count(Titre_AC_28j_statut)
vaccine %>% count(Titre_AC_3mois_statut)
vaccine %>% count(Titre_AC_7mois_mesure1_statut)

## Titre_AC moyen :  croissant dans le temps (cas "Normal" uniquement)
vaccine %>% filter(Titre_AC_28j_statut == "Normal") %>% 
  summarise(moyenne = mean(Titre_AC_28j_valeur, na.rm = TRUE))

vaccine %>% filter(Titre_AC_3mois_statut == "Normal") %>% 
  summarise(moyenne = mean(Titre_AC_3mois_valeur, na.rm = TRUE))

vaccine %>% filter(Titre_AC_7mois_mesure1_statut == "Normal") %>% 
  summarise(moyenne = mean(Titre_AC_7mois_mesure1_valeur, na.rm = TRUE))

## Cohérence chronologique des dates
sum(vaccine$Date_dose2 < vaccine$Date_dose1, na.rm = TRUE)

## Plage d'âge plausible
min(vaccine$Age, na.rm = TRUE)
max(vaccine$Age, na.rm = TRUE)

## Cohérence Titre_tronque_derivee / Statut_evenement
vaccine %>% filter(Titre_tronque_derivee == 120 & Statut_evenement == 0) %>% nrow()



# Enregistrement de la base de données nettoyées

write.csv(vaccine, "data/clean/vaccine_clean_r.csv", row.names = FALSE, na = "")
