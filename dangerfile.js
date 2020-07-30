import { warn, danger } from 'danger';

const modifiedFiles = danger.git.modified_files;
const createdFiles = danger.git.created_files;
const changedFiles = [...modifiedFiles, ...createdFiles];

const hasChangedNativeSourceFiles = danger.git.fileMatch('src/**/*').edited;
const hasChangedJavaScriptSourceFiles = danger.git.fileMatch('www/**/*.js').edited;
const hasChangedTypeScriptSourceFiles = danger.git.fileMatch('types/**/*.ts').edited;
const hasChangedMetaFiles = danger.git.fileMatch('plugin.xml').edited;
const hasChangedFiles =
  hasChangedNativeSourceFiles ||
  hasChangedJavaScriptSourceFiles ||
  hasChangedTypeScriptSourceFiles ||
  hasChangedMetaFiles;

// Make it more obvious that a PR is a work in progress and shouldn't be merged yet.
if (danger.github.pr.title.includes('WIP')) {
  warn('Pull Request is marked as Work in Progress');
}

// Warn when there is a big PR.
const diffLines = Math.max(danger.github.pr.additions, danger.github.pr.deletions);
if (diffLines > 300) {
  warn(`
  Pull Request size seems relatively big. 
  If this PR contains multiple changes, consider splitting it into separate PRs for easier reviews.`);
}

// Changelog entries are required for changed files.
const isTrivial = (danger.github.pr.title + danger.github.pr.body).includes('#trivial');
const hasChangelog = changedFiles.includes('CHANGELOG.md');
if (hasChangedFiles && !isTrivial && !hasChangelog) {
  warn(`
  Any changes to code should be reflected in the CHANGELOG.
  Please consider adding a note there about your change.
  `);
}

// Keep lockfile up to date.
const packageChanged = danger.git.modified_files.includes('package.json');
const lockfileChanged = danger.git.modified_files.includes('package-lock.json');
if (packageChanged && !lockfileChanged) {
  warn(`
  Changes were made to package.json, but not to package-lock.json.
  Perhaps you need to run <i>npm install</i>?
  `);
}
