set -ex
. ./.buildenv.sh

$CC -o test $CFLAGS test.c

