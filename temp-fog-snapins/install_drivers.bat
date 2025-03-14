@echo off
set driversPath=\\10.10.10.10\drivers
pnputil /add-driver %driversPath%\*.inf /subdirs /install
