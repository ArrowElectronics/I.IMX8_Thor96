# Copyright (C) 2020-2021 Einfochips


PATCHTOOL = "git"

FILESEXTRAPATHS_prepend := "${THISDIR}/linux-imx/imx8mqthor96:"

SRC_URI_append_imx8mqthor96 += "file://0017-media-uapi-Add-an-entity-type-for-Image-Signal-Proce.patch\
					file://0018-media-bus-uapi-Add-YCrCb-420-media-bus-format-and-rs.patch \
					file://0019-media-i2c-Add-ON-Semiconductor-AP1302-ISP-driver.patch \
					file://0020-media-dt-bindings-media-i2c-Add-bindings-for-AP1302.patch \
					file://0021-IMX8MQ-Added-AP1302-ISP-support-to-enable-AR0430-cam.patch \
					file://0022-IMX8MQ-Removed-unused-camera-controls.patch \
					file://0023-IMX8M-Added-v4l2-control-support-in-Thor96.patch \
					file://0024-IMX8MQ-Added-ARX3A0-camera-sensor-support.patch \
					file://0025-IMX8M-Set-v4l2-ISP-controls-default-value-from-AP130.patch \
					file://0026-IMX8M-Added-support-for-AR1335-camera-sensor.patch \
					file://0027-IMX8M-Added-auto-focus-feature-support.patch \
					file://0028-IMX8M-Resolved-the-AF-square-box-issue-for-ARX3A0-an.patch \
					file://0029-IMX8M-Added-changes-to-make-Auto-Focus-functionality.patch \
					file://0030-IMX8MQ-Added-AR0830-camera-sensor-support.patch \
					file://0031-IMX8MQ-modify-ap1302-driver-to-support-AR0830-camera.patch \
		"
