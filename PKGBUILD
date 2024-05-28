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
  # Fallback to a simpler versioning scheme if git describe fails
  git_version=$(git describe --long --tags 2>/dev/null || git rev-parse --short HEAD)
  printf "r%s.%s" "$(git rev-list --count HEAD)" "$git_version"
}


build() {
  cd "$srcdir/litemus"
}

package() {
  cd "$srcdir/litemus"
#   make DESTDIR="$pkgdir/" install
  # Ensure that license file is included in the package
  install -Dm755 lmus "$pkgdir/usr/bin/lmus"
  install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}


# vim:set ts=2 sw=2 et:
