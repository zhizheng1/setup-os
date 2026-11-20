#!/bin/sh

OS=$(uname)
if [ "$OS" = "Linux" ]; then
  PREFIX=/CLTools/usr
elif [ "$OS" = "Darwin" ]; then
  PREFIX=/Library/Developer/CLTools/usr
else
    printf 'Unsupported OS: %s\n' "$OS" >&2
    exit 1
fi

# readline gmp mpfr libpipeline jansson libyaml; unx: libmpfr-dev libpipeline-dev libjansson-dev libyaml-dev

export PATH="$PREFIX/bin:$PATH"

curl https://ftp.gnu.org/gnu/make/make-4.4.1.tar.gz|tar zxvf -
cd make-4.4.1
./configure --prefix=$PREFIX
make
sudo make install
cd ..; rm -rf make-4.4.1

curl https://www.cpan.org/src/5.0/perl-5.44.0.tar.gz|tar zxvf -
cd perl-5.44.0
./configure.gnu -Dprefix=$PREFIX -Dusethreads -Dman1dir=$PREFIX/share/man/man1 -Dman3dir=$PREFIX/share/man/man3 -Dman3ext=3pm
make
sudo make install
cd ..; rm -rf perl-5.44.0

curl -L https://github.com/universal-ctags/ctags/releases/download/v6.2.1/universal-ctags-6.2.1.tar.gz|tar zxvf -
cd universal-ctags-6.2.1
if [ "$OS" = "Linux" ]; then
  ./configure --prefix=$PREFIX --with-rst2man=true PKG_CONFIG=true LIBXML_LIBS=-lxml2 JANSSON_LIBS=-ljansson LIBYAML_LIBS=-lyaml PCRE2_LIBS=-lpcre2-8 SECCOMP_LIBS=-lseccomp CFLAGS=-I$PWD/../include LDFLAGS=-L$PWD/../lib
else
  ./configure --prefix=$PREFIX --with-rst2man=true --disable-seccomp PKG_CONFIG=true LIBXML_LIBS=-lxml2 JANSSON_LIBS=-ljansson LIBYAML_LIBS=-lyaml PCRE2_LIBS=-lpcre2-8 CFLAGS=-I$PWD/../include LDFLAGS=-L$PWD/../lib
fi
make
sudo make install
cd ..; rm -rf universal-ctags-6.2.1

curl -L https://github.com/vim/vim/archive/refs/tags/v9.2.1252.tar.gz|tar zxvf -
cd vim-9.2.1252
./configure --prefix=$PREFIX --with-compiledby=root@localhost
make
sudo make install
cd ..; rm -rf vim-9.2.1252

curl https://ftp.gnu.org/gnu/texinfo/texinfo-7.3.tar.gz|tar zxvf -
cd texinfo-7.3
./configure --prefix=$PREFIX
make
sudo make install
cd ..; rm -rf texinfo-7.3

curl https://ftp.gnu.org/gnu/groff/groff-1.25.0.tar.gz|tar zxvf -
cd groff-1.25.0
./configure --prefix=$PREFIX
make
sudo make install
cd ..; rm -rf groff-1.25.0

curl -L https://download.savannah.nongnu.org/releases/man-db/man-db-2.13.3.tar.xz|tar Jxvf -
cd man-db-2.13.3
if [ "$OS" = "Linux" ]; then
  ./configure --prefix=$PREFIX --disable-setuid --disable-cache-owner PKG_CONFIG=true libpipeline_CFLAGS=-I$PWD/../include libpipeline_LIBS="-L$PWD/../lib -lpipeline" libseccomp_LIBS=-lseccomp
else
  ./configure --prefix=$PREFIX --disable-setuid --disable-cache-owner --without-libseccomp PKG_CONFIG=true libpipeline_CFLAGS=-I$PWD/../include libpipeline_LIBS="-L$PWD/../lib -lpipeline"
fi
make
sudo make install
cd ..; rm -rf man-db-2.13.3

curl https://ftp.gnu.org/gnu/nano/nano-9.3.tar.gz|tar zxvf -
cd nano-9.3
if [ "$OS" = "Darwin" ]; then
  sed -i.0 -e 's/"-lncursesw/"-lncurses/g' -e 's/=ncursesw/=ncurses/g' configure
fi
./configure --prefix=$PREFIX
make
sudo make install
cd ..; rm -rf nano-9.3

curl https://ftp.gnu.org/gnu/bash/bash-5.3.tar.gz|tar zxvf -
cd bash-5.3
curl -s https://ftp.gnu.org/gnu/bash/bash-5.3-patches/|grep -oE 'bash53-[0-9]{3}'|sort -u|xargs -I {} sh -c 'curl -sL "https://ftp.gnu.org/gnu/bash/bash-5.3-patches/{}"|patch -p0'
./configure --prefix=$PREFIX
make
sudo make install
cd ..; rm -rf bash-5.3

curl https://ftp.gnu.org/gnu/screen/screen-5.0.2.tar.gz|tar zxvf -
cd screen-5.0.2
if [ "$OS" = "Linux" ]; then
  ./configure --prefix=$PREFIX --enable-utmp --enable-telnet --enable-socket-dir
else
  ./configure --prefix=$PREFIX --enable-utmp --enable-telnet --enable-socket-dir=/var/run/screen
fi
make
sudo make install
cd ..; rm -rf screen-5.0.2

curl https://www.greenwoodsoftware.com/less/less-710.tar.gz|tar zxvf -
cd less-710
./configure --prefix=$PREFIX --with-regex=pcre2
make
sudo make install
cd ..; rm -rf less-710

curl https://ftp.gnu.org/gnu/grep/grep-3.12.tar.gz|tar zxvf -
cd grep-3.12
./configure --prefix=$PREFIX
make
sudo make install
cd ..; rm -rf grep-3.12

curl https://ftp.gnu.org/gnu/sed/sed-4.10.tar.gz|tar zxvf -
cd sed-4.10
./configure --prefix=$PREFIX
make
sudo make install
cd ..; rm -rf sed-4.10

curl https://ftp.gnu.org/gnu/gawk/gawk-5.4.2.tar.gz|tar zxvf -
cd gawk-5.4.2
if [ "$OS" = "Linux" ]; then
  ./configure --prefix=$PREFIX --with-readline --with-mpfr=$PWD/..
else
  ./configure --prefix=$PREFIX --with-readline=$PWD/.. --with-mpfr=$PWD/..
fi
make
sudo make install
cd ..; rm -rf gawk-5.4.2

curl https://ftp.gnu.org/gnu/bc/bc-1.08.2.tar.gz|tar zxvf -
cd bc-1.08.2
./configure --prefix=$PREFIX --with-readline CFLAGS=-I$PWD/../include LDFLAGS=-L$PWD/../lib
make
sudo make install
cd ..; rm -rf bc-1.08.2

curl https://ftp.gnu.org/gnu/coreutils/coreutils-9.12.tar.gz|tar zxvf -
cd coreutils-9.12
./configure --prefix=$PREFIX --with-openssl=yes CFLAGS=-I$PWD/../include LDFLAGS=-L$PWD/../lib
make
sudo make install
cd ..; rm -rf coreutils-9.12

curl https://ftp.gnu.org/gnu/findutils/findutils-4.11.0.tar.xz|tar Jxvf -
cd findutils-4.11.0
./configure --prefix=$PREFIX
make
sudo make install
cd ..; rm -rf findutils-4.11.0

curl https://ftp.gnu.org/gnu/diffutils/diffutils-3.12.tar.gz|tar zxvf -
cd diffutils-3.12
./configure --prefix=$PREFIX
make
sudo make install
cd ..; rm -rf diffutils-3.12

curl https://www.kernel.org/pub/linux/utils/util-linux/v2.42/util-linux-2.42.4.tar.gz|tar zxvf -
cd util-linux-2.42.4
if [ "$OS" = "Darwin" ]; then
  sed -i.0 -e 's/"-lncursesw/"-lncurses/g' -e 's/="ncursesw"/="ncurses"/g' configure
fi
./configure --prefix=$PREFIX --disable-shared --disable-libblkid --disable-libfdisk --disable-libmount --disable-bash-completion
make
sudo make DESTDIR=$PWD/tmp install
for r in cal colcrt colrm column flock getopt hardlink hexdump logger look mcookie mesg namei rename renice rev scriptreplay setpgid setsid ul uuidgen uuidparse wall whereis; do sudo cp tmp$PREFIX/bin/$r $PREFIX/bin; sudo cp tmp$PREFIX/share/man/man1/$r.1 $PREFIX/share/man/man1; done
cd ..; sudo rm -rf util-linux-2.42.4
