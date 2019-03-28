#!/bin/bash

#
# personal bashrc
#

proxy_host=$(echo ${SSH_CLIENT} | awk '{print $1}')
proxy_port=1080
http_proxy="http://${proxy_host}:${proxy_port}"

# Git Config
function set_git_config()
{
	if [[ -f ${HOME}/.gitconfig ]]
	then
		return
	fi

	if type git > /dev/null 2>&1
	then
		git config --global user.name iamcopper
		git config --global user.email kangpan519@gmail.com

		git config --global push.default matching
		git config --global core.editor vim
	fi
}

# Go env
function set_go_env()
{
	export GOROOT="/usr/lib/go"
	export GOPATH="${HOME}/go"
	export PATH="${PATH}:${GOPATH}/bin"

	# gocomplete (bash complete for go)
	complete -C /home/kang.pan/go/bin/gocomplete go

	#Set http proxy for go get over the Wall
	export http_proxy=${http_proxy}
	export https_proxy=${http_proxy}

	#Set git proxy for go get over the Wall
	git config --global http.proxy ${http_proxy}
	git config --global https.proxy ${http_proxy}
}

# ipmitool
# set the iol (ipmitool over lan) shotcut
function set_iol_shotcut()
{
	alias iol='ipmitool -I lanplus -U administrator -P advantech -H'
}

export LANG=C

alias vi='vim'

for (( i = 1; i <= $#; i++ ));
do
	case ${!i} in
		git       ) set_git_config;;
		go        ) set_go_env;;
		ipmitool  ) set_iol_shotcut;;
		ipmicore  )
			curdir=$(dirname ${BASH_SOURCE[0]})
			. ${curdir}/setup_ipmicore_env.sh
			;;
	esac
done
