#!/usr/bin/env bash
source /tmp/release.properties

configure_gpdb(){
source /usr/local/greenplum-db/greenplum_path.sh
 cat >> /home/gpadmin/.bashrc << EOF
source /usr/local/greenplum-db/greenplum_path.sh
EOF
}


_main() {
	configure_gpdb

}



_main "$@"
