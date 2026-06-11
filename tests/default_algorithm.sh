#!/usr/bin/env sh
# ------------------------------------- #
#             Return Codes              #
# ------------------------------------- #
# 0: All Algorithms Pass                #
# 1: Missing sha256sum                  #
# 2: Missing sha512sum                  #
# 3: Missing md5sum                     #
# 4: Failed on sha256sum Check          #
# 5: Failed on sha512sum Check          #
# 6: Failed on md5sum Check             #
# ------------------------------------- #

# ---------- #
# Test Setup #
# ---------- #

wkdir="$(CDPATH="" cd -- "$(dirname -- "${0}")" && pwd -P)"
parent_dir="$(dirname "${wkdir}")"

license_file="${parent_dir}/LICENSE"
script="${parent_dir}/inline-checksum"

return_sha256=4

timestamp="$(date +'%Y.%m.%d.%H.%M.%S')"
exec 2>> "${wkdir}/${timestamp}.test.log"

if command -v sha256sum > /dev/null 2>&1; then
	correct_sha256="$(sha256sum "${license_file}" | cut -f 1 -d " ")"
else
	printf "[%s]: sha256sum or an equivalent must be installed to check sha256 hashes.\n" "$(date +'%H:%M:%S')" >&2
	return 1
fi

export correct_sha256
export license_file
export parent_dir
export return_sha256
export script
export timestamp
export wkdir

# ----------- #
# Begin Tests #
# ----------- #

cat "${license_file}" | "${script}" "${correct_sha256}" - > /dev/null
case "${?}" in
	0) ;;
	*)
		printf "[%s]: Failed default algorithm test.\n" "$(date +'%H:%M:%S')" >&2
		# shellcheck disable=SC2154  # return_code is dynamically assigned
		return "${return_sha256}"
		;;
esac
