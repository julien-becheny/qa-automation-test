*** Settings ***
Documentation       Ressources communes : configuration du navigateur (Browser Library / Playwright)
...                 et keywords de Suite Setup / Teardown réutilisables par toutes les suites.

Library             Browser


*** Variables ***
${BASE_URL}         https://www.saucedemo.com
${BROWSER}          chromium
${HEADLESS}         False


*** Keywords ***
Open Test Browser
    [Documentation]    Ouvre un navigateur neuf, un contexte isolé et une page sur ${BASE_URL}.
    ...                Appelé en Suite Setup.
    New Browser    browser=${BROWSER}    headless=${HEADLESS}
    New Context    viewport={'width': 1280, 'height': 800}
    New Page    ${BASE_URL}

Close Test Browser
    [Documentation]    Ferme proprement le navigateur. Appelé en Suite Teardown.
    Close Browser    ALL

Take Screenshot On Failure
    [Documentation]    À utiliser en [Teardown] de test : capture l'écran uniquement si le test a échoué.
    Run Keyword If Test Failed    Take Screenshot    fullPage=True
