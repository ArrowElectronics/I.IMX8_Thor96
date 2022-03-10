# Copyright (C) 2020-2021 Einfochips


PATCHTOOL = "git"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-imx/imx8mqthor96:"

SRC_URI_append_imx8mqthor96 += "file://0017-media-uapi-Add-an-entity-type-for-Image-Signal-Proce.patch \
					file://0018-media-bus-uapi-Add-YCrCb-420-media-bus-format-and-rs.patch \
					file://0019-media-i2c-Add-ON-Semiconductor-AP1302-ISP-driver.patch \
					file://0020-media-dt-bindings-media-i2c-Add-bindings-for-AP1302.patch \
					file://0021-arch-arm64-configs-Enable-AP1302-module-in-imx-defco.patch \
					file://0022-arch-arm64-boot-dts-Update-CSI1-freq-of-IMX8MQ.patch \
					file://0023-arch-arm64-boot-dts-Add-DT-binding-node-for-AP1302.patch \
					file://0024-drivers-media-i2c-Modify-AP1302-driver-to-work-on-IM.patch \
					file://0025-arch-arm64-configs-Increase-CMA-size.patch \
					file://0026-IMX8M-AP1302-compilation-changes-added.patch \
					file://0027-IMX8M-Added-support-for-ARX3A0-camera-sensor.patch \
					file://0028-IMX8M-Added-support-for-ARX3A0-camera-sensor.patch \
					file://0029-IMX8M-Changed-ARX3A0-resolution-to-720p-120fps.patch \
					file://0030-IMX8M-Set-v4l2-ISP-controls-default-value-from-AP130.patch \
				"
