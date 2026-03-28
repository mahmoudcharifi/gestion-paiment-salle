# Gestion Paiement Salle

Application mobile Flutter de gestion des adhérents et des paiements pour une salle de sport de combat.

## Présentation

Cette application a été développée pour faciliter la gestion quotidienne d’une salle de sport spécialisée dans les sports de combat.  
Elle permet à l’administrateur de gérer les adhérents, leurs abonnements, leurs paiements, leurs sports pratiqués, ainsi que leur historique complet.

L’objectif principal est de proposer une solution simple, rapide et moderne pour :

- enregistrer les adhérents
- suivre les paiements
- connaître le statut de chaque abonnement
- rechercher rapidement un membre
- générer des fiches PDF
- utiliser des QR codes pour accéder rapidement aux informations d’un adhérent

---

## Fonctionnalités principales

### Gestion des adhérents
- ajout d’un adhérent
- modification des informations d’un adhérent
- suppression avec confirmation
- ajout d’une photo de profil
- affichage détaillé de la fiche adhérent

### Gestion des sports
- ajout des sports par l’administrateur
- modification des sports
- suppression des sports
- possibilité d’attribuer un ou plusieurs sports à un adhérent

### Gestion des paiements
- ajout d’un paiement
- historique des paiements par adhérent
- suppression d’un paiement avec confirmation
- suivi des périodes d’abonnement
- statuts de paiement

### Statuts automatiques
L’application calcule automatiquement le statut de l’adhérent selon la date de fin d’abonnement :
- Actif
- Expire bientôt
- Expiré
- Aucun paiement

### Recherche et filtres
- recherche par nom, prénom, téléphone, CIN, QR code ou sport
- filtre par sport
- filtre par statut

### QR Code
- génération d’un QR code unique pour chaque adhérent
- affichage du QR code dans la fiche adhérent
- scanner QR pour accéder rapidement à la fiche d’un membre

### PDF
- génération de la fiche adhérent en PDF
- partage du PDF
- génération d’un reçu PDF pour chaque paiement
- partage du reçu de paiement

### Interface
- dashboard administrateur
- design moderne et clair
- mode clair / mode sombre
- interface adaptée à Android et iOS

