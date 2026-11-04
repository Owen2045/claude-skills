// SessionStart: plain-text stdout is added to Claude's context.
const fs = require("fs");
const path = require("path");
process.stdout.write(fs.readFileSync(path.join(__dirname, "rules.md"), "utf8"));
