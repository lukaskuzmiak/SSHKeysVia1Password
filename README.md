# SSHKeysVia1Password

A desperate attempt to ssh-add all my SSH keys to SSH agent on MacOS using passphrases saved in 1Password.

## Usage

Put ```ssh-add-pass.sh``` and ```ssh-add-pass-helper.sh``` into your $HOME directory.

Adjust last lines of SSHKeysVia1Password.applescript to fit your SSH keys paths and 1Password item names.

Run as:

```
osascript /path/to/SSHKeysVia1Password.applescript
```
