# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit git-r3
DESCRIPTION="my init scripts"
HOMEPAGE=""
EGIT_REPO_URI="${CODEDIR}""/openrc-init-scripts https://github.com/alexander-n8hgeg5e/openrc-init-scripts.git"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND} sys-apps/openrc
	acct-user/in_tftpd_skyscraper
	acct-user/in_tftpd_dusteater
	acct-group/in_tftpd_skyscraper
	acct-group/in_tftpd_dusteater
	acct-user/in_tftpd_esadc
	acct-group/in_tftpd_esadc
"

src_install(){
	hostname="$(hostname)"
	doinitd etc/init.d/nbd-swap
	doinitd etc/init.d/x
	doinitd etc/init.d/node
	doinitd etc/init.d/in-tftpd-node
	doinitd etc/init.d/nbd-server
	doinitd etc/init.d/nbd-server-part

	etc_confd_dir="etc/conf.d"
	dodir "${etc_confd_dir}"
	insinto "${etc_confd_dir}"
	doins "${etc_confd_dir}/dusteater"
	doins "${etc_confd_dir}/bootmisc"

	rel_inst_path="usr/sbin"
	for username in skyscraper dusteater esadc;do
		name="in_tftpd_${username}"
		#dosym "in_tftpd_node" "etc/init.d/${name}"
		if ! use_if_iuse "tftpd_fcap_users_${username}";then
			dosym "in.tftpd" "${rel_inst_path}/${name}"
		fi
	done

	# set_netifnames tool
	dosbin usr/sbin/set_netifnames
	doinitd etc/init.d/netifnames
	doinitd etc/init.d/cg_bg
	dosbin usr/sbin/gen_io_lat_strings
	doinitd etc/init.d/run_subdirs
	doinitd etc/init.d/tmp
	doinitd etc/init.d/tmp-backing-remote
	doinitd etc/init.d/tmp-backing-local
	doinitd etc/init.d/tmp_subdirs
	doinitd etc/init.d/nbd-blockdev
	doinitd etc/init.d/remote-service
	doinitd etc/init.d/cluster-service-linkname-config
	doinitd etc/init.d/cluster-service
	doinitd etc/init.d/ramdisk-file
	doinitd etc/init.d/net.node
	doinitd etc/init.d/link-name-provide

	lib_rc_sh_dir="lib/rc/sh"
	dodir   "${lib_rc_sh_dir}"
	insinto "${lib_rc_sh_dir}"
	doins "${lib_rc_sh_dir}/rc-linkname-parsers.sh"

	doinitd etc/init.d/prepare_sysklogd
}
