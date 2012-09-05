# $OpenBSD: Makefile,v 1.57 2012/01/25 11:32:34 ajacoutot Exp $

COMMENT-java=	Java bindings for Berkeley DB, revision ${REV}

REV=		4
SUBREV=		8
VERSION=	${REV}.${SUBREV}.30
PKGNAME-main=	${DISTNAME}
PKGSPEC-main =	db->=4.8,<5|db->=4.8v0,<5v0
PKGSPEC-java =  db-java->=4.8,<5|db-java->=4.8v0,<5v0
PKGSPEC-tcl =   db-tcl->=4.8,<5|db-tcl->=4.8v0,<5v0

PKGNAME-java=	db-java-${VERSION}
PKGNAME-tcl=	db-tcl-${VERSION}
EPOCH-main=	0
EPOCH-java=	0
EPOCH-tcl=	0
REVISION-java =	0
REVISION-tcl =	0
DBLIBDIR=	lib/db${REV}.${SUBREV}

# XXX sync LIBdb_VERSION in x11/gnome/libgda
SHARED_LIBS +=	db                   6.0      # .0.0
SHARED_LIBS +=	db_cxx               7.0      # .0.0
SHARED_LIBS +=	db_java              6.0      # .0.0
SHARED_LIBS +=	db_tcl               7.0      # .0.0

MASTER_SITES0=	${HOMEPAGE}db/update/${VERSION}/
# patch 2 has converted DOS line-endings; no other change
# patches 1,3,4 are just mirrored
#MASTER_SITES2=	http://spacehopper.org/mirrors/
#PATCHFILES=	patch.${VERSION}.1:2 \
#		patch.${VERSION}.2.fixed:2 \
#		patch.${VERSION}.3:2 \
#		patch.${VERSION}.4:2

CONFIGURE_STYLE=gnu

DEST_SUBDIR=	${REV}.${SUBREV}
WANTLIB=	c m stdc++

PSEUDO_FLAVORS=	no_java bootstrap
FLAVOR?= 
MULTI_PACKAGES = -java

RUN_DEPENDS-java=	${BUILD_PKGPATH} \
			${MODJAVA_RUN_DEPENDS}
RUN_DEPENDS-tcl=	${BUILD_PKGPATH}
WANTLIB-java=

SUBST_VARS=	LIBdb_tcl_VERSION

pre-configure:
	@perl -pi -e "s,db_(archive|checkpoint|deadlock|dump|hotbackup),db5_\0,g" ${WRKSRC}/test/*tcl
	@perl -pi -e "s,db_(load|printlog|recover|stat|upgrade|verify),db5_\0,g" ${WRKSRC}/test/*tcl
	@${SUBST_CMD} ${WRKSRC}/test/include.tcl

.include <bsd.port.mk>
