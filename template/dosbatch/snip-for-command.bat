for /f "usebackq tokens=1 delims==" %%i in (`{{_cursor_}}`) do (
    echo %%i
)
