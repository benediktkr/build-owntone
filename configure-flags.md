# `configure` flags

These are all the flags for the `configure` script.

```console
$ ./configure --help
Usage: ./configure [OPTION]... [VAR=VALUE]...

To assign environment variables (e.g., CC, CFLAGS...), specify them as
VAR=VALUE.  See below for descriptions of some of the useful variables.

Defaults for the options are specified in brackets.

Configuration:
  -h, --help              display this help and exit
      --help=short        display options specific to this package
      --help=recursive    display the short help of all the included packages
  -V, --version           display version information and exit
  -q, --quiet, --silent   do not print `checking ...' messages
      --cache-file=FILE   cache test results in FILE [disabled]
  -C, --config-cache      alias for `--cache-file=config.cache'
  -n, --no-create         do not create output files
      --srcdir=DIR        find the sources in DIR [configure dir or `..']

Installation directories:
  --prefix=PREFIX         install architecture-independent files in PREFIX
                          [/usr/local]
  --exec-prefix=EPREFIX   install architecture-dependent files in EPREFIX
                          [PREFIX]

By default, `make install' will install all the files in
`/usr/local/bin', `/usr/local/lib' etc.  You can specify
an installation prefix other than `/usr/local' using `--prefix',
for instance `--prefix=$HOME'.

For better control, use the options below.

Fine tuning of the installation directories:
  --bindir=DIR            user executables [EPREFIX/bin]
  --sbindir=DIR           system admin executables [EPREFIX/sbin]
  --libexecdir=DIR        program executables [EPREFIX/libexec]
  --sysconfdir=DIR        read-only single-machine data [PREFIX/etc]
  --sharedstatedir=DIR    modifiable architecture-independent data [PREFIX/com]
  --localstatedir=DIR     modifiable single-machine data [PREFIX/var]
  --runstatedir=DIR       modifiable per-process data [LOCALSTATEDIR/run]
  --libdir=DIR            object code libraries [EPREFIX/lib]
  --includedir=DIR        C header files [PREFIX/include]
  --oldincludedir=DIR     C header files for non-gcc [/usr/include]
  --datarootdir=DIR       read-only arch.-independent data root [PREFIX/share]
  --datadir=DIR           read-only architecture-independent data [DATAROOTDIR]
  --infodir=DIR           info documentation [DATAROOTDIR/info]
  --localedir=DIR         locale-dependent data [DATAROOTDIR/locale]
  --mandir=DIR            man documentation [DATAROOTDIR/man]
  --docdir=DIR            documentation root [DATAROOTDIR/doc/owntone]
  --htmldir=DIR           html documentation [DOCDIR]
  --dvidir=DIR            dvi documentation [DOCDIR]
  --pdfdir=DIR            pdf documentation [DOCDIR]
  --psdir=DIR             ps documentation [DOCDIR]

Program names:
  --program-prefix=PREFIX            prepend PREFIX to installed program names
  --program-suffix=SUFFIX            append SUFFIX to installed program names
  --program-transform-name=PROGRAM   run sed PROGRAM on installed program names

System types:
  --build=BUILD     configure for building on BUILD [guessed]
  --host=HOST       cross-compile to build programs to run on HOST [BUILD]

Optional Features:
  --disable-option-checking  ignore unrecognized --enable/--with options
  --disable-FEATURE       do not include FEATURE (same as --enable-FEATURE=no)
  --enable-FEATURE[=ARG]  include FEATURE [ARG=yes]
  --enable-silent-rules   less verbose build output (undo: "make V=1")
  --disable-silent-rules  verbose build output (undo: "make V=0")
  --enable-dependency-tracking
                          do not reject slow dependency extractors
  --disable-dependency-tracking
                          speeds up one-time build
  --enable-static[=PKGS]  build static libraries [default=no]
  --enable-shared[=PKGS]  build shared libraries [default=yes]
  --enable-fast-install[=PKGS]
                          optimize for fast installation [default=yes]
  --disable-libtool-lock  avoid locking (might break parallel builds)
  --disable-largefile     omit support for large files
  --disable-rpath         do not hardcode runtime library paths
  --disable-spotify       disable Spotify support (default=no)
  --disable-lastfm        disable LastFM support (default=no)
  --enable-chromecast     enable Chromecast support (default=no)
  --enable-preferairplay2 enable preference for AirPlay 2 for devices that
                          support both 1 and 2 (default=no)
  --enable-dbprofile      enable DB profiling support (default=no)
  --disable-mpd           disable MPD client protocol support (default=no)
  --disable-webinterface  disable include default web interface (default=no)
  --enable-install_user   enable having 'make install' add user/group and
                          'make uninstall' delete (default=no)
  --disable-install_conf_file
                          disable install configuration file (default=no)
  --disable-install_systemd
                          disable install systemd service file (default=no)

Optional Packages:
  --with-PACKAGE[=ARG]    use PACKAGE [ARG=yes]
  --without-PACKAGE       do not use PACKAGE (same as --with-PACKAGE=no)
  --with-pic[=PKGS]       try to use only PIC/non-PIC objects [default=use
                          both]
  --with-aix-soname=aix|svr4|both
                          shared library versioning (aka "SONAME") variant to
                          provide on AIX, [default=aix].
  --with-gnu-ld           assume the C compiler uses GNU ld [default=no]
  --with-sysroot[=DIR]    Search for dependent libraries within DIR (or the
                          compiler's sysroot if not specified).
  --with-gnu-ld           assume the C compiler uses GNU ld [default=no]
  --with-libiconv-prefix[=DIR]  search for libiconv in DIR/include and DIR/lib
  --without-libiconv-prefix     don't search for libiconv in includedir and libdir
  --with-libgcrypt-prefix=PFX
                          prefix where LIBGCRYPT is installed (optional)
  --with-libgpg-error-prefix=PFX
                          prefix where GPG Error is installed (optional)

  --with-libav            choose libav even if ffmpeg present (default=no)
  --with-alsa             with ALSA support (default=check)
  --with-pulseaudio       with Pulseaudio support (default=check)
  --with-libwebsockets    with libwebsockets support (default=check)
  --with-avahi            with Avahi mDNS (default=check)
  --with-user=USER        User for running OwnTone (default=owntone)
  --with-group=GROUP      Group for owntone user (default=USER)
  --with-systemddir=DIR   Directory for systemd service files
                          (default=SYSCONFDIR/systemd/system)

Some influential environment variables:
  CC          C compiler command
  CFLAGS      C compiler flags
  LDFLAGS     linker flags, e.g. -L<lib dir> if you have libraries in a
              nonstandard directory <lib dir>
  LIBS        libraries to pass to the linker, e.g. -l<library>
  CPPFLAGS    (Objective) C/C++ preprocessor flags, e.g. -I<include dir> if
              you have headers in a nonstandard directory <include dir>
  LT_SYS_LIBRARY_PATH
              User-defined run-time library search path.
  YACC        The `Yet Another Compiler Compiler' implementation to use.
              Defaults to the first program found out of: `bison -y', `byacc',
              `yacc'.
  YFLAGS      The list of arguments that will be passed by default to $YACC.
              This script will default YFLAGS to the empty string to avoid a
              default value of `-d' given by some make applications.
  CPP         C preprocessor
  LIBUNISTRING_CFLAGS
              C compiler flags for GNU libunistring, overriding search
  LIBUNISTRING_LIBS
              linker flags for GNU libunistring, overriding search
  PKG_CONFIG  path to pkg-config utility
  PKG_CONFIG_PATH
              directories to add to pkg-config's search path
  PKG_CONFIG_LIBDIR
              path overriding pkg-config's built-in search path
  ZLIB_CFLAGS C compiler flags for ZLIB, overriding pkg-config
  ZLIB_LIBS   linker flags for ZLIB, overriding pkg-config
  CONFUSE_CFLAGS
              C compiler flags for CONFUSE, overriding pkg-config
  CONFUSE_LIBS
              linker flags for CONFUSE, overriding pkg-config
  LIBCURL_CFLAGS
              C compiler flags for LIBCURL, overriding pkg-config
  LIBCURL_LIBS
              linker flags for LIBCURL, overriding pkg-config
  LIBSODIUM_CFLAGS
              C compiler flags for LIBSODIUM, overriding pkg-config
  LIBSODIUM_LIBS
              linker flags for LIBSODIUM, overriding pkg-config
  MINIXML_CFLAGS
              C compiler flags for MINIXML, overriding pkg-config
  MINIXML_LIBS
              linker flags for MINIXML, overriding pkg-config
  SQLITE3_CFLAGS
              C compiler flags for SQLITE3, overriding pkg-config
  SQLITE3_LIBS
              linker flags for SQLITE3, overriding pkg-config
  LIBEVENT_CFLAGS
              C compiler flags for LIBEVENT, overriding pkg-config
  LIBEVENT_LIBS
              linker flags for LIBEVENT, overriding pkg-config
  LIBEVENT_PTHREADS_CFLAGS
              C compiler flags for LIBEVENT_PTHREADS, overriding pkg-config
  LIBEVENT_PTHREADS_LIBS
              linker flags for LIBEVENT_PTHREADS, overriding pkg-config
  JSON_C_CFLAGS
              C compiler flags for JSON_C, overriding pkg-config
  JSON_C_LIBS linker flags for JSON_C, overriding pkg-config
  LIBPLIST_CFLAGS
              C compiler flags for LIBPLIST, overriding pkg-config
  LIBPLIST_LIBS
              linker flags for LIBPLIST, overriding pkg-config
  LIBGCRYPT_CFLAGS
              C compiler flags for GNU Crypt Library, overriding search
  LIBGCRYPT_LIBS
              linker flags for GNU Crypt Library, overriding search
  GPG_ERROR_MT_CFLAGS
              C compiler flags for GNUPG Error Values, overriding search
  GPG_ERROR_MT_LIBS
              linker flags for GNUPG Error Values, overriding search
  INOTIFY_CFLAGS
              C compiler flags for inotify, overriding search
  INOTIFY_LIBS
              linker flags for inotify, overriding search
  LIBAV_CFLAGS
              C compiler flags for LIBAV, overriding pkg-config
  LIBAV_LIBS  linker flags for LIBAV, overriding pkg-config
  ALSA_CFLAGS C compiler flags for ALSA, overriding pkg-config
  ALSA_LIBS   linker flags for ALSA, overriding pkg-config
  LIBPULSE_CFLAGS
              C compiler flags for LIBPULSE, overriding pkg-config
  LIBPULSE_LIBS
              linker flags for LIBPULSE, overriding pkg-config
  LIBWEBSOCKETS_CFLAGS
              C compiler flags for LIBWEBSOCKETS, overriding pkg-config
  LIBWEBSOCKETS_LIBS
              linker flags for LIBWEBSOCKETS, overriding pkg-config
  AVAHI_CFLAGS
              C compiler flags for AVAHI, overriding pkg-config
  AVAHI_LIBS  linker flags for AVAHI, overriding pkg-config
  DNSSD_CFLAGS
              C compiler flags for Bonjour DNS_SD, overriding search
  DNSSD_LIBS  linker flags for Bonjour DNS_SD, overriding search
  LIBPROTOBUF_C_CFLAGS
              C compiler flags for LIBPROTOBUF_C, overriding pkg-config
  LIBPROTOBUF_C_LIBS
              linker flags for LIBPROTOBUF_C, overriding pkg-config
  LIBPROTOBUF_OLD_CFLAGS
              C compiler flags for v0 libprotobuf-c, overriding search
  LIBPROTOBUF_OLD_LIBS
              linker flags for v0 libprotobuf-c, overriding search
  GNUTLS_CFLAGS
              C compiler flags for GNUTLS, overriding pkg-config
  GNUTLS_LIBS linker flags for GNUTLS, overriding pkg-config

Use these variables to override the choices made by `configure' or to help
it to find libraries and programs with nonstandard names/locations.

Report bugs to the package provider.
```
