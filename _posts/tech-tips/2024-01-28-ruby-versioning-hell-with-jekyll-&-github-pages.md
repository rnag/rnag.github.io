---
title: "Ruby (Versioning) Hell with Jekyll & GitHub Pages"
excerpt: "A how-to (with lessons learned) on Ruby versioning with Jekyll and GitHub Pages."
date: "2024-01-28 22:06:58 -0500"
categories:
  - tech-tips
tags:
  - ruby
  - github-pages
  - jekyll
  - rbenv
  - homebrew
dev_to:
  id: 1744145
  tags:  # up to 4, compatible with https://dev.to/tags
  - ruby
  - jekyll
  - github
  - homebrew
---

{% include tech-tips-head-notice.html %}

So, huge disclaimer, a lesser-known fact (who am I kidding, I'm not ashamed to admit it) is that I'm a bit of a `ruby` newbie.

That is, I've never cared to learn `ruby` before. Also, perhaps as a direct result of that, I am a little taken aback when a project asks me to install `ruby` and use tools that it provides such as `bundler` , because the assumption there is that I know what I am doing.

Just to set the record straight, I don't know what I am doing when it comes to _anything_ `ruby` .

Recently, a lot of stuff blew up and hell broke loose, when I inadvertently ran `brew upgrade` on my new Mac to update (or upgrade?) packages installed by **homebrew**.

But alas, I did not take `ruby` into account. A while back, I had installed `ruby` with homebrew:

```ruby
$ brew install ruby
```

Homebrew, without my permission, apparently took it upon itself to upgrade the bundled `ruby` version - from 3.2.3 to 3.3.0.

Hell broke lose when I `cd`'d into my project repo that I use for [my website](https://github.com/rnag/rnag.github.io), and ran `bundle` to install fresh dependencies - which was needed, since `ruby` version was upgraded, so it was a fresh environment with no gems available.

```ruby
$ bundle install
```

The error I received was something like this:

```bash
~/<user>/somewhere $ bundle exec jekyll serve
jekyll 3.9.3 | Error:  undefined method `[]' for nil
/usr/local/Cellar/ruby/3.3.0/lib/ruby/3.3.0/logger.rb:384:in `level': undefined method `[]' for nil (NoMethodError)

    @level_override[Fiber.current] || @level
```

This indeed was the specific error message I saw:
 `Error: undefined method '[]' for nil`

Searching online, you can see a whole slew of posts that mention this error, and apparently it only happens with ruby `3.3.0` and the `jekyll` version `3.9.3` that comes bundled with `github-pages` .

- [https://stackoverflow.com/questions/77851863/bundle-exec-jekyll-serve-not-working-locally](https://stackoverflow.com/questions/77851863/bundle-exec-jekyll-serve-not-working-locally)

- [https://talk.jekyllrb.com/t/unable-to-install-jekyll-on-m3-macbook/8836](https://talk.jekyllrb.com/t/unable-to-install-jekyll-on-m3-macbook/8836)

- [https://talk.jekyllrb.com/t/error-when-executing-bundle-install/8822](https://talk.jekyllrb.com/t/error-when-executing-bundle-install/8822)

Hence, while it might not bear repeating, it helps to clarify - upgrading `jeykll` version for a project is a **no-go**, especially when the project `Gemfile` relies explicitly on `github-pages` dependency, which _itself_ relies on `jekyll` :

```csharp
gem "github-pages", group: :jekyll_plugins
```

And yes, just to double check, the `Gemfile.lock` should show the lines that clearly show the dependency relationship between the

```scss
    github-pages (228)
      github-pages-health-check (= 1.17.9)
      jekyll (= 3.9.3)
    ...
```

To recap, if one installs `ruby` with `brew` and runs `brew upgrade` or similar and results in `ruby@3.3.0` being inadvertently installed, this can break when attempting to work with projects that rely on a specific version of `jekyll`, especially ones that rely on `github-pages` gem for deployment.

There does not appear to be any solution involving `brew` and `ruby` alone.

Upon catching the issue that the mismatch b/w the two gems caused the build error when running `bundle exec jekyll serve` , I immediately tried some steps, that first involved installing `csv` , as apparently there was a warning printed to terminal since that doesn't come bundled in ruby 3.3.0

```ruby
$ bundle install csv
```

Then I tried to upgrade all `gem` versions in project by running:

```ruby
$ bundle upgrade
```

That didn't help, so I tried to specify both gems explicitly:

```ruby
$ bundle update jekyll
$ bundle update github-pages
```

Still no dice, and I was at wit's end by now. Manually upgrading either of those `gem` versions specified in `Gemfile.lock` didn't help either. There was a dependency conflict if I upgraded `jekyll`, as `github-pages` relied on a specific version.

I also tried deleting `Gemfile.lock` file completely and running `bundle` again, but still no dice.

In short, this was exactly what they call "dependency hell". I cannot change either gem versions, and hence this is basically a "SNAFU!" situation. As in, there's no solution to be had that allows me to keep the up-to-date `ruby` version 3.3.0 for use with my project.

I even tried uninstalling and re-installing specific ruby version 2.3.2 via **homebrew**, but if you can believe it there _still_ was no dice:

```shell
$ brew uninstall ruby
$ brew install ruby@3.2
$ echo 'export PATH="/opt/homebrew/opt/ruby@3.2/bin:$PATH"' >> ~/.zshrc
$ source ~/.zshrc
$ ruby -v
ruby 3.2.3
$ gem install bundler
$ bundle
<error>
```

I'll be honest, I felt like tearing my hair out at this point. Sweat started metaphorically trickling down my back. Being a `ruby` newb, I was about to throw in the towel, and as a last resort maybe open up an issue on the project page for one of the gems, or post about it on a forum asking other users for help.

Now that I think about it, maybe ChatGPT could have helped me. Hello ChatGPT? Can you explain this error please, and suggest me a solution \<_paste stack trace_\>.

However, thankfully, that was ultimately not needed. I found a workaround that helps me to maintain `ruby` version across different machines, consistently.

After researching online for quite a bit, I found out that someone was using `rbenv` and decided to look into what that is. Turns out, it's something similar like `pyenv` for `python`, or basically a version management tool for a programming language.

Feeling I was on to something at this point, and shrugging my shoulders after realizing I had nothing to lose, I decided to install it after all:

```shell
$ brew install rbenv ruby-build
$ echo 'eval "$(rbenv init - zsh)"' >> ~/.zshrc
$ source ~/.zshrc
```

That got me the`rbenv` command, but of course I wasn't done there yet.

I have to install my necessary previous **ruby** version `3.2.3` with `rbenv` :

```ruby
$ rbenv install 3.2.3
```

After installing a version with `rbenv` , you can set it either **globally** (so that `ruby` version is changed regardless of your location in terminal) or **locally**, so it will only affect a project after you `cd` into its folder.

I decided to do _both_, because the default `ruby` version that comes bundled with my new Mac Air M2 laptop is something like `2.x` , which is hella old. And I'm clearly never gonna use the built-in one.

```shell
$ rbenv global 3.2.3
$ rbenv local 3.2.3
```

Now we're cooking! To double-check that we got the new **ruby** version installed:

```scss
$ ruby -v
ruby 3.2.3 (2024-01-18 revision 52bb2ac0a6) [arm64-darwin23]
```

Great! Now that's out of the way, we want to install or upgrade `bundler`, and then we're good to go.

```ruby
$ gem install bundler
$ bundle -v
Bundler version 2.5.5
```

If it helps, one might need to delete and re-create`Gemfile.lock` by running `bundle`, especially if it says the gems were installed with another version of `bundler` :

```sql
BUNDLED WITH
   2.5.4
```

After that, you can run `bundle exec` or however you start up your project that relies on `jekyll` and `github-pages` , and then you should be all set.

If it helps, I've actually created an alias command `jb` , which serves that exact purpose in my case:

```bash
$ which jb
jb: aliased to bundle exec jekyll serve -low
```

It's easy enough to add that alias in to `bash` or `zsh` shell configuration. To add it to `zsh` - my default interpreter - here's what I did:

```bash
echo "alias jb='bundle exec jekyll serve -low'" >> ~/.zshenv
```

Then `source ~/.zshenv` to reload the changes in the current terminal window.

All said, this whole ordeal took me _**>1 hour**_ of pointless debuggery. It was the exact opposite of fun. And, ideally not how I would have wanted to spend a Sunday morning.

However, the upshot is that the confusing **ruby** versioning hell along with two of the aforementioned gems - `jekyll` and `github-pages` - is now finally resolved, at long lost.

> Here then was a lesson learned: manage `ruby` versions with **rbenv** instead of **homebrew**.

Praise be! Massive dependency hell solved, and headache (mostly) avoided. Hope this helps someone else out. Now go out there and get coding!


