#!@TERMUX_PREFIX@/bin/bash

archivestart="$(awk '$0 == "__ARCHIVE_START__" {print NR + 1; exit 0}' "${BASH_SOURCE[0]}")"
eval "$(tail -n +"$archivestart" "${BASH_SOURCE[0]}" | zcat)"

exit 0
__ARCHIVE_START__