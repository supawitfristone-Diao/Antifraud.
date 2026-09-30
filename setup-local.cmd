@echo off
cd /d "%~dp0"
echo [1/4] Installing packages...
call npm install
if errorlevel 1 goto error
echo [2/4] Building local configuration...
call npm run build
if errorlevel 1 goto error
echo [3/4] Creating local database...
node --import ./scripts/sites-env.mjs ./node_modules/wrangler/bin/wrangler.js d1 execute DB --local --config dist/server/wrangler.json --persist-to .wrangler/state --file drizzle/0000_harsh_squadron_supreme.sql
if errorlevel 1 goto error
echo [4/4] Creating private first-admin code...
node scripts/local-admin-code.mjs
if errorlevel 1 goto error
echo Run npm run dev in the VS Code terminal.
pause
exit /b 0
:error
echo Setup failed. Take a screenshot of this window and send it to me.
pause
exit /b 1
