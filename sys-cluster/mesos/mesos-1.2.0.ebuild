# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit autotools eutils

DESCRIPTION="A cluster manager that provides efficient resource isolation and sharing across distributed applications"
HOMEPAGE="http://mesos.apache.org/"
SRC_URI="http://archive.apache.org/dist/${PN}/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
KEYWORDS="~amd64 ~x86"
IUSE="network-isolator perftools install-module-dependencies"
SLOT="0"

RDEPEND=">=dev-libs/apr-1.5.2
        >=net-misc/curl-7.43.0
        network-isolator? ( dev-libs/libnl )
        dev-libs/cyrus-sasl
        dev-vcs/subversion"
DEPEND=$RDEPEND

src_prepare() {
        epatch "${FILESDIR}/mesos-stout-cloexec.patch"
        epatch "${FILESDIR}/mesos-linux-ns-nosetns.patch"
        eautoreconf
}

src_configure() {
        # See https://issues.apache.org/jira/browse/MESOS-7286
        MESOS_LIB_PREFIX="${EROOT}/usr"
        export SASL_PATH="${MESOS_LIB_PREFIX}/lib/sasl2"
        export LD_LIBRARY_PATH="${MESOS_LIB_PREFIX}/lib:$LD_LIBRARY_PATH"
        MESOS_CONF_ARGS="--build=x86_64-pc-linux-gnu --host=x86_64-pc-linux-gnu \
                $(use_enable perftools) \
                $(use_enable install-module-dependencies) \
                $(use_with network-isolator) \
                --disable-python \
                --disable-java \
                --enable-optimize \
                --disable-dependency-tracking \
                --with-apr=${MESOS_LIB_PREFIX} \
                --with-curl=${MESOS_LIB_PREFIX} \
                --with-sasl=${MESOS_LIB_PREFIX} \
                --with-svn=${MESOS_LIB_PREFIX}"
        if use network-isolator; then
                MESOS_CONF_ARGS="${MESOS_CONF_ARGS} --with-nl=${MESOS_LIB_PREFIX}"
        fi
        econf ${MESOS_CONF_ARGS}
}

src_compile() {
        emake
}

src_test() {
        emake check
}

src_install() {
        emake DESTDIR="${D}" install
}
