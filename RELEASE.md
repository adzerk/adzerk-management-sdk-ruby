# Release Guide — `adzerk-management-sdk-ruby`

> Maintenance note: keep this file current. When you change how the gem is built or
> published, update the related section in the same PR.

## Overview

`adzerk-management-sdk-ruby` is the Ruby client for the Kevel (Adzerk) management API. It is
published to RubyGems as the gem `adzerk`. Releases are PR-driven. A PR changes the version in
`lib/adzerk/version.rb`. When that PR merges to `master`, GitHub Actions publishes the gem.

GitHub Actions never pushes to `master`. It pushes only the release tag.

## Releasables

### `adzerk` gem
- **Type**: library (Ruby gem)
- **Path**: source in `lib/`, gem definition in `adzerk.gemspec`
- **Artifact**: a gem version on RubyGems (https://rubygems.org/gems/adzerk). The version is
  `Adzerk::VERSION` in `lib/adzerk/version.rb`.
- **Version format**: two parts, `X.Y` (for example, `0.31`). Tags use the same name, with no `v` prefix.
- **Consumers**: Ruby applications that install `adzerk` from RubyGems.

## Environments

- **Registry**: RubyGems (public). There is no staging registry.
- **Promotion**: no multi-stage promotion. A version change that merges to `master` is a release.
- **Source of truth**: the `master` branch. Each release has a git tag `<version>` and a GitHub Release.

## Deployment

1. On an up-to-date `master`, run `ruby scripts/create-release.rb` (it asks for the type), or
   `ruby scripts/create-release.rb minor|major`.
   - `minor`: bug fixes, dependency updates and new features (`0.31` → `0.32`).
   - `major`: breaking changes (`0.31` → `1.0`).
2. Review the changes with `git diff`. The script changes these files:
   - `lib/adzerk/version.rb` and `Gemfile.lock` get the new version.
   - `CHANGELOG.md` gets a `## [<version>] - <date>` entry. The entry has the notes from the
     `## Unreleased` section and a list of the PRs that merged after the last tag.
3. Edit the `CHANGELOG.md` entry, if necessary. The script does not commit or tag.
4. Make a branch, commit the changes and open a PR to `master`.
5. Merge the PR. The Publish Gem workflow publishes the gem, tags the version and creates
   the GitHub Release.

Do not change the version by hand. The Release Check workflow fails a PR that changes the
version without the matching `Gemfile.lock` and `CHANGELOG.md` changes.

To add release notes before a release, add them to a `## Unreleased` section at the top of
`CHANGELOG.md`. The next release moves them into its entry.

### Scripts

- `scripts/create-release.rb` — bumps the version and adds the `CHANGELOG.md` entry. Plain
  Ruby, no gems needed.
- `scripts/check-release.rb <base-ref>` (for example, `origin/master`) — if the version
  differs from the merge base with `<base-ref>`, it checks these items:
  - The new version is a valid `X.Y` version and is higher than the base version.
  - `Gemfile.lock` has the new version.
  - `CHANGELOG.md` starts with one non-empty `## [<version>]` entry.

  It compares with the merge base, so a branch that is behind `master` does not fail.
- `bundle exec rake build` — builds `pkg/adzerk-<version>.gem`.

### GitHub Actions workflows

- `.github/workflows/publish.yml` (Publish Gem) — trigger: push to `master` that changes
  `lib/adzerk/version.rb`.
  - The `check-version` job reads the version. If the tag `<version>` exists, the version
    is already released and the workflow stops. This makes re-runs safe.
  - The `publish` job builds the gem and pushes it to RubyGems. Then it pushes the tag
    `<version>` and creates a GitHub Release from the `CHANGELOG.md` entry.
- `.github/workflows/release-check.yml` (Release Check) — trigger: each PR to `master`. It has
  no `paths` filter, so it can be a required check. It runs `scripts/check-release.rb`.
  - It passes at once when the version is unchanged.
  - For a valid version bump, it adds a PR comment that says which version the merge releases.
  - It deletes that comment when the PR no longer has a valid version bump.

  It blocks the merge only when "release-check" is a required status check for `master`.

### Access and prerequisites

- `secrets.RUBYGEMS_API_KEY` — the RubyGems API key that `gem push` uses (as `GEM_HOST_API_KEY`).
- `secrets.GITHUB_TOKEN` — pushes the tag and creates the GitHub Release (`contents: write`).
  The Release Check workflow uses it with `pull-requests: write` to comment on PRs.

## Rollback and recovery

- You cannot change a published gem version. To fix a bad release, release a new version.
- To remove a bad version from RubyGems, use `gem yank adzerk -v <version>` (needs a RubyGems
  owner). Use this only for a broken or unsafe release.
- If the Publish Gem workflow fails before `gem push`, fix the cause and re-run the workflow.
- If it fails after `gem push`, the gem is on RubyGems but the tag or the GitHub Release can
  be missing. Create them by hand from the merge commit on `master`:
  `git tag -a <version> -m "Release <version>" <commit>`, `git push origin <version>`, then
  create the GitHub Release from the tag. Do not re-run the workflow, because the second
  `gem push` of the same version fails.

## Observability

- **Status tracking**: the GitHub Actions run of Publish Gem. A successful run makes the
  tag `<version>`, a GitHub Release and the version on RubyGems.
- **Metrics, monitors, runbooks**: none.

## References

- `CHANGELOG.md` — release notes per version.
- `scripts/create-release.rb`, `scripts/check-release.rb` — release tooling.
- `.github/workflows/publish.yml`, `.github/workflows/release-check.yml` — CI/CD.
- RubyGems: https://rubygems.org/gems/adzerk
- Repository: https://github.com/adzerk/adzerk-management-sdk-ruby
