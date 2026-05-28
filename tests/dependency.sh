#!/usr/bin/env sh
# ------------------------------------- #
#             Return Codes              #
# ------------------------------------- #
# 0: All Algorithms Pass                #
# 1: Missing sha256sum                  #
# 2: Missing sha512sum                  #
# 3: Missing md5sum                     #
# ------------------------------------- #

wkdir="$(CDPATH="" cd -- "$(dirname -- "${0}")" && pwd -P)"

timestamp="$(date +'%Y.%m.%d.%H.%M.%S')"
exec 2>> "${wkdir}/${timestamp}.test.log"

if command -v sha256sum > /dev/null 2>&1; then
	true
elif command -v shasum > /dev/null 2>&1; then
	true
elif command -v openssl > /dev/null 2>&1; then
	true
else
	printf "[%s]: sha256sum or an equivalent must be installed to check sha256 hashes.\n" "$(date +'%H:%M:%S')" >&2
	return 1
fi
if command -v sha512sum > /dev/null 2>&1; then
	true
elif command -v shasum > /dev/null 2>&1; then
	true
elif command -v openssl > /dev/null 2>&1; then
	true
else
	printf "[%s]: sha512sum or an equivalent must be installed to check sha512 hashes.\n" "$(date +'%H:%M:%S')" >&2
	return 2
fi
if command -v md5sum > /dev/null 2>&1; then
	true
elif command -v openssl > /dev/null 2>&1; then
	true
else
	printf "[%s]: md5sum or an equivalent must be installed to check md5 hashes.\n" "$(date +'%H:%M:%S')" >&2
	return 3
fi
