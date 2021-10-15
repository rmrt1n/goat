module.exports = {
  root: true,
  extends: ['eslint:recommended', 'prettier'],
  plugins: ['svelte3'],
  overrides: [{ files: ['*.svelte'], processor: 'svelte3/svelte3' }],
  parserOptions: {
    sourceType: 'module',
    ecmaVersion: 2020, // https://github.com/vitejs/vite/discussions/3501
  },
  env: {
    browser: true,
    es2017: true,
    node: true,
  },
  rules: {
    'no-unused-vars': [
      'error',
      {
        args: 'none',
        ignoreRestSiblings: true,
      },
    ],
  },
};