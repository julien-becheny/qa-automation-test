*** Settings ***
Documentation       Page Object : page de connexion (https://www.saucedemo.com).
...                 Regroupe les locators et les keywords métier de l'écran de login.

Library             Browser


*** Variables ***
${LOGIN_USERNAME_INPUT}     [data-test="username"]
${LOGIN_PASSWORD_INPUT}     [data-test="password"]
${LOGIN_SUBMIT_BUTTON}      [data-test="login-button"]


*** Keywords ***
Log In
    [Documentation]    Saisit l'identifiant et le mot de passe puis valide le formulaire de connexion.
    [Arguments]    ${username}    ${password}
    Fill Text    ${LOGIN_USERNAME_INPUT}    ${username}
    Fill Text    ${LOGIN_PASSWORD_INPUT}    ${password}
    Click    ${LOGIN_SUBMIT_BUTTON}
