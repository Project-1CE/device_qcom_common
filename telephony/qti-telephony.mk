# Copyright (C) 2021 Paranoid Android
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

PRODUCT_SOONG_NAMESPACES += \
    device/qcom/common/telephony

# APN List
PRODUCT_COPY_FILES += \
    device/qcom/common/telephony/apns-conf.xml:$(TARGET_COPY_OUT_PRODUCT)/etc/apns-conf.xml \

# Carrier config
PRODUCT_PACKAGES += \
    CarrierConfigResCommon

# Data Services
$(call inherit-product, vendor/qcom/opensource/dataservices/dataservices_vendor_product.mk)

# HIDL
SYSTEM_EXT_MANIFEST_FILES += device/qcom/common/telephony/framework_manifest.xml

# IPACM
ifneq (,$(filter 5.10, $(TARGET_KERNEL_VERSION)))
PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/data-ipa-cfg-mgr
$(call inherit-product, vendor/qcom/opensource/data-ipa-cfg-mgr/ipacm_vendor_product.mk)
else
PRODUCT_SOONG_NAMESPACES += vendor/qcom/opensource/data-ipa-cfg-mgr-legacy
$(call inherit-product, vendor/qcom/opensource/data-ipa-cfg-mgr-legacy/ipacm_vendor_product.mk)
endif

# RIL
ENABLE_VENDOR_RIL_SERVICE := true

PRODUCT_VENDOR_PROPERTIES += \
    persist.radio.multisim.config=dsds \
    persist.vendor.radio.apm_sim_not_pwdn=1 \
    persist.vendor.radio.custom_ecc=1 \
    persist.vendor.radio.enableadvancedscan=true \
    persist.vendor.radio.procedure_bytes=SKIP \
    persist.vendor.radio.sib16_support=1

# Packages
PRODUCT_PACKAGES += \
    CellBroadcastReceiver \
    android.hardware.radio@1.6 \
    android.hardware.radio.config@1.3 \
    android.hardware.radio.deprecated@1.0 \
    extphonelib \
    extphonelib-product \
    extphonelib.xml \
    extphonelib_product.xml \
    ims-ext-common \
    ims_ext_common.xml \
    libjson \
    Stk \
    tcmiface \
    telephony-ext \
    qti-telephony-hidl-wrapper \
    qti-telephony-hidl-wrapper-prd \
    qti_telephony_hidl_wrapper.xml \
    qti_telephony_hidl_wrapper_prd.xml \
    qti-telephony-utils \
    qti-telephony-utils-prd \
    qti_telephony_utils.xml \
    qti_telephony_utils_prd.xml

PRODUCT_BOOT_JARS += \
    tcmiface \
    telephony-ext

# Permissions
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.sip.voip.xml

# Properties
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    DEVICE_PROVISIONED=1 \
    net.tethering.noprovisioning=true \
    persist.sys.fflag.override.settings_network_and_internet_v2=true \
    persist.vendor.cne.feature=1 \
    persist.vendor.data.mode=concurrent \
    persist.vendor.dpm.feature=11 \
    persist.vendor.dpm.idletimer.mode=default \
    ril.subscription.types=NV,RUIM \
    ro.telephony.default_network=33,33 \
    ro.telephony.sim_slots.count=2 \
    ro.vendor.use_data_netmgrd=true \
    telephony.active_modems.max_count=2 \
    telephony.lteOnCdmaDevice=1

ifneq ($(TARGET_BUILD_VARIANT),eng)
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.vendor.ims.disableADBLogs=1 \
    persist.vendor.ims.disableDebugLogs=1 \
    persist.vendor.ims.disableIMSLogs=1 \
    persist.vendor.ims.disableQXDMLogs=1
endif

ifneq (,$(filter 3.18 4.4 4.9 4.14 4.19 5.4, $(TARGET_KERNEL_VERSION)))
PRODUCT_VENDOR_PROPERTIES += \
    persist.vendor.radio.rat_on=combine
endif

# Force VoLTE/VoWiFi/ViLTE
PRODUCT_SYSTEM_EXT_PROPERTIES += \
    persist.dbg.volte_avail_ovr=1 \
    persist.dbg.wfc_avail_ovr=1 \
    persist.dbg.vt_avail_ovr=1

# Sensitive Phone Numbers list
PRODUCT_COPY_FILES += \
    device/qcom/common/telephony/sensitive_pn.xml:$(TARGET_COPY_OUT_SYSTEM)/etc/sensitive_pn.xml
