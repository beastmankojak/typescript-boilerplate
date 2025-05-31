import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';
import nodelint from 'eslint-plugin-n';

export default tseslint.config(
  eslint.configs.recommended,
  tseslint.configs.recommended,
  nodelint.configs['flat/recommended'],
  {
    rules: { 'n/no-unpublished-import': ['error', { ignoreTypeImport: true }] },
  },
);
