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
return_sha512=5
return_md5=6

timestamp="$(date +'%Y.%m.%d.%H.%M.%S')"
exec 2>> "${wkdir}/${timestamp}.test.log"

if command -v sha256sum > /dev/null 2>&1; then
	correct_sha256="$(sha256sum "${license_file}" | cut -f 1 -d " ")"
elif command -v shasum > /dev/null 2>&1; then
	correct_sha256="$(shasum -a 256 "${license_file}" | cut -f 1 -d " ")"
elif command -v openssl > /dev/null 2>&1; then
	correct_sha256="$(openssl sha512 "${license_file}" | cut -f 2 -d " ")"
else
	printf "[%s]: sha256sum or an equivalent must be installed to check sha256 hashes.\n" "$(date +'%H:%M:%S')" >&2
	return 1
fi
if command -v sha512sum > /dev/null 2>&1; then
	correct_sha512="$(sha512sum "${license_file}" | cut -f 1 -d " ")"
elif command -v shasum > /dev/null 2>&1; then
	correct_sha512="$(shasum -a 512 "${license_file}" | cut -f 1 -d " ")"
elif command -v openssl > /dev/null 2>&1; then
	correct_sha512="$(openssl sha512 "${license_file}" | cut -f 2 -d " ")"
else
	printf "[%s]: sha512sum or an equivalent must be installed to check sha512 hashes.\n" "$(date +'%H:%M:%S')" >&2
	return 2
fi
if command -v md5sum > /dev/null 2>&1; then
	correct_md5="$(md5sum "${license_file}" | cut -f 1 -d " ")"
elif command -v openssl > /dev/null 2>&1; then
	correct_md5="$(openssl md5 "${license_file}" | cut -f 2 -d " ")"
else
	printf "[%s]: md5sum or an equivalent must be installed to check md5 hashes.\n" "$(date +'%H:%M:%S')" >&2
	return 3
fi

export correct_md5
export correct_sha256
export correct_sha512
export license_file
export parent_dir
export return_md5
export return_sha256
export return_sha512
export script
export timestamp
export wkdir

# ----------- #
# Begin Tests #
# ----------- #

for algorithm in "sha256" "sha512" "md5"; do
	correct_hash_pointer=$(printf "correct_%s" "${algorithm}")
	eval "correct_hash=\$${correct_hash_pointer}"
	return_code_pointer=$(printf "return_%s" "${algorithm}")
	eval "return_code=\$${return_code_pointer}"
	# shellcheck disable=SC2154  # correct_hash is dynamically assigned
	file_name=$("${script}" --algorithm="${algorithm}" --output-filename "${correct_hash}" "${license_file}")
	case "${file_name}" in
		"${license_file}") ;;
		*)
			printf "[%s]: Failed filename output test from file with algorithm '%s'.\n" "$(date +'%H:%M:%S')" "${algorithm}" >&2
			# shellcheck disable=SC2154  # return_code is dynamically assigned
			return "${return_code}"
			;;
	esac
done
