# Check for a package using $2-config. Similar to AST_EXT_LIB_CHECK,
# but use $2-config to determine cflags and libraries to use.
# $3 and $4 can be used to replace --cflags and --libs in the request

# AST_EXT_TOOL_CHECK([package], [tool name], [--cflags], [--libs], [includes], [expression])
AC_DEFUN([AST_EXT_TOOL_CHECK],
[
	AC_REQUIRE([AST_PROG_SED])dnl
	if test "x${PBX_$1}" != "x1" -a "${USE_$1}" != "no"; then
		PBX_$1=0
		AC_PATH_TOOL(CONFIG_$1, $2, No, [${$1_DIR}/bin:$PATH])
		if test ! "x${CONFIG_$1}" = xNo; then
			if test x"$3" = x ; then A=--cflags ; else A="$3" ; fi
			$1_INCLUDE=$(${CONFIG_$1} $A)
			$1_INCLUDE=$(echo ${$1_INCLUDE} | $SED -e "s|-I|-I${$1_DIR}|g")

			if test x"$4" = x ; then A=--libs ; else A="$4" ; fi
			$1_LIB=$(${CONFIG_$1} $A)
			$1_LIB=$(echo ${$1_LIB} | $SED -e "s|-L|-L${$1_DIR}|g")

			if test x"$5" != x ; then
				saved_cppflags="${CPPFLAGS}"
				CPPFLAGS="${CPPFLAGS} ${$1_INCLUDE}"

				saved_libs="${LIBS}"
				LIBS=${$1_LIB}

				AC_LINK_IFELSE(
					[ AC_LANG_PROGRAM( [ $5 ], [ $6; ])],
					[ PBX_$1=1 AC_DEFINE([HAVE_$1], 1,
						[Define if your system has the $1 headers.])],
					[]
				)
				CPPFLAGS="${saved_cppflags}"
				LIBS="${saved_libs}"
			else
				PBX_$1=1
				AC_DEFINE([HAVE_$1], 1, [Define if your system has the $1 libraries.])
			fi
		fi
	fi
])
