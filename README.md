# GitChain

GitChain helps solve the feature branch dependency problem, in which you have several branches lined up, one depndent on the next. When one or more of the upstream branches changes (because of a rebase on trunk with merge conflicts, or some other last minute fix), it leaves you in the unfortunate position of having to resolve those conflicts, and the cascade of new ones they cause, all the way down your dependency chain. At best it's cumbersome, at worst it can spiral out of control.


This is particularly a problem for large projects with a slow and strict release cycle. A feature branch might be worked on for a week or so, and during development you discover a refactor or enhancement that ought not to be blocked by your current work so you break it up into it's own branch. However, you would like to use that change in your current work, so you base your branch off of it. Anytime that refactor branch needs to change, you run into the possiblity of having the chained dependency problem.

The appropriate solution is to use `git rebase --onto` on each branch. However, this requires you to keep track of the sha from which each branch originates, which is itself cumbersome. Git Chain aims to solve this by keeping track of those shas, and running the appropriate git commands on your behalf.

## Installation

Add this line to your application's Gemfile under the development section:

```ruby
gem 'git_chain'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install git_chain

Then, you must add .git_chains to your .gitignore or you're gonna have a bad time.

## Usage

### Initialize a chain

```ruby
git chain add <parent_branch> [current_base]
```

This command creates or updates a chain with the **current_branch** as the child and the **parent_branch** as the parent. It does not make any modifications to your repository - it only updates the .git_chains file with the new entry.

By default **current_base** will be the merge_base between master and the **current_branch**, you can pass in an abritrary sha or another branch name if **current_branch** already has a base other than master.


### Rebase a chain

```ruby
git chain rebase [all]
```

Rebase will lookup the chain for the **current_branch**, perform rebase --onto of the **current_base** onto the **parent_branch**, and then update the **current_base** to be the new merge_base between the **current_branch** and the **parent_branch**.

Rebase all will traverse the chain entries until it finds a link with **master** as the parent, and then perform the rebase onto command all the way back up.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/git_chain. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the GitChain project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/git_chain/blob/master/CODE_OF_CONDUCT.md).
