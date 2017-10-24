#!/usr/bin/env bash

# Thanks: http://brettterpstra.com/2015/02/20/shell-trick-printf-rules/
rule () {
    printf -v _hr "%*s" $(tput cols) && echo ${_hr// /${1--}}
}
rulem ()  {
    if [ $# -eq 0 ]; then
        echo "Usage: rulem MESSAGE [RULE_CHARACTER]"
        return 1
    fi
    # Fill line with ruler character ($2, default "-"), reset cursor, move 2 cols right, print message
    printf -v _hr "%*s" $(tput cols) && echo -en ${_hr// /${2--}} && echo -e "\r\033[2C$1"
}

# helper
arguments_invalid () {
  local count=$#
  # 0 arguments are always valid
  if [ ${count} -eq 0 ] ; then
      false ; return
  fi

  if interactive_mode_enabled $@ ; then
    false ; return
  fi

  true ; return
}

interactive_mode_enabled () {
  if [ $# -eq 1 ] && [ $1 == '--interactive' ] ; then
    true ; return
  fi
  false ; return
}

print_usage () {
  rulem "highway bootstrap"
  echo ""
  echo "  USAGE: bootstrap.sh [--interactive]"
  echo "    --interactive        Request user confirmation before starting the bootstrap process"
  echo ""
}

# more boilerplate
set -e			       # => exit on failure
set -u			       # => exit on undeclared variable access
set -o pipefail		 # => sane exit codes when using |

# Print Information

if arguments_invalid $@ ; then
    print_usage
    exit 1
fi


if interactive_mode_enabled $@ ; then
  echo ""
  echo ""
  rulem "highway bootstrap"
  echo ""
  echo "  You are about to run the highway bootstrap script. This will clone the highway repo, build"
  echo "  highway using the Swift compiler and move everything to ${HOME}/.highway."
  echo ""
  echo "  Press <any key> to continue."
  echo ""
  read confirmation
fi

# Debug Support
if [ -z ${HIGHWAY_DEBUG_ENABLED+x} ]
  then
    echo "Debugging disabled"
    echo "To enable debugging: 'export HIGHWAY_DEBUG_ENABLED=1'"
  else
    echo "Debugging enabled"
    set -x              # => enable tracing
fi

# settings
__repoUrl="https://github.com/ChristianKienle/highway.git"
__wc_name="highway"

# actual code
temp=$(mktemp -d -t highway)
__wc="${temp}/${__wc_name}"

# clone the master branch
git clone -b  ${HIGHWAY_BOOTSTRAP_BRANCH:-master} ${__repoUrl} ${__wc}

# build it
pushd ${__wc}
    swift build --configuration release --product highway
    highway_bin="$(swift build --configuration release --product highway --show-bin-path | tr -d '[:space:]')/highway"
popd

# create highway home
highway_home="${HOME}/.highway"
mkdir -p ${highway_home}
highway_home_bin_dir="${highway_home}/bin"
mkdir -p ${highway_home_bin_dir}

# copy highway
highway_home_bin=${highway_home_bin_dir}/highway
rm -f -rf ${highway_home_bin} || true
cp ${highway_bin} ${highway_home_bin_dir}

# bootstrap the home bundle
${highway_home_bin_dir}/highway bootstrap

echo "highway downloaded, compiled and ready to be used at:"
echo ${highway_home_bin}

# trying to find highway
set +e
which highway
if [ $? -eq 0 ]
  then
    printf "\n\n"
    rulem "SUCCESS"
    printf "%s\n" "try: highway help "
    rule
    printf "\n\n"
  else
    printf "\n\n"
    rulem "SUCCESS"
    printf "%s\n" " highway cannot be found in your path. You"
    printf "%s\n" " should add highway to your PATH environment"
    printf "%s\n" " variable. You can add it to your path by "
    printf "%s\n" " running the following commands:"
    rule
    printf "%s" ' echo "PATH=$PATH:'
    printf "%s" ${highway_home_bin_dir}
    printf "%s" '" >> '
    printf "%s\n" "${HOME}/.profile"
    rule
    printf "\n\n"
fi

set -e
