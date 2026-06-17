*** Settings ***
Documentation       Page Object : tunnel de commande (informations client, récapitulatif, confirmation).

Library             Browser


*** Variables ***
${CHECKOUT_FIRSTNAME_INPUT}     [data-test="firstName"]
${CHECKOUT_LASTNAME_INPUT}      [data-test="lastName"]
${CHECKOUT_POSTALCODE_INPUT}    [data-test="postalCode"]
${CHECKOUT_CONTINUE_BUTTON}     [data-test="continue"]
${CHECKOUT_FINISH_BUTTON}       [data-test="finish"]
${CHECKOUT_CONFIRMATION}        [data-test="complete-header"]


*** Keywords ***
Fill Shipping Information
    [Documentation]    Saisit les informations client puis valide l'étape.
    [Arguments]    ${prenom}    ${nom}    ${code_postal}
    Fill Text    ${CHECKOUT_FIRSTNAME_INPUT}    ${prenom}
    Fill Text    ${CHECKOUT_LASTNAME_INPUT}    ${nom}
    Fill Text    ${CHECKOUT_POSTALCODE_INPUT}    ${code_postal}
    Click    ${CHECKOUT_CONTINUE_BUTTON}

Finish Order
    [Documentation]    Valide définitivement la commande sur l'étape de récapitulatif.
    Click    ${CHECKOUT_FINISH_BUTTON}

Verify Order Confirmation
    [Documentation]    Vérifie que le message de confirmation attendu est affiché.
    [Arguments]    ${message_attendu}
    Get Text    ${CHECKOUT_CONFIRMATION}    ==    ${message_attendu}
