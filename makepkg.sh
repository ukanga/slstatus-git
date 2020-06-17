#!/bin/bash

# Maintainer: Ukang'a Dickson <ukanga@gmail.com>

pkgname=slstatus-git
pkgver=r540.dd7f189
pkgrel=1
pkgdesc='A status monitor for window managers'
arch=('i686' 'x86_64')
url='http://tools.suckless.org/slstatus'
depends=('libx11')
makedepends=('git')
license=('custom:ISC')
source=("git://git.suckless.org/${pkgname%-git}"
        "config.h")
md5sums=('SKIP'
         9cdec28f720abbb88a333bd3aa49c311)

pkgver() {
    cd "${pkgname%-git}"
    printf "r%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

prepare() {
    cp config.h "${pkgname%-git}/config.h"
}

build() {
    cd "${pkgname%-git}"
    make X11INC='/usr/include/X11' X11LIB='/usr/lib/X11'
}

package() {
    sudo make DESTDIR="${pkgdir}" PREFIX='/usr/' install

    sudo install -Dm644 LICENSE "${pkgdir}/usr/share/licenses/${pkgname%-git}/LICENSE"
}

prepare_sources() {
    # pkgdir=("$(pwd)/pkg")
    srcdir=("$(pwd)/src")
    rm -rf "${srcdir}" && mkdir -p "${srcdir}" && cd "${srcdir}"
    for file in "${source[@]}"; do
	if [[ "$file" == *.diff || "$file" == *.patch || "$file" == *.h ]]; then
	    cp "$(dirname $(pwd))/$file" .
	fi
    done
    if [[ "$?" == 0 ]]; then
	git clone "${source}"
    else
	exit 1
    fi
}

prepare_sources
if [[ "$?" == 0 ]]; then
    prepare || exit 1
fi
if [[ "$?" == 0 ]]; then
  build || exit 1
fi
if [[ "$?" == 0 ]]; then
    package || exit 1
fi
if [[ "$?" == 0 ]]; then
  echo "Success"
else
  echo "Something went wrong!"  && exit 1
fi
