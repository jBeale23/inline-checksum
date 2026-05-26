#!/usr/bin/env sh
# ------------------------------------- #
#             Return Codes              #
# ------------------------------------- #
# 0: All Algorithms Pass with Stdin     #
# 1: Missing sha256sum                  #
# 2: Missing sha512sum                  #
# 3: Missing md5sum                     #
# ------------------------------------- #

export wkdir="$(CDPATH="" cd -- "$(dirname -- "${0}")" && pwd -P)"
. "${wkdir}/shared_utils" || return "${?}"

