*** Settings ***
Documentation       Page Object : page d'inventaire (liste des produits) après connexion.

Library             Browser


*** Variables ***
${INVENTORY_CONTAINER}      [data-test="inventory-container"]
${CART_LINK}                [data-test="shopping-cart-link"]


*** Keywords ***
Verify Inventory Page Is Displayed
    [Documentation]    Confirme que la connexion a réussi : le conteneur produits est visible.
    Wait For Elements State    ${INVENTORY_CONTAINER}    visible

Add Product To Cart
    [Documentation]    Ajoute au panier le produit identifié par son identifiant data-test
    ...                (ex: "sauce-labs-backpack").
    [Arguments]    ${product_id}
    Click    [data-test="add-to-cart-${product_id}"]

Add Products To Cart
    [Documentation]    Ajoute au panier chacun des produits passés en argument (identifiants data-test).
    [Arguments]    @{product_ids}
    FOR    ${product_id}    IN    @{product_ids}
        Add Product To Cart    ${product_id}
    END

Open Cart
    [Documentation]    Navigue vers la page du panier.
    Click    ${CART_LINK}
