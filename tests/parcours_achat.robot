*** Settings ***
Documentation       Parcours utilisateur de bout en bout sur saucedemo.com :
...                 connexion → ajout de deux produits au panier → vérification des prix →
...                 tunnel de commande → confirmation. Structure Page Object Model.

Library             Browser
Resource            ../resources/common.resource
Resource            ../pages/login_page.resource
Resource            ../pages/inventory_page.resource
Resource            ../pages/cart_page.resource
Resource            ../pages/checkout_page.resource

Suite Setup         Open Test Browser
Suite Teardown      Close Test Browser
Test Teardown       Take Screenshot On Failure


*** Variables ***
${UTILISATEUR_VALIDE}       standard_user
${MOT_DE_PASSE_VALIDE}      secret_sauce

${PRODUIT_1_ID}             sauce-labs-backpack
${PRODUIT_1_LIBELLE}        Sauce Labs Backpack
${PRODUIT_1_PRIX}           $29.99

${PRODUIT_2_ID}             sauce-labs-bike-light
${PRODUIT_2_LIBELLE}        Sauce Labs Bike Light
${PRODUIT_2_PRIX}           $9.99


*** Test Cases ***
Parcours De Commande Complet
    [Documentation]    Cas nominal : un utilisateur valide se connecte, ajoute deux produits au
    ...                panier, vérifie leur présence et leur prix, renseigne les informations de
    ...                livraison et valide la commande jusqu'au message de confirmation.
    [Tags]    e2e    achat    smoke
    Log In    ${UTILISATEUR_VALIDE}    ${MOT_DE_PASSE_VALIDE}
    Verify Inventory Page Is Displayed
    Add Products To Cart    ${PRODUIT_1_ID}    ${PRODUIT_2_ID}
    Open Cart
    Verify Cart Contains Product With Price    ${PRODUIT_1_LIBELLE}    ${PRODUIT_1_PRIX}
    Verify Cart Contains Product With Price    ${PRODUIT_2_LIBELLE}    ${PRODUIT_2_PRIX}
    Proceed To Checkout
    Fill Shipping Information    Julien    Becheny    75001
    Finish Order
    Verify Order Confirmation    Thank you for your order!
