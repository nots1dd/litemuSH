# Maintainer: Siddharth Karanam <sid9.karanam@gmail.com>
pkgname=litemus
pkgver=1.0.0
pkgrel=1
pkgdesc="A lightweight music player written in shell"
arch=('x86_64')
url="https://github.com/nots1dd/litemus"
license=('MIT')
depends=('jq' 'ffmpeg' 'gum')
makedepends=('git')
source=("git+https://github.com/nots1dd/litemus.git")
sha256sums=('SKIP') # Replace 'SKIP' with the actual checksum

pkgver() {
  cd "$srcdir/litemus"
  git describe --long --tags | sed 's/\([^-]*-g\)/r\1/;s/-/./g'
}

build() {
  cd "$srcdir/litemus"
  # No need for configure script, assuming the build process is handled by Makefile
  make
}

package() {
  cd "$srcdir/litemus"
  make DESTDIR="$pkgdir/" install
  # Ensure that license file is included in the package
  install -Dm755 lmus "$pkgdir/usr/bin/lmus"
  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}


# vim:set ts=2 sw=2 et:
