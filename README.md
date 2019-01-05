# Senju

Listing your issues.

## Installation

    $ gem install senju

## Configuration

Making `~/.senju` directory.

    $ mkdir ~/.senju

### Credentials

Edit `~/.senju/credentials`.

```
<profile name>:
  <source name>: <token>
```

ex:
```
github1:
  github: aabbccddeeffgg......
github2:
  github: ccddeeffgghhii......
gitlab1:
  gitlab: 123412341234......
```

### Projects

Edit `~/.senju/projects`.

```
<organization>:
  <repository>:
    <profile name>:
```

ex:

```
myun2:
  senju:
    github1:
```

## Usage

    $ senju

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/senju.
