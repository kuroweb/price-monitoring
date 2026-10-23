import eslintReact from '@eslint-react/eslint-plugin'
import next from '@next/eslint-plugin-next'
import stylistic from '@stylistic/eslint-plugin'
import { defineConfig, globalIgnores } from 'eslint/config'
import eslintConfigPrettier from 'eslint-config-prettier'
import { importX } from 'eslint-plugin-import-x'
import jsxA11y from 'eslint-plugin-jsx-a11y-x'
import globals from 'globals'
import tseslint from 'typescript-eslint'

export default defineConfig([
  globalIgnores(['coverage/**', '.next/**', 'out/**', 'build/**', 'next-env.d.ts']),
  {
    files: ['**/*.{js,jsx,mjs,cjs,ts,tsx,mts,cts}'],
    extends: [
      next.configs['core-web-vitals'],
      eslintReact.configs.recommended,
      jsxA11y.configs.recommended,
    ],
    plugins: {
      '@stylistic': stylistic,
      'import-x': importX,
    },
    languageOptions: {
      globals: { ...globals.browser, ...globals.node },
    },
    settings: {
      'jsx-a11y-x': { components: { Image: 'img', NextImage: 'img' } },
    },
    rules: {
      '@next/next/no-img-element': 'off',
      'import-x/no-anonymous-default-export': 'warn',
      'import-x/order': [
        'error',
        {
          groups: ['builtin', 'external', 'parent', 'sibling', 'index', 'object', 'type'],
          pathGroups: [
            {
              pattern: '{react,react-dom/**,react-router-dom}',
              group: 'builtin',
              position: 'before',
            },
            {
              pattern: '@/**',
              group: 'parent',
              position: 'before',
            },
          ],
          pathGroupsExcludedImportTypes: ['builtin'],
          alphabetize: { order: 'asc' },
          'newlines-between': 'always',
        },
      ],
      'object-shorthand': 'error',
      '@stylistic/jsx-curly-brace-presence': 'error',
      '@stylistic/jsx-self-closing-comp': ['error', { component: true, html: false }],
    },
  },
  {
    files: ['**/*.{js,jsx,mjs,cjs}'],
    rules: { 'no-undef': 'error' },
  },
  {
    files: ['**/*.{ts,tsx,mts,cts}'],
    extends: [tseslint.configs.recommended, eslintReact.configs['recommended-typescript']],
    rules: {
      '@typescript-eslint/consistent-type-imports': [
        'error',
        { prefer: 'type-imports', fixStyle: 'separate-type-imports' },
      ],
      '@typescript-eslint/no-unused-vars': [
        'error',
        {
          vars: 'all',
          varsIgnorePattern: '^_',
          args: 'after-used',
          argsIgnorePattern: '^_',
        },
      ],
    },
  },
  eslintConfigPrettier,
])
