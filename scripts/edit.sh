#!/usr/bin/env bash

# Debug Support
if [ -z ${HIGHWAY_DEBUG_ENABLED+x} ]
  then
    echo "Debugging disabled"
    echo "To enable debugging: 'export HIGHWAY_DEBUG_ENABLED=1'"
  else
    echo "Debugging enabled"
    set -x              # => enable tracing
fi

# more boilerplate
set -e			# => exit on failure
set -u			# => exit on undeclared variable access
set -o pipefail		# => sane exit codes when using |

# Do it
swift package --package-path ./_highway edit highway --path .
