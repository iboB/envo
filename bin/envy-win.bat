@echo off
:: we can't use `setlocal` here, since we actually WANT to leak
:: after all, this script is supposed to set env vars
:: however in order to get the result of `run g` we need to assign it to
:: a local var... which we must leak :(
:: so... just choose the a very unlikely duplicate var name
for /f "delims=" %%A in ('ruby bin/envy_run g') do set _ENVY_PLD=%%A

ruby bin/envy_run pld "%_ENVY_PLD%" %*
call "%_ENVY_PLD%"
del "%_ENVY_PLD%"
