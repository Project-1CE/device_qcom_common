#
# Copyright (C) 2022 Project ICE
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

ifeq ($(TARGET_BOARD_PLATFORM),)
$(error "TARGET_BOARD_PLATFORM is not defined yet, please define in your device makefile so it's accessible to QCOM common.")
endif

include $(LOCAL_PATH)/qcom_boards.mk

TARGET_COMPILE_WITH_MSM_KERNEL := true
TARGET_HAS_QC_KERNEL_SOURCE := true
BOARD_USES_ADRENO := true
BOARD_USES_QCNE := true

# Allow building audio encoders
TARGET_USES_QCOM_MM_AUDIO := true

# Skip boot jars check
SKIP_BOOT_JARS_CHECK := true

# Compatibility matrix
ifeq ($(TARGET_FWK_SUPPORTS_FULL_VALUEADDS),true)
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += \
    vendor/qcom/opensource/core-utils/vendor_framework_compatibility_matrix.xml
endif

# SECCOMP Extension
BOARD_SECCOMP_POLICY += device/qcom/common/seccomp

PRODUCT_COPY_FILES += \
    device/qcom/common/seccomp/mediacodec-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediacodec.policy \
    device/qcom/common/seccomp/mediaextractor-seccomp.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaextractor.policy

# Mark GRALLOC_USAGE_PRIVATE_WFD as valid gralloc bits
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS ?= 0
TARGET_ADDITIONAL_GRALLOC_10_USAGE_BITS += | (1 << 21)

# Advanced DPM
ifeq ($(TARGET_WANTS_EXTENDED_DPM_PLATFORM),true)
PRODUCT_BOOT_JARS += tcmclient
PRODUCT_BOOT_JARS += com.qti.dpmframework
PRODUCT_BOOT_JARS += dpmapi
PRODUCT_BOOT_JARS += com.qti.location.sdk
endif

# 845 series and newer
ifneq (,$(filter audio, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(LOCAL_PATH)/audio/qti-audio.mk
endif

ifneq (,$(filter bt, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(LOCAL_PATH)/bt/qti-bt.mk
endif

ifneq (,$(filter display, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(LOCAL_PATH)/display/qti-display.mk
endif

ifneq (,$(filter 5.10 5.15, $(TARGET_KERNEL_VERSION)))
include $(LOCAL_PATH)/dlkm/qti-dlkm.mk
endif

ifneq (,$(filter gps, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(LOCAL_PATH)/gps/qti-gps.mk
endif

ifneq (,$(filter perf, $(TARGET_COMMON_QTI_COMPONENTS)))
ifeq (,$(filter 5.10 5.15, $(TARGET_KERNEL_VERSION)))
include $(LOCAL_PATH)/perf/qti-perf.mk
endif
endif

ifneq (,$(filter telephony, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(LOCAL_PATH)/telephony/qti-telephony.mk
endif

ifneq (,$(filter usb, $(TARGET_COMMON_QTI_COMPONENTS)))
include $(LOCAL_PATH)/usb/qti-usb.mk
endif

# Nxp NFC
ifeq ($(TARGET_USES_NQ_NFC),true)
PRODUCT_PACKAGES += \
    vendor.nxp.hardware.nfc@2.0-service \
    nfc_nci.nqx.default.hw
endif

# QCOM HW crypto
ifeq ($(TARGET_HW_DISK_ENCRYPTION),true)
    TARGET_CRYPTFS_HW_PATH ?= vendor/qcom/opensource/commonsys/cryptfs_hw
endif

# Soong namespace
SOONG_CONFIG_NAMESPACES += qssi_vs_vendor
SOONG_CONFIG_qssi_vs_vendor += qssi_or_vendor
SOONG_CONFIG_qssi_vs_vendor_qssi_or_vendor := qssi

SOONG_CONFIG_NAMESPACES += aosp_vs_qva
SOONG_CONFIG_aosp_vs_qva += aosp_or_qva
ifeq ($(TARGET_FWK_SUPPORTS_FULL_VALUEADDS),true)
SOONG_CONFIG_aosp_vs_qva_aosp_or_qva := qva
else
SOONG_CONFIG_aosp_vs_qva_aosp_or_qva := aosp
endif

SOONG_CONFIG_NAMESPACES += bredr_vs_btadva
SOONG_CONFIG_bredr_vs_btadva += bredr_or_btadva
SOONG_CONFIG_bredr_vs_btadva_bredr_or_btadva := bredr
