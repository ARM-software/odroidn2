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

# Gralloc
GRALLOC_DISABLE_FRAMEBUFFER_HAL := 1
GRALLOC_USE_ION_DMA_HEAP := 1
GRALLOC_HWC_FB_DISABLE_AFBC := 1
GRALLOC_USE_CONTIGUOUS_DISPLAY_MEMORY :=1

# Include board specific mali configuration files if they exist.
# They won't exist when building with MALI_DISABLED.
-include vendor/arm/mali/gpu/product/android/gralloc/gralloc.device.mk
-include vendor/arm/mali/gpu/product/android/renderscript/renderscript.device.mk

# Pull in mali_gpu.mk from either prebuilts or source
$(call inherit-product-if-exists,vendor/arm/mali/gpu/product/mali_gpu.mk)
$(call inherit-product-if-exists,device/arm/odroidn2/graphics/mali_gpu_prebuilt/mali_gpu.mk)

PRODUCT_PACKAGES += libGLES_mali libOpenCL vulkan.mali mali_kbase libRSDriverArm vulkan.$(PRODUCT_NAME)

PRODUCT_PROPERTY_OVERRIDES += ro.opengles.version=196610

OVERRIDE_RS_DRIVER := libRSDriverArm.so

# DRM hwcomposer
TARGET_USES_HWC2 := true
ifeq ($(TARGET_HWCOMPOSER_DISABLE_BUILD),)
PRODUCT_PACKAGES += hwcomposer.drm_mappermetadata
endif
PRODUCT_PROPERTY_OVERRIDES += ro.hardware.hwcomposer=drm_mappermetadata
PRODUCT_PROPERTY_OVERRIDES += ro.hardware.egl=mali

# Force HWC to use the client backend
PRODUCT_VENDOR_PROPERTIES += vendor.hwc.backend_override=client

PRODUCT_COPY_FILES += \
    $(LOCAL_PATH)/mali_kbase.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/mali_kbase.rc

DEVICE_MANIFEST_FILE += device/arm/odroidn2/graphics/odroidn2-graphics.xml
# The graphics allocator, composer and mapper HAL interfaces are now optionally specified in the latest versions
# of the gralloc module. We will call this a VINTF_ENABLED gralloc submodule.
# These HAL interfaces must be declared somewhere for a build to succeed and they must not be declared twice.
# For this reason a VINTF_ENABLED gralloc submodule will detect the existence of "manifest_vintf.xml" in the BSP and
# will in turn generate a "vintf_enabled" file. If the vintf_enabled file is not detected then manifest_vintf.xml will
# be added to the DEVICE_MANIFEST_FILE
ifeq ($(wildcard vendor/arm/mali/gpu/product/android/gralloc/build_vintf/vintf_enabled),)
    DEVICE_MANIFEST_FILE += device/arm/odroidn2/graphics/manifest_vintf.xml
endif


BOARD_SEPOLICY_DIRS += device/arm/odroidn2/graphics/sepolicy
