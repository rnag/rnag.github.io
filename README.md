# `rnag.github.io`

Source code for my personal website. View it at https://ritviknag.com/.

## Local Testing

First, install `jekyll` and `ruby` if you haven't already done so.

Next, set up an alias command (Bash):

```bash
alias jb='bundle exec jekyll serve -low'
```

Or, add it to `~/.zshenv` (if using `zsh`):

```console
$ echo "alias jb='bundle exec jekyll serve -low'" >> ~/.zshenv
$ source ~/.zshenv
```

Then, run `jekyll s` to serve the web content in a local browser:

```console
$ jb
```
