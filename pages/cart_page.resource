*** Settings ***
Documentation       Page Object : page du panier (récapitulatif des articles sélectionnés).

Library             Browser


*** Variables ***
${CHECKOUT_BUTTON}      [data-test="checkout"]


*** Keywords ***
Verify Cart Contains Product With Price
    [Documentation]    Vérifie qu'un produit figure dans le panier avec le prix attendu.
    ...                Le sélecteur cible la ligne article contenant le nom du produit, puis son
    ...                prix (sélecteur en cascade Playwright, robuste à l'ordre des produits).
    ...                La présence du produit est implicitement vérifiée par la correspondance du nom.
    [Arguments]    ${nom_produit}    ${prix_attendu}
    Get Text
    ...    [data-test="inventory-item"]:has-text("${nom_produit}") >> [data-test="inventory-item-price"]
    ...    ==    ${prix_attendu}

Proceed To Checkout
    [Documentation]    Lance le tunnel de commande depuis le panier.
    Click    ${CHECKOUT_BUTTON}
