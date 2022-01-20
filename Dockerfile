
FROM debian:bullseye-slim

RUN mkdir /src

RUN apt-get update

# libc6-dev : xlocale.h

RUN apt-get install -y \
    cmake \
    gcc \
    git \
    libc6-dev \
    libcairo2-dev \
    libevdev-dev \
    libgbm-dev \
    libmtdev-dev \
    libpam0g-dev \
    libpango1.0-dev \
    libpciaccess-dev \
    libpixman-1-dev \
    libudev-dev \
    libwacom-dev \
    libx11-xcb-dev \
    libxcb-composite0-dev \
    libxcb-dri3-dev \
    libxcb-present-dev \
    libxcb-render-util0-dev \
    libxcb-shm0-dev \
    libxcb-xinput-dev \
    libxcb1-dev \
    libxcursor-dev
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

#RUN apt-get install -y libdrm-dev
# need libdrm >=2.4.109 but debian has merely >=2.4.104

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

# libseat-logind=auto # needs libelogind0 or libsystemd-dev (untested)
# libseat-seatd=enabled
# libseat-builtin=disabled
# server=enabled
# examples=disabled
# man-pages=auto # needs scdoc
# defaultpath=
RUN cd /src && git clone https://git.sr.ht/~kennylevinsen/seatd --depth 1 --branch=0.6.3
RUN cd /src/seatd \
 && meson build \
 && ninja -C build -j4 install
# libelogind found: NO
# libsystemd found: NO

# backend-drm=true
# backend-drm-screencast-vaapi=true
# backend-headless=true
# backend-rdp=true
# screenshare=true
# backend-wayland=true
# backend-x11=true
# backend-fbdev=true
# backend-default=combo # [ 'auto', 'drm', 'wayland', 'x11', 'fbdev', 'headless' ]
# renderer-gl=true
# weston-launch=true
# xwayland=true
# xwayland-path=
# systemd=true
# remoting=true
# pipewire=true
# shell-desktop=true
# shell-fullscreen=true
# shell-ivi=true
# shell-kiosk=true
# desktop-shell-client-default=weston-desktop-shell
# deprecated-wl-shell=false
# color-management-lcms=true
# color-management-colord=true
# launcher-logind=true
# launcher-libseat=false # not yet supported in version 9.0
# image-jpeg=true
# image-webp=true
# tools=
# demo-clients=true
# simple-clients=all # [ 'all', 'damage', 'im', 'egl', 'shm', 'touch', 'dmabuf-feedback', 'dmabuf-v4l', 'dmabuf-egl' ] # ,dmabuf-feedback not supported in version 9.0
# resize-pool=true
# wcap-decode=true
# test-junit-xml=true
# test-skip-is-failure=false
# test-gl-renderer=true
# doc=false
RUN cd /src && git clone https://gitlab.freedesktop.org/wayland/weston.git --depth 1 --branch=9.0
RUN cd /src/weston \
 && meson \
    -Dimage-jpeg=false \
    -Dimage-webp=false \
    -Drenderer-gl=false \
    -Dlauncher-logind=false \
    -Dbackend-drm-screencast-vaapi=false \
    -Dbackend-drm=false \
    -Dbackend-default=x11 \
    -Dbackend-rdp=false \
    -Dcolor-management-lcms=false \
    -Dcolor-management-colord=false \
    -Dsystemd=false \
    -Dremoting=false \
    -Dpipewire=false \
    -Dsimple-clients=damage,im,shm,touch,dmabuf-v4l \
    -Ddemo-clients=false \
    -Dtest-junit-xml=false \
    -Dxwayland=true \
    build \
 && ninja -C build -j4 install
# libsystemd-dev # or -Dlauncher-logind=false -Dsystemd=false
# freerdp2-dev # or -Dbackend-rdp=false
# liblcms2-dev # or -Dcolor-management-lcms=false  -Dcolor-management-colord=false
# drm and gl renderer # or -Dremoting=false
# egl # or -Ddemo-clients=false

# xcb-errors=auto
# xwayland=auto
# examples=true
# icon_directory=
# renderers=auto # ['auto', 'gles2', 'vulkan']
# backends=auto # ['auto', 'drm', 'libinput', 'x11']
RUN cd /src && git clone https://gitlab.freedesktop.org/wlroots/wlroots.git --depth 1 --branch=0.15.0
RUN cd /src/wlroots \
 && meson build \
    -Dxwayland=enabled \
 && ninja -C build -j4 install

RUN cd /src && git clone https://github.com/djpohly/dwl.git --depth 1 --branch=v0.2.2
RUN cd /src/dwl \
 && cp config.def.h config.h \
 && echo CFLAGS += -DXWAYLAND >> config.mk \
 && echo CFLAGS += -I/src/wlroots/include >> config.mk \
 && make

COPY run.sh /run.sh
RUN chmod 755 /run.sh
