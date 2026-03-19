const {
    defineConfig,
    globalIgnores,
} = require("eslint/config");

const globals = require("globals");
const tsParser = require("@typescript-eslint/parser");
const typescriptEslint = require("@typescript-eslint/eslint-plugin");
const js = require("@eslint/js");

const {
    FlatCompat,
} = require("@eslint/eslintrc");

const compat = new FlatCompat({
    baseDirectory: __dirname,
    recommendedConfig: js.configs.recommended,
    allConfig: js.configs.all
});

module.exports = defineConfig([{
    languageOptions: {
        globals: {
            ...globals.node,
        },

        parser: tsParser,
        "ecmaVersion": 2020,
        parserOptions: {},
    },

    plugins: {
        "@typescript-eslint": typescriptEslint,
    },

    extends: compat.extends("eslint:recommended", "plugin:@typescript-eslint/recommended"),

    rules: {
        "@typescript-eslint/no-explicit-any": "off",
        "@typescript-eslint/explicit-module-boundary-types": "off",
    },
}, globalIgnores(["lib/**/*", "node_modules/**/*"]), {
    files: ["**/*.spec.*"],

    languageOptions: {
        globals: {
            ...globals.mocha,
        },
    },

    rules: {},
}]);
