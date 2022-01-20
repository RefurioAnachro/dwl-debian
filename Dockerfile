
FROM debian:bullseye-slim

RUN mkdir /src

RUN apt-get update

# libc6-dev : xlocale.h

RUN apt-get install -y \
    cmake \
    gcc \
    git \
    libc6-dev \
    libevdev-dev \
    libgbm-dev \
    libmtdev-dev \
    libpciaccess-dev \
    libpixman-1-dev \
    libudev-dev \
    libwacom-dev \
    libxkbcommon-dev \
    pkg-config \
    python3-pip \
 && echo .

RUN pip install meson ninja

#RUN cd /src && clone https://gitlab.freedesktop.org/xorg/lib/libxcvt.git --depth 1 --branch=libxcvt-0.1.0
#RUN cd /src/libxcvt && meson build && ninja -C build -j4 install

#RUN cd src && git clone https://gitlab.freedesktop.org/xorg/proto/xorgproto.git --depth 1 --branch=xorgproto-2021.4.99.2
#RUN cd /src/xorgproto && ./autogen.sh && make -j4

# libwacom=true
# debug-gui=true
# tests=true
# install-tests=false
# documentation=false
# coverity=false
# zshcompletiondir=  # 'no' disables
RUN cd src && git clone https://gitlab.freedesktop.org/libinput/libinput.git --depth 1
RUN cd /src/libinput \
 && meson -Ddebug-gui=false -Dtests=false build \
 && ninja -C build -j4 install

# 1.22
RUN cd /src && git clone https://gitlab.freedesktop.org/wayland/wayland-protocols.git --depth 1 --branch=1.24
RUN cd /src/wayland-protocols \
 && meson -Dtests=false build \
 && ninja -C build -j4 install

# libraries=true
# scanner=true
# tests=true
# documentation=true
# dtd_validation=true
# icon_directory=
RUN cd /src && git clone https://gitlab.freedesktop.org/wayland/wayland.git --depth 1 --branch=1.20.0
RUN cd /src/wayland \
 && meson -Dtests=false -Ddocumentation=false -Ddtd_validation=false build \
 && ninja -C build -j4 install

RUN cd /src && git clone https://git.sr.ht/~kennylevinsen/seatd --depth 1 --branch=0.6.3
RUN cd /src/seatd \
 && meson build \
 && ninja -C build -j4 install

#RUN apt-get install -y libdrm-dev
# need libdrm >=2.4.109 but debian has merely >=2.4.104

RUN apt-get install -y 

# libkms=auto
# intel=auto
# radeon=auto
# amdgpu=auto
# nouveau=auo
# vmwgfx=true
# omap=false
# exynos=false
# freedreno=auto
# tegra=false
# vc4=auto
# etnaviv=false
# cairo-tests=auto
# man-pages=auto
# valgrind=auto
# freedreno-kgsl=false
# install-test-programs=false
# udev=false
RUN cd /src && git clone https://gitlab.freedesktop.org/mesa/drm.git --depth 1 --branch=libdrm-2.4.109
RUN cd /src/drm \
 && meson -Dman-pages=false build \
 && ninja -C build -j4 install

# xcb-errors=auto
# xwayland=auto
# examples=true
# icon_directory=
# renderers=auto # ['auto', 'gles2', 'vulkan']
# backends=auto # ['auto', 'drm', 'libinput', 'x11']
RUN cd /src && git clone https://gitlab.freedesktop.org/wlroots/wlroots.git --depth 1 --branch=0.15.0
RUN cd /src/wlroots \
 && meson build \
 && ninja -C build -j4 install

# Package xcb was not found

RUN cd /src && git clone https://github.com/djpohly/dwl.git --depth 1 --branch=v0.2.2
RUN cd /src/dwl \
 && cp config.def.h config.h \
 && make

# dependencies according to https://gitlab.freedesktop.org/wlroots/wlroots

# meson
# wayland
# wayland-protocols
# EGL and GLESv2 (optional, for the GLES2 renderer)
# Vulkan loader, headers and glslang (optional, for the Vulkan renderer)
# libdrm
# GBM
# libinput (optional, for the libinput backend)
# xkbcommon
# udev
# pixman
# libseat https://git.sr.ht/~kennylevinsen/seatd

# If you choose to enable X11 support:

# xwayland (build-time only, optional at runtime)
# libxcb
# libxcb-render-util
# libxcb-wm
# libxcb-errors (optional, for improved error reporting)

COPY run.sh /run.sh
RUN chmod 755 /run.sh
