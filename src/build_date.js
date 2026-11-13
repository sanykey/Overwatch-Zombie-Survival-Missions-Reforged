// Evaluated by OverPy at compile time, using the build computer's local date.
const buildDate = new Date();
const year = buildDate.getFullYear();
const month = String(buildDate.getMonth() + 1).padStart(2, "0");
const day = String(buildDate.getDate()).padStart(2, "0");

// Return an OverPy string literal, not a runtime Workshop expression.
JSON.stringify(`${year}-${month}-${day}`)
