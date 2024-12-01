import std/strformat

const
  termBlack* = "\e[30m"
  termRed* = "\e[31m"
  termGreen* = "\e[32m"
  termYellow* = "\e[33m"
  termBlue* = "\e[34m"
  termMagenta* = "\e[35m"
  termCyan* = "\e[36m"
  termWhite* = "\e[37m"
  termBgBlack* = "\e[40m"
  termBgRed* = "\e[41m"
  termBgGreen* = "\e[42m"
  termBgYellow* = "\e[43m"
  termBgBlue* = "\e[44m"
  termBgMagenta* = "\e[45m"
  termBgCyan* = "\e[46m"
  termBgWhite* = "\e[47m"
  termClear* = "\e[0m"
  termBold* = "\e[1m"
  termItalic* = "\e[3m"
  termUnderline* = "\e[4m"
  termBlink* = "\e[5m"
  termNegative* = "\e[7m"
  termStrikethrough* = "\e[9m"
  termEnd* = "\e[0m"
  termGray* = "\e[90m"

proc success*(message: string) = 
    echo(fmt"{termGray}[{termEnd}{termGreen}+{termEnd}{termGray}]{termEnd} {message}")

proc failure*(message: string) =
    echo(fmt"{termGray}[{termEnd}{termRed}-{termEnd}{termGray}]{termEnd} {message}")