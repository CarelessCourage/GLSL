import colors from 'tailwindcss/colors';
export default {
  theme: {
    colors: {
      transparent: 'transparent',
      current: 'currentColor',

      foreground: 'var(--foreground)',
      background: 'var(--background)',
      accent: 'var(--accent)',
      inherit: 'inherit',

      black: colors.black,
      white: colors.white,

      'foreground-10': 'var(--foreground-10)',
      'foreground-20': 'var(--foreground-20)',

      'background-10': 'var(--background-10)',
      'background-20': 'var(--background-20)',

      'accent-10': 'var(--accent-10)',
      'accent-20': 'var(--accent-20)',
      'accent-contrast': 'var(--accent-contrast)',

      success: 'var(--success)',
      'success-10': 'var(--success-10)',
      'success-20': 'var(--success-20)',
      'success-contrast': 'var(--success-contrast)',

      link: 'var(--link)',
      'link-10': 'var(--link-10)',
      'link-20': 'var(--link-20)',
      'link-contrast': 'var(--link-contrast)',

      warning: 'var(--warning)',
      'warning-10': 'var(--warning-10)',
      'warning-20': 'var(--warning-20)',
      'warning-contrast': 'var(--warning-contrast)',
    },
  },
};
