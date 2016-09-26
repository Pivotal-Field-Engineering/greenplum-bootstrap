#!/usr/bin/env bash
source /tmp/release.properties

install_gpdb(){
 source /usr/local/greenplum-db/greenplum_path.sh
}

_main() {
	install_gpdb
}

_main "$@"
