@echo off
chcp 65001 > nul 2>&1

:loop

REM 시간 확인
set TimeString=%TIME%
set Hour=%TimeString:~0,2%
set Minute=%TimeString:~3,2%

REM 시간과 분을 두 자리로 고정
if "%Hour:~0,1%"==" " set Hour=0%Hour:~1,1%
if "%Minute:~0,1%"==" " set Minute=0%Minute:~1,1%
set /a total=%Hour%*60+%Minute%

if %total% gtr 679 (
  if %total% lss 811 (

  echo 현재 시간 = %Hour%:%Minute%
    REM Java 프로세스가 실행 중인지 확인
    tasklist | findstr "java.exe" >nul
    if errorlevel 1 (
      cd C:\Users\user\Documents
      start java -jar -Dspring.config.location=file:C:\Users\user\Documents\application.yml bridge.jar < NUL
      echo 서버를 실행합니다.
    ) else (
      echo 서버가 이미 실행 중입니다.
    )

    REM cvediart 프로세스가 실행 중인지 확인
    tasklist | findstr "cvediart.exe" >nul
    if errorlevel 1 (
      cd C:\Users\user\Documents\Cvedia-5.8
      start CVEDIA-RT
      echo Cvedia 서버를 실행합니다.
    ) else (
      echo Cvedia 서버가 이미 실행 중입니다.
    )

    timeout /t 20 /nobreak >nul
    goto loop
  ) else (
    echo 운영시간이 아닙니다.
    goto killprocess
  )
) else (
  echo 운영시간이 아닙니다.
  goto killprocess
)
echo 운영시간 = 11:20 ~ 13:30
echo 현재 시간 = %Hour%:%Minute%

:killprocess
REM 시간 범위 외에는 프로세스 종료
tasklist /fi "imagename eq java.exe" | findstr java.exe >nul
if not errorlevel 1 (
  taskkill /f /im java.exe /t
  echo Java 프로세스 종료
) else (
  echo Java 프로세스가 실행 중이 아닙니다.
)

tasklist /fi "imagename eq cvediart.exe" | findstr cvediart.exe >nul
if not errorlevel 1 (
  taskkill /f /im cvediart.exe /t
  echo Cvedia-RT 프로세스 종료
) else (
  echo Cvedia-RT 프로세스가 실행 중이 아닙니다.
)

timeout /t 20 /nobreak >nul
goto loop