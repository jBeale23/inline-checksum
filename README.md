# Inline-Checksum
A POSIX compliant rework of inline-md5sum, adding support for sha256 and sha512 checksums.

This script is designed to alleviate some of the security concerns of running `curl <url> | sh -` by validating its input against a checksum before passing it along.
It also serves as a convenience wrapper for validating the checksum of an already existing file.

# Installation
Clone the repository, put `inline-checksum` anywhere on your $PATH, and make sure it's executable, and you're all set.

You can run the full test suite by running `make test` to ensure that all dependencies are met and that things are behaving as you'd expect.
After running the test suite, you can clean up the generated log files with `make clean`.

# Usage
Assuming a site provides it, a checksum can be used to verify a downloaded script before running it as follows:
```sh
curl -fsSL <url> | inline-checksum [--algorithm[=| ]<sha256|sha512|md5>] <checksum> | sh -
```

Alternatively, a local file can have its checksum validated as follows:
```sh
inline-checksum [--algorithm[=| ]<sha256|sha512|md5>] <checksum> <file>
```

# Origin
Inline-Checksum is adapted and updated from the following source:
- The work of Cruz Monrreal at https://github.com/cmonr/inline-md5sum under the terms of the MIT License.

# License
Inline-Checksum is licensed under the terms of the [MIT License](https://github.com/jBeale23/inline-checksum/blob/main/LICENSE).
