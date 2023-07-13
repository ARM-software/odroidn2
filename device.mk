#-----------------------------------------------------------------------------
# The proprietary software and information contained in this file is
# confidential and may only be used by an authorized person under a valid
# licensing agreement from Arm Limited or its affiliates.
#
# Copyright (C) 2019-2023. Arm Limited or its affiliates. All rights reserved.
#
# This entire notice must be reproduced on all copies of this file and
# copies of this file may only be made by an authorized person under a valid
# licensing agreement from Arm Limited or its affiliates.
#-----------------------------------------------------------------------------

#
# Copyright (C) 2019 The Android Open-Source Project
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

# Enable Treble and other requirements from Android T
PRODUCT_SHIPPING_API_LEVEL := 33
PRODUCT_OTA_ENFORCE_VINTF_KERNEL_REQUIREMENTS := false
PRODUCT_ENFORCE_VINTF_MANIFEST_OVERRIDE := true

KERNEL ?= 5.10

# Enable updating of APEXes
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# 64-bit Android with 32-bit compatibility
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)

# Default Dalvik heap config for tablets with memory >= 2GB
$(call inherit-product, frameworks/native/build/tablet-10in-xhdpi-2048-dalvik-heap.mk)

# Enable scoped storage
$(call inherit-product, $(SRC_TARGET_DIR)/product/emulated_storage.mk)

# Graphics support
$(call inherit-product-if-exists,$(LOCAL_PATH)/graphics/graphics.mk)

# Dummy memtrack support
$(call inherit-product-if-exists,$(LOCAL_PATH)/memtrack/memtrack.mk)

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/fstab.odroidn2.ramdisk:$(TARGET_COPY_OUT_RAMDISK)/fstab.odroidn2 \
    $(LOCAL_PATH)/fstab.odroidn2.ramdisk:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.odroidn2-usb \
    $(LOCAL_PATH)/fstab.odroidn2:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.odroidn2 \
    $(LOCAL_PATH)/init.odroidn2.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.odroidn2.rc \
    $(LOCAL_PATH)/init.odroidn2.power.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.odroidn2.power.rc \
    $(LOCAL_PATH)/init.odroidn2.usb.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/init.odroidn2.usb.rc \
    $(LOCAL_PATH)/setserialno.sh:$(TARGET_COPY_OUT_VENDOR)/bin/setserialno.sh

# Build and run only ART
PRODUCT_RUNTIMES := runtime_libart_default

PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.ethernet.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.ethernet.xml \
    frameworks/native/data/etc/android.software.app_widgets.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.software.app_widgets.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_video.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_video.xml \
    frameworks/av/media/libstagefright/data/media_codecs_google_audio.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_google_audio.xml \
    device/arm/odroidn2/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    device/arm/odroidn2/ueventd.odroidn2.rc:$(TARGET_COPY_OUT_VENDOR)/etc/ueventd.rc \
    device/arm/odroidn2/gpu.xml:$(TARGET_COPY_OUT_VENDOR)/etc/gralloc/gpu.xml \

PRODUCT_COPY_FILES += $(call add-to-product-copy-files-if-exists, $(LOCAL_PATH)/busybox:$(TARGET_COPY_OUT_SYSTEM)/xbin/busybox) \
    $(call add-to-product-copy-files-if-exists, $(LOCAL_PATH)/busybox:$(TARGET_COPY_OUT_RAMDISK)/busybox)

PRODUCT_COPY_FILES += $(LOCAL_PATH)/seccomp_policy/mediaswcodec.policy:$(TARGET_COPY_OUT_VENDOR)/etc/seccomp_policy/mediaswcodec.policy

# HALs
AUDIOSERVER_MULTILIB := 64
PRODUCT_PACKAGES += \
    audio.primary.default \
    audio.r_submix.default \
    android.hardware.soundtrigger@2.0-impl \
    android.hardware.keymaster@3.0-impl \
    android.hardware.keymaster@3.0-service \
    android.hardware.light@2.0-impl \
    android.hardware.audio@7.0-impl \
    android.hardware.audio.service \
    android.hardware.audio.effect@7.0-impl \
    android.hardware.broadcastradio@1.0-impl \
    health.default \
    android.hardware.health \
    android.hardware.health-service.example \
    android.hardware.soundtrigger@2.0-impl \
    android.hardware.gatekeeper@1.0-service.software \
    android.hardware.usb@1.0-service \
    android.hardware.power-service.example \
    android.hardware.thermal@2.0-service.mock

# audio policy configuration
USE_XML_AUDIO_POLICY_CONF := 1
PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/audio_policy.conf:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy.conf \
    frameworks/av/services/audiopolicy/config/audio_policy_configuration_generic.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/primary_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/primary_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    frameworks/av/services/audiopolicy/config/surround_sound_configuration_5_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/surround_sound_configuration_5_0.xml \
    frameworks/av/services/audiopolicy/config/default_volume_tables.xml:$(TARGET_COPY_OUT_VENDOR)/etc/default_volume_tables.xml \
    frameworks/av/services/audiopolicy/config/audio_policy_volumes.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_volumes.xml


PRODUCT_COPY_FILES += device/arm/odroidn2/public.libraries.txt:$(TARGET_COPY_OUT_VENDOR)/etc/public.libraries.txt

PRODUCT_PROPERTY_OVERRIDES += \
    persist.sys.strictmode.disable=true \
    ro.sf.lcd_density=160 \
    service.adb.tcp.port=5555 \
    ro.surface_flinger.protected_contents=true

# TODO: disable this service once we implement system suspend
PRODUCT_PACKAGES += suspend_blocker

DEVICE_PACKAGE_OVERLAYS := $(LOCAL_PATH)/overlay

ODROID_MOD_DIR := device/arm/odroidn2/$(KERNEL)
ODROID_MODS := $(wildcard $(ODROID_MOD_DIR)/*.ko)
ifneq ($(ODROID_MODS),)
    MALI_MODS += \
		 $(wildcard $(ODROID_MOD_DIR)/*kutf*.ko) \
		 $(wildcard $(ODROID_MOD_DIR)/dma_buf_lock.ko) \
		 $(wildcard $(ODROID_MOD_DIR)/*dma-buf-test*.ko) \
		 $(wildcard $(ODROID_MOD_DIR)/memory_group_manager.ko) \
		 $(wildcard $(ODROID_MOD_DIR)/enable_pmu_access.ko) \
		 $(wildcard $(ODROID_MOD_DIR)/*mali*.ko)
    BOARD_VENDOR_KERNEL_MODULES += $(ODROID_MODS)
    BOARD_VENDOR_KERNEL_MODULES_LOAD += $(filter-out $(MALI_MODS),$(ODROID_MODS))
endif
