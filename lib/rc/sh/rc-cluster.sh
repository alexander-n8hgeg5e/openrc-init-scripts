
__IFS="
"


_notify_nodes() {
    for node in $(cat /etc/nodelist);do
		[[ $node = $(hostname) ]] && continue
        ssh "root@${node}" rc-service "remote_${node}_${RC_SVCNAME}" status
        if [[ $? -ne 1 ]];then
            # service exists
            ssh "root@${node}" rc-service "remote_${node}_${RC_SVCNAME}" "${1}"
		fi
    done
}

notify_starting() {
    _notify_nodes notify_starting
}

notify_started() {
    _notify_nodes notify_started
}
notify_stopping() {
    _notify_nodes notify_stopping
}
notify_stopped() {
    _notify_nodes notify_stopped
}

# vim: set syntax=gentoo-init-d :
