module.exports = {
  root: true,
  env: {
    es6: true,
    node: true,
  },
  extends: [
    "eslint:recommended",
    "plugin:import/errors",
    "plugin:import/warnings",
    "plugin:import/typescript",
    "google",
  ],
  parser: "@typescript-eslint/parser",
  parserOptions: {
    project: ["functions/tsconfig.json", "functions/tsconfig.dev.json"],
    sourceType: "module",
  },
  ignorePatterns: [
    "/lib/**/*", // Ignore built files.
  ],
  plugins: ["@typescript-eslint", "import"],
  rules: {
    "quote-props": ["error", "as-needed"],
    quotes: ["error", "double"],
    "import/no-unresolved": 0,
    indent: ["error", 2],
    "object-curly-spacing": ["warn", "always"],
    "no-unused-vars": "off",
    "@typescript-eslint/no-unused-vars": "warn",
    "require-jsdoc": [
      "error",
      {
        require: {
          FunctionDeclaration: false,
          MethodDefinition: false,
          ClassDeclaration: false,
          ArrowFunctionExpression: false,
          FunctionExpression: false,
        },
      },
    ],
  },
};
