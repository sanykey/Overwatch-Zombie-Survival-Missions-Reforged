#!mainFile "../main.opy"

#!define createNumbers() __script__("create numbers.js")

globalvar numbersList = compressed([
    createNumbers()
])
