# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Path to your oh-my-zsh installation.

## CDPATH set here lets me go directly to directories under dev from anywhere
export CDPATH=.:$HOME/Documents/dev

export ZSH="/Users/mrken/.oh-my-zsh"
ZSH_THEME="agnoster"
export ZSH=$HOME/.oh-my-zsh
export DEFAULT_USER=`whoami`
export LOCAL_GITHUB=$HOME/Documents/dev/github
export DOTFILES=$LOCAL_GITHUB/mister-ken/dotfiles

function source_if_exists (){[ -f "$1" ] && source "$1"}

plugins=(git fzf terraform)

source_if_exists $ZSH/oh-my-zsh.sh
source_if_exists $DOTFILES/.custom_prompt ## cusomise agonister prompt
source_if_exists $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source_if_exists ~/.fzf.zsh

## any line that starts with a " " is not saved to history
## use this to deal with secrets
## also ignores duplicates
HISTCONTROL=ignoreboth
HIST_STAMPS="mm/dd/yyyy"
export HISTSIZE=50000
export SAVEHIST=10000
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_NO_STORE

## array with paths to functions
## also sets FPATH 
fpath=( $DOTFILES/func "${fpath[@]}" )
# autoload those functions
autoload -Uz $fpath[1]/*(.:t)

### chpwd (hook function) is called by zsh when directory changed
# emulate help prevent problems with dirs named 'rm'
chpwd() {emulate -L zsh; ls -la; set_git_branch_env_var}

# run during shell start up
set_git_branch_env_var

# set env var when git called
preexec () { 
    ## unfortnately this does not change $GIT_BRANCH when switching branch with 'git branch...'.

    if [[ "${1}" =~ ^["git"] ]]; then set_git_branch_env_var; fi
}

export SHORT_PROMPT=1

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.

alias ls='ls -laG'
alias rm='echo "please use trash instead to delete"'
alias ppath='echo $PATH | tr ":" "\n" | sort'
alias iforgot='cat $DOTFILES/.iforgot'
alias cppwd='pwd | pbcopy'
alias pspwd='cd $(pbpaste)'
# Copy output of last command to clipboard
alias lcc="fc -e -|pbcopy"
# usage whoport :3000, use pid to kill process
alias whoport="lsof -P -i "
alias killport=find_and_kill

### function aliases
alias vir-env='toggle_vir_env'
### use fuzzy finder to search alises
alias fzfa='search_alias'
alias kickbucket='clear_bucket'
alias exvar='create_exports_by_string'
alias oa='open_arc'
alias vedit='view_edit_tutorial'

## aws cli aliases and env variables
## awsho updated from https://medium.com/circuitpeople/aws-cli-with-jq-and-bash-9d54e2eabaf1
alias awsho='{ aws sts get-caller-identity & aws iam list-account-aliases; } | jq -s ".|add"'

# alias clearuser=`aws iam delete-access-key --access-key-id $AWS_ACCESS_KEY_ID --user-name vault-test-user`

## list specific env variables
## should be replaced by vars and get_env_variables below
alias awsvars='env|grep -i ".*AWS"'
alias vaultvars='env | grep -i ".*VAULT_"'
alias tfvars='env | grep TF_'
alias hcpvars='env | grep -i ".*HCP_"'
alias govars='env | grep GO'

## get env var vaules already set
alias vv=get_env_variables
## now can just paste the .git url to clone it
alias -s git='git clone '

## global alias
alias -g PJQ='| jq'
alias -g OURL='-output-curl-string'

# edit and source this file
alias szsh='source $HOME/.zshrc'
alias czsh='code ~/.zshrc'

### GOPATHs
export GOPATH=$HOME/go
export GOBIN=$HOME/go/bin
# export GOROOT=/usr/local/go ## let go deal with it

### add GOPATH to path
# REMOVED BELOW B/C WAS GOING TO DEV VERSION OF VAULT
#PATH="/opt/homebrew/opt/libpq/bin:$PATH:$GOPATH:$GOBIN"
PATH="/opt/homebrew/opt/libpq/bin:$PATH:$GOPATH:/opt/homebrew/bin/bash"
### PYTHON
alias python=python3
alias pip=pip3

### Terraform aliases, variables and functions
alias compdef tf=terraform
alias tfl='terraform login NEED_HOST'
alias tf='terraform'
alias tfi='terraform init'
alias tfpo='terraform plan --out tf.plan'
alias tfp='terraform plan'
alias tfpl='terraform plan -no-color | less +F'
alias tfao='terraform apply tf.plan'
alias tfd='terraform destroy -auto-approve'
alias tfv='terraform validate'
alias tff='terraform fmt --recursive'
alias tfo='terraform output'
alias rmtf='trash -rf .terraform; trash .terraform.lock.hcl; trash terraform.tfstate; trash tf.plan; trash terraform.tfstate.backup'
alias tflog='tf_log_toggle'

## TF env variables
export TF_PLUGIN_CACHE_DIR=/Users/mrken/.terraform.d/plugin_cache
### even though the below was pointing at correct location was giving error during init
export TF_CLI_CONFIG_FILE=~/.terraformrc

## kubernetes settings and aliasses
source <(kubectl completion zsh)
alias compdef kb=kubectl
alias kb=kubectl
alias kbgp='kubectl get pods'
alias kbgns='kubectl get ns'
alias kbgs='kubectl get service'
alias kbcn='kubectl config'
alias kbc=kubectx
alias kbe=kubens
alias mk=minikube
alias mkrs='minikube delete; sleep 3; minikube start ; sleep 5'
alias kbev='kubectl exec --stdin=true --tty=true vault-0 -- /bin/sh'

## AWS Nuke
alias nifo='/Users/mrken/Documents/dev/github/aws-nuke/dist/aws-nuke'
alias nuke='/Users/mrken/Documents/dev/github/aws-nuke/dist/aws-nuke'

## Python Skew
export SKEW_CONFIG=~/.skew/skew.yaml

### git stuff
alias rmgit='trash -rf .git'
alias cgig='create_git_ignore'
alias gco='git checkout '
alias gconb='git checkout -t -b'
alias gcom='gco main'
alias gun='git reset --soft HEAD~1'
alias ogl='open `gitlab_url`'
alias ogh='open `github_url`'
## reset current commit before push
alias gunc='git reset HEAD~'
alias gitt='env GIT_TRACE=1 GIT_CURL_VERBOSE=1 git'
alias gitpo='git pull origin'

## instruqt bootstrap
alias inqtboot=../../../scripts/build-script/bootstrap.sh

## Get SHA256 of a file
alias gsha='shasum -a 256'

### homebrew settings
export HOMEBREW_NO_ANALYTICS=1
# Users may optionally set an environment variable to delay (in seconds) the next update check. Updates should occur no less than once per day
export HOMEBREW_AUTO_UPDATE_SECS=28800

## these are set in .zprofile
export GUILE_LOAD_PATH="/usr/local/share/guile/site/3.0"
export GUILE_LOAD_COMPILED_PATH="/usr/local/lib/guile/3.0/site-ccache"
export GUILE_SYSTEM_EXTENSIONS_PATH="/usr/local/lib/guile/3.0/extensions"

## Fuzzy finder settings
export FZF_DEFAULT_OPTS=' --margin=2,0% --border --info=inline --prompt="Search: "'

### Only print neofetch once
#### the || true makes sure shell does not open with an error
## use this to completly clear a bucket you want to use terraform destroy on
alias nterm='open -a iTerm .'
alias update='brew update && brew outdated'

## open new chrome browser with incognoto
alias newchr='open -na "Google Chrome" --args --incognito "https://s.f/myapps"'
alias hcchr='open -n -a "Google Chrome" --args --profile-directory="Profile 1"'
alias kenchr='open -n -a "Google Chrome" --args --profile-directory="Profile 2"'

## instruqt
alias ins=instruqt
export INSTRUQT_TELEMETRY=false
export INSTRUQT_REPORT_CRASHES=false

## docker
alias dck=docker
alias dckps='docker ps -aq'
alias dckrm='docker rm -f $(docker ps -aq)'

## simple scrpipt to convert base64 encoded into byte string
function b642str () {
python << EOPYTHON
import base64
print(base64.b64decode("${1}"))
EOPYTHON
}

## simple script to convert base64 encoded into byte string
function str2b64 () {
python << EOPYTHON
import base64
print(base64.b64encode(str("${1}")))
EOPYTHON
}

function dckbld () { ## needs image name
    docker build --no-cache -t $1 .
}

## create image for multiple platforms and push
function dckbldx () { ## needs image name
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

## for fun
alias hollywood='docker run --rm -it bcbcarl/hollywood'