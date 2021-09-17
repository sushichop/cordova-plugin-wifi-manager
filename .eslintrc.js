module.exports = {
  globals: {
    cordova: false,
  },
  env: {
    node: true,
    es6: true,
    browser: true,
    jasmine: true,
  },
  extends: ['eslint:recommended', 'prettier'],
};
