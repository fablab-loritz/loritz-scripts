@echo off
set driversPath=\\serveur\drivers
pnputil /add-driver %driversPath%\*.inf /subdirs /install
