# Release policy (isaac formula)

## Immutable tags

Published `v*` tags on [isaac-foundation](https://github.com/slagyr/isaac-foundation)
are **immutable**. Never force-move a tag that has been released. Ship fixes as
`v0.1.2`, `v0.1.3`, and so on.

The stable formula pins `url` + `sha256` to GitHub's auto-generated tag tarball.
Moving a published tag invalidates the checksum and breaks `brew install`.

## Auto-bump

When isaac-foundation publishes a GitHub Release, the foundation release
workflow dispatches to this tap. The `bump-isaac` workflow runs
`scripts/bump-isaac-formula.sh` to update `Formula/isaac.rb` (`url`, `version`,
`sha256`) and push to `main`.

Trigger: **GitHub Release published** on isaac-foundation (not every tag push).

Manual bump:

```sh
./scripts/bump-isaac-formula.sh v0.1.2
```

Or run the `bump isaac formula` workflow with a tag input.

## Dev installs

`brew install --HEAD slagyr/tap/isaac` tracks `main` for bleeding-edge use.
Stable installs use the latest released tag.

## CI

`tests.yml` runs a real `brew install slagyr/tap/isaac` from the tap (not a
smoke replay), so sha256 drift is caught before users hit it.