#!/usr/bin/env bash
cat <<'EOF' >> ~/.bashrc

# Git
function parse_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "("${ref#refs/heads/}")"
}
export PS1="\w \$(parse_git_branch)\n\$ "
export EDITOR='atom --wait'
export VISUAL='atom --wait'

EOF

git config --global color.ui true

echo -e "\n What is your Github username?"
read username
git config --global user.name "$username"

echo -e "\n What is your Github email address?"
read email
git config --global user.email "$email"

git config --global pull.rebase true
git config --global branch.autosetuprebase always
git config --global push.default simple
git config --global branch.autosetupmerge true
git config --global core.editor "atom --wait"

#this should be run from orientation directory
#set up git ignore
git config --global core.excludesfile ~/.gitignore
cp .gitignore ~/.gitignore # from this repository directory

ssh-keygen -t rsa -C "$email"
ssh-add ~/.ssh/id_rsa

if [[ $(uname -s) = 'Darwin' ]]; then
  pbcopy < ~/.ssh/id_rsa.pub
else
  sudo apt install xclip
  xclip -selection clipboard < ~/.ssh/id_rsa.pub
fi

read -p "Key copied to clipboard. Paste in settings on Github. Press [ENTER] to continue and test key."

ssh -T git@github.com
