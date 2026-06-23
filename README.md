# Homebrew aka `brew` formula

Currently this repo has a formula for the upstream [lepus2589/accelerate-lapack](https://github.com/lepus2589/accelerate-lapack)

## How do I install these formulae?

`brew install ekrich/tools/<formula>`

Or `brew tap ekrich/tools` and then `brew install <formula>`.

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "ekrich/tools"
brew "<formula>"
```

## Installing `accelerate-lapacke`

The formula to install is `accelerate-lapack`. The reason for this formula is to make it easy to use the [Scala Native slapack library](https://github.com/ekrich/slapack). macOS does not have build in support for `lapacke` but we want to support that C API so it will work for Linux as well. This library shim links to the build in Accelerate Framework for high performance math on macOS.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).

## Licence

This `brew` `tap` repo is licensed via [Apache License Version 2](LICENSE) but the `lepus2589/accelerate-lapack` repo is licensed using the MIT license
