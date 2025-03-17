@echo off
set driversPath=\\172.17.1.30\drivers
pnputil /add-driver %driversPath%\*.inf /subdirs /install
