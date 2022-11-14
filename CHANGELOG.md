# Changelog

This project adheres to [Semantic Versioning](http://semver.org)

## [0.5.4] - 2022-11-14
Fix:
  - Config / commands file

## [0.4.3] - 2021-02-01
Fix:
 - Do not erase the app locales files.

## [0.4.2] - 2020-08-28
Fix:
 - Do not inject the locales files directly in the load path but add them instead.

## [0.4.1] - 2019-12-04
Improvement:
- Generate the folder of a spec, if not already existing

## [0.4.0] - 2019-11-29
Features:
 - Add `add`, `commit` and `amend` commands to the cli

## [0.3.0] - 2019-09-30
Improvement:
- Reduce RSpec runner verbosity
- Allow configuring the base branch

Fix:
 - Add `--version` to the CLI

## [0.2.2] - 2019-01-05
Improvements:
 - Removing thor
 - Using custom CLI to handle multiple commands

## [0.2.1] - 2018-12-31
Improvement:
 - Deprecating rainbow to install pronto and pronto Rubocop

Notes:
This version of SafePusher use rainbow 2.2, that can be incompatible with
the latest version of React On Rails (for instance).
Previous versions of the gem use rainbow 3.0.

## [0.2.0] - 2018-12-31
Feature:
 - Improve commands

## [0.1.3] - 2018-12-20
Bugfix:
 - Do not take into account deleted files for rspec testing

## [0.1.2] - 2018-12-18
Bugfix:
 - Remove dev dependency `pronto` to update `thor` version to 20.0

## [0.1.1] - 2018-12-05
Add documentation, specify development dependencies

## [0.1.0] - 2018-11-12
First release :tada:
