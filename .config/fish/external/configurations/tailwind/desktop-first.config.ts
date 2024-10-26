import type { Config } from "tailwindcss";

export default {
    content: ["src/**/*.tsx"],
    plugins: [],
    theme: {
        extends: {},
        screens: {
            "2xl": { max: "1535px" },
            xl: { max: "1279px" },
            lg: { max: "1023px" },
            md: { max: "767px" },
            sm: { max: "639px" },
        },
    },
} satisfies Config;
