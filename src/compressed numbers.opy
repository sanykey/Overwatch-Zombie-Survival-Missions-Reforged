#!mainFile "../main.opy"

#!define createNumbers() __script__("create numbers.js")

# Shared compressed numeric tables.
globalvar numbersList = compressed([ # Shared compressed numeric lookup data for stat tables, spawn weights and menu vote IDs.
    createNumbers()
])
