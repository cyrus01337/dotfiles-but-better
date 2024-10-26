import javascript from "@eslint/js";
import prettier from "eslint-config-prettier";
import typescript from "typescript-eslint";

export default typescript.config(
    javascript.configs.recommended,
    prettier,
    ...typescript.configs.recommended,
    ...typescript.configs.stylistic,
    {
        ignores: ["dist/", "node_modules/"],
    },
    {
        rules: {
            "@typescript-eslint/ban-ts-comment": "off",
            "@typescript-eslint/no-empty-function": "off",
            "@typescript-eslint/no-unsafe-assignment": "off",
            "@typescript-eslint/no-unsafe-call": "off",
            "@typescript-eslint/no-unsafe-member-access": "off",
            "@typescript-eslint/no-unused-vars": "error",
            "@typescript-eslint/triple-slash-reference": "off",
            "import/no-anonymous-default-export": "off",
            "no-console": "warn",
            "no-control-regex": "off",
        },
    },
);
