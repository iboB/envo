@echo off
for /f "delims=" %%A in ('ruby scratch.rb %*') do %%A
