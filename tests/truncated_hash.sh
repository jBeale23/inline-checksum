#!/usr/bin/env sh
# ------------------------------------- #
#             Return Codes              #
# ------------------------------------- #
# 0: All Algorithms Fail on Truncation  #
# 1: Missing sha256sum                  #
# 2: Missing sha512sum                  #
# 3: Missing md5sum                     #
# 4: Failed on sha256sum Check          #
# 5: Failed on sha512sum Check          #
# 6: Failed on md5sum Check             #
# ------------------------------------- #

export wkdir="$(CDPATH="" cd -- "$(dirname -- "${0}")" && pwd -P)"
. "${wkdir}/shared_utils" || return "${?}"

for algorithm in "sha256" "sha512" "md5"; do
	correct_hash_pointer=$(printf "correct_%s" "${algorithm}")
	eval "correct_hash=\$${correct_hash_pointer}"
	truncated_hash="${correct_hash}"
	while [ ${#truncated_hash} -gt 16 ]; do
    truncated_hash="${truncated_hash%?}"
	done
	return_code_pointer=$(printf "return_%s" "${algorithm}")
	eval "return_code=\$${return_code_pointer}"
	cat "${license_file}" | "${script}" --algorithm="${algorithm}" "${truncated_hash}" - > /dev/null
	case "${?}" in
		1);;
		*)
			printf "[%s]: Failed truncation test with algorithm '%s'.\n" "$(date +'%H:%M:%S')" "${algorithm}" >&2
			return "${return_code}"
			;;
	esac
done
