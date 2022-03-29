# Copyright (C) 2022 Deepak Rathore <deepak.rathore@einfochips.com>
# Released under the MIT license (see COPYING.MIT for the terms)

DESCRIPTION = "Root file system customization"

LICENSE = "MIT"

LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI += "file://modules.conf"

do_install() {
    install -d ${D}${sysconfdir}/modules-load.d
    install -m 755 ${WORKDIR}/modules.conf ${D}${sysconfdir}/modules-load.d/
}

FILES_${PN} += "${sysconfdir}/etc/modules-load.d/modules.conf"
