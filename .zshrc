# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.
export ZSH="/Users/mrken/.oh-my-zsh"
ZSH_THEME="agnoster"

source $ZSH/oh-my-zsh.sh
# source /opt/homebrew/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

export ZSH=$HOME/.oh-my-zsh
HIST_STAMPS="mm/dd/yyyy"
plugins=(git fzf terraform)
# export DEFAULT_USER=`whoami`

## CDPATH set here lets me go directly to directories under dev from anywhere
export CDPATH=.:$HOME/Documents/dev

# Set up the prompt (with git branch name)
# copied from ~/.oh-my-zsh/themes/agnoster.zsh-theme
## set up short prompt_dir based on prompt_dir from agnoster.zsh-theme
short_prompt_dir() {
    prompt_segment blue $CURRENT_FG "%$1~"
}

# originally Context: user@hostname (who am I and where am I)
# hashi looked like mrken@mrken-XXXXX so over ridden
prompt_context() {
  if [[ "$USERNAME" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)%m"
  fi
}

short_prompt() {
    RETVAL=$?
    prompt_status
    # prompt_virtualenv
    prompt_aws
    # prompt_context
    short_prompt_dir 1
    prompt_git
    prompt_bzr
    prompt_hg
    prompt_end
}

long_prompt(){
    RETVAL=$?
    prompt_status
    prompt_virtualenv
    prompt_aws
    prompt_context
    prompt_dir
    prompt_git
    prompt_bzr
    prompt_hg
    prompt_end
}

export SHORT_PROMPT=1

## toggle verbose and brief prompt
function prompt() {
    if [ -v SHORT_PROMPT ]
    then # verbose is default
        unset SHORT_PROMPT
        export PROMPT='$(long_prompt)'
    else # short prompt
        export PROMPT='$(short_prompt)'
        export SHORT_PROMPT=1
fi
}

# setopt PROMPT_SUBST
# PROMPT='$(build_prompt) '
## Display time at far right of prompt line
# RPROMPT='%*'
## brief standard prompt
# PROMPT='%(?.%F{green}√.%F{red}?%?)%f %B%F{240}%1~%f%b %# '

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias ls='ls -laG'
alias eng='env | grep'
alias alg='alias | grep'
alias rm='echo "please use trash instead to delete"'
alias rmgit='trash -rf .git'
alias rmtf='trash -rf .terraform; trash .terraform.lock.hcl; trash terraform.tfstate; trash tf.plan; trash terraform.tfstate.backup'
alias ppath='echo $PATH | tr ":" "\n" | sort'
alias cppwd='pwd | pbcopy'
alias pspwd='cd $(pbpaste)'
# Copy output of last command to clipboard
alias lcc="fc -e -|pbcopy"
# usage whoport :3000, use pid to kill process
alias whoport="lsof -P -i "
findandkill() {  prsn=$(lsof -t -i:$1 );  kill -9 $prsn }
alias killport=findandkill

## below messing with some scripts execution of egrep
# export GREP_OPTIONS=' --color=always'
## any line that starts with a " " is not saved to history
## use this to deal with secrets
## also ignores duplicates
HISTCONTROL=ignoreboth
export HISTSIZE=50000
export SAVEHIST=10000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_NO_STORE
# so i don't have to remember that url for CI registries
# export CI_REGISTRY=???????

### chpwd (hook function) is called by zsh when directory changed
chpwd() ls

## aws cli aliases and env variables
## awsho updated from https://medium.com/circuitpeople/aws-cli-with-jq-and-bash-9d54e2eabaf1
alias awsho='{ aws sts get-caller-identity & aws iam list-account-aliases; } | jq -s ".|add"'

# for some reason the ' above causing coloring to be off
# alias clearuser=`aws iam delete-access-key --access-key-id $AWS_ACCESS_KEY_ID --user-name vault-test-user`

## list specific env variables
## should be replaced by vars and get_env_variables below
alias awsvars='env|grep -i ".*AWS"'
alias vaultvars='env | grep -i ".*VAULT_"'
alias tfvars='env | grep TF_'
alias hcpvars='env | grep -i ".*HCP_"'
alias govars='env | grep GO'

alias hollywood='docker run --rm -it bcbcarl/hollywood'

get_env_variables () {
    typeset -u env_var_identifier
    env_var_identifier=$(echo $1 | cut -d "." -f 1)
    if [ -z $env_var_identifier ]
    then # show values for GO, AWS, VAULT, Terraform and HCP
        env | grep -E "GO|.*AWS|.*VAULT_|TF_|.*HCP_" | sort
    else
        # match the upper case version of string sent in
        env | grep "${env_var_identifier}.*=" | sort
    fi
}

## suffix alias 
## get env var vaules already set
alias -s vars=get_env_variables
alias vv=get_env_variables
## now can just paste the .git url to clone it
alias -s git='git clone '

## global alias
alias -g pjq='| jq'

printstuff () {
    echo $0
    echo $1
}

### Env variables
export AWS_REGION="us-east-1"

alias szsh='source $HOME/.zshrc'
alias czsh='code ~/.zshrc'

### GOPATHs
export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin
# export GOROOT=/usr/local/go ## let go deal with it

### add GOPATH to path
# PATH=$PATH:$GOPATH:$GOBIN
PATH="/opt/homebrew/opt/libpq/bin:$PATH:$GOPATH:$GOBIN"

### PYTHON
alias python=python3
alias pip=pip3

### Terraform aliases, variables and functions
alias tfl='terraform login NEED_HOST'
alias tf='terraform'
alias compdef tf=terraform
alias tfi='terraform init'
alias tfpo='terraform plan --out tf.plan'
alias tfp='terraform plan'
alias tfpl='terraform plan -no-color | less +F'
alias tfao='terraform apply tf.plan'
alias tfd='terraform destroy -auto-approve'
alias tfv='terraform validate'
alias tff='terraform fmt --recursive'
alias tfo='terraform output'
alias tflog='tf_log_toggle'

## TF env variables
export TF_PLUGIN_CACHE_DIR=/Users/mrken/.terraform.d/plugin_cache
### even though the below was pointing at correct location was giving error during init
# export TERRAFORM_CONFIG="/Users/mrken/.terraform.d/credentials.tfrc.json"
## Others did not need the env var to be set, but wont reconginse ~/.terraformrc
export TF_CLI_CONFIG_FILE=~/.terraformrc

### quickly toogle terraform logging (TF_LOG) on and off
function tf_log_toggle() {
    if [ -v TF_LOG ]
    then
        unset TF_LOG
        echo "unset TF_LOG"
    else
        export TF_LOG=TRACE
        echo "TF_LOG=$TF_LOG"
    fi
}

## kubernetes settings and aliasses
source <(kubectl completion zsh)
alias compdef kb=kubectl
# alias kb=kubectl
# complete -o default -F __start_kubectl kb
alias kbgp='kubectl get pods'
alias kbgns='kubectl get ns'
alias kbgs='kubectl get service'
alias kbcn='kubectl config'
alias kbc=kubectx
alias kbe=kubens
alias mk=minikube
alias mkrs='minikube delete; sleep 3; minikube start ; sleep 5'
alias kbev='kubectl exec --stdin=true --tty=true vault-0 -- /bin/sh'

## enable kube_ps1
# kubeon and kubeoff
# source "/usr/local/opt/kube-ps1/share/kube-ps1.sh"
# PS1='$(kube_ps1)'$PS1
# ### disable kube-ps1 by default
# kubeoff

## AWS Nuke
alias nifo='/Users/mrken/Documents/dev/github/aws-nuke/dist/aws-nuke'
alias nuke='/Users/mrken/Documents/dev/github/aws-nuke/dist/aws-nuke'

## Python Skew
export SKEW_CONFIG=~/.skew/skew.yaml

### git stuff
alias gco='git checkout '
alias gconb='git checkout -t -b'
alias gcom='gco main'
alias gitrepo='cd $HOME/Documents/git_repo/'
alias ogl='open `gitlab_url`'
alias ogh='open `github_url`'
## reset current commit before push
alias gunc='git reset HEAD~'
# env VAR1='foo" VAR2="bar" <command> open enviornment that changes the env variables for that exacution
alias gitt='env GIT_TRACE=1 GIT_CURL_VERBOSE=1 git'
alias gitpo='git pull origin'

## add everything local, commit and push
function gcap() {
    git add .
    git commit -m "$1"
    git push
}

github_url() {
    branch=`git branch --show-current`
    # url=`git remote get-url origin | sed 's/git@//g; s/.git$//g; s#^#https://#'`
        url=`git remote get-url origin | sed 's/git@//g; s/.git$//g'`
    echo "$url/tree/$branch"
}

## instruqt bootstrap
alias inqtboot=../../../scripts/build-script/bootstrap.sh

### creates a .gtignore
cgig() {
cat > .gitignore << EOF
*.exe
*.exe~
pc
**/pc
*tfstate*
*.zip
*.tar.gz
*.rar
*.plan
public/**
themes/**
**.DS_Store
**.git
logs/**
junk/**
.terraform/**
**/.terraform/**
.terraform.lock.hcl
.vscode
.vale.ini
.styles/**
.vscode/**
**settings.json*
python/public
out/
~$*
EOF
}

## Get SHA256 of a file
alias gsha='shasum -a 256'

### homebrew settings
export HOMEBREW_NO_ANALYTICS=1
#Users may optionally set an environment variable to delay (in seconds) the next update check. Updates should occur no less than once per day
export HOMEBREW_AUTO_UPDATE_SECS=28800

### Base $PATH
## these are set in .zprofile
export GUILE_LOAD_PATH="/usr/local/share/guile/site/3.0"
export GUILE_LOAD_COMPILED_PATH="/usr/local/lib/guile/3.0/site-ccache"
export GUILE_SYSTEM_EXTENSIONS_PATH="/usr/local/lib/guile/3.0/extensions"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPTS=' --margin=2,0% --border --info=inline --prompt="Search: "'
## use fzf to search shell aliasees
## this crashes if nothing is sent into $1
search_alias () {
    print -z $(alias | fzf --tac --select-1 --exit-0 --query "$1" | sed -nE 's/([a-zA-Z]*)=.*/\1/p')
}

### use fuzzy finder to search alises
alias fzfa='search_alias'
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"
# [ "$(date +%j)" != "$(cat ~/.nf.prevtime 2>/dev/null)" ] && { neofetch > ~/.nf; date +%j > ~/.nf.prevtime; cat ~/.nf; } || cat ~/.nf

### Only print neofetch once
#### the || true makes sure shell does not open with an error
# [ "$(date +%j)" != "$(cat ~/.nf.prevtime 2>/dev/null)" ] && { neofetch; date +%j > ~/.nf.prevtime} || { true }
test -e $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh && source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# slightly different configurations if in VScode or iterm2
if [ "$TERM_PROGRAM" = "vscode" ]
then
    PROMPT='$(short_prompt) '
else
## Only run neofetch if it is not a terminal in vscode
    [ "$(date +%j)" != "$(cat ~/.nf.prevtime 2>/dev/null)" ] && { neofetch; date +%j > ~/.nf.prevtime} || { true }
    PROMPT='$(short_prompt) '
fi

alias nterm='open -a iTerm .'

# creates a new terminal window - lol i dont think i even use this
function new() {
    if [[ "$TERM_PROGRAM" == "iTerm.app" ]]; then
    app_name="iTerm"
    else
    app_name="iTerm"
    fi
    if [[ $# -eq 0 ]]; then
        open -a "$app_name" "$PWD"
    else
        open -a "$app_name" "$@"
    fi
}

alias update='brew update && brew outdated'

## use this to completly clear a bucket you want to use terraform destroy on
alias kickbucket=clear_bucket
clear_bucket () {
python << EOPYTHON
#!/usr/bin/env python
import boto3
import sys
## delete markers on an object are making it hard to terraform destroy
## this clears out bucket for a terraform destroy
try:
    s3 = boto3.resource('s3')
    bucket = s3.Bucket('${1}')
    bucket.object_versions.all().delete()
    print('${1}', "is now empty!")
    # bucket.delete()
except Exception as e:
    print("that ain't workin':", e)
    exit(1)
EOPYTHON
}

## scrape commands from markdown
scrape  () {
python << EPYTHON
#!/usr/bin/env python3
# scrapes commands from codeblocks in markdown

import sys 

IN_BLOCK = False
INLINE_FILE = False

command = None

with open('${1}',"r") as gfg_file:
   file_content = gfg_file.readlines()

   for line in file_content:
      line = line.rstrip()
      indent_count = line.rstrip().count('   ')
      if "$ " in line:
         command = line[2:]
         if command[-1]== "\\\":
            IN_BLOCK = True
         elif command.split(" ")[-1]=="<<EOF":
            INLINE_FILE = True
         command = command + "\n"
      elif IN_BLOCK or INLINE_FILE:
         if line.split(" ")[-1] == "\\\":
            IN_BLOCK = True
         elif INLINE_FILE:
            if line.split(" ")[-1]=="EOF":
               INLINE_FILE = False
         else:
            IN_BLOCK = False
            INLINE_FILE = False
         command = command + line + "\n"
      elif command:
         print(command)
         command = None
EPYTHON
}

## simple scrpipt to convert base64 encoded into byte string
b642str () {
python << EOPYTHON
import base64
print(base64.b64decode("${1}"))
EOPYTHON
}

## simple script to convert base64 encoded into byte string
str2b64 () {
python << EOPYTHON
import base64
print(base64.b64encode(str("${1}")))
EOPYTHON
}

## open new chrome browser with incognoto
alias newchr='open -na "Google Chrome" --args --incognito "https://s.f/myapps"'
alias hcchr='open -n -a "Google Chrome" --args --profile-directory="Profile 1"'
alias kenchr='open -n -a "Google Chrome" --args --profile-directory="Profile 2"'

## instruqt
alias ins=instruqt
export INSTRUQT_TELEMETRY=false
export INSTRUQT_REPORT_CRASHES=false
# replaced by zsh-autocomplete
# autoload -U +X bashcompinit && bashcompinit
# complete -o nospace -C /opt/homebrew/bin/vault vault

## docker
alias dck=docker
alias dckps='docker ps -aq'
alias dckrm='docker rm -f $(docker ps -aq)'
alias dckva='docker run --name vault --cap-add=IPC_LOCK --env VAULT_DEV_ROOT_TOKEN_ID=root --env VAULT_DEV_LISTEN_ADDRESS=0.0.0.0:8200 --publish 8200:8200 --detach --rm hashicorp/vault'


dckbld () { ## needs image name
    docker build --no-cache -t $1 .
}

## create image for mukltiple platforms and push
dckbldx () {
    docker buildx build --push --platform linux/amd64,linux/arm64,linux/arm/v7 -t $1 .
}

### for specific images
## use hovercraft container image
alias hvc="docker run --rm -it -p 8000:8000 -v $(pwd):/hvc $CI_REGISTRY/registry/sfcommunity/hovercraft"
## vale container
alias mvale="docker run --rm -it -v $(pwd):/home --entrypoint vale vale"

## doormat tool
alias dmt=doormat
alias dmtopen='doormat login; eval $(doormat aws export --role arn:aws:iam::166839932314:role/aws_ken.keller_test-developer)'
alias dmtcon='doormat aws console --role arn:aws:iam::166839932314:role/aws_ken.keller_test-developer --region $AWS_REGION'


## vault aliasses
# used for locally compiled vault version
alias nvlt=/Users/mrken/Documents/dev/github/hashicorp/vault/bin/vault
alias vaulte=/Users/mrken/Documents/dev/github/hashicorp/vault-enterprise/bin/vault
alias v=vault
alias vr='vault read'
alias vw='vault write'
alias vl='vault list'
alias vs='vault status'

## set terminal tab title
alias stt=setTerminalText
setTerminalText () {
    echo -ne "\e]1;$@\a"
}

## easy way to create exports where all env variables have the same string
## in the name - AWS_, VAULT_, etc.

createExportsbyString () { 
    export_string=""
    raw_string=$(get_env_variables $@)
    array=(`echo $raw_string | tr '\n' ' '`)
    for n in ${array[@]}
    do
        export_string="export $n; $export_string"
    done
    echo $export_string | pbcopy
}

alias exports=createExportsbyString

alias getdevlink=reformatlink           
# parses out everything after "content" in a string
# used to format links for hashicorp/tutorials link
reformatlink () {
    text="${1#*content}"
    text="${text%.mdx*}"
    echo "$text" | pbcopy
}