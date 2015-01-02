#!/bin/bash
#
#   平文テキストを改行区切りでchar*配列に一括変換する簡易スクリプト
#
#   Author:
#       sasairc(@sasairc)
#
#   License
#       WTFPL2
#

if [ -z "$1" ]; then
	echo "Usage: bootstrap.sh [filename]"
	exit -1;
fi

TXT_ORIG="$1"
TXT_TMP="./${TXT_ORIG##*/}.tmp"
TXT_CONV="convert.txt"
SRC_ORIG="strcdev.orig.c"
SRC_CONV="strcdev.c"

function convert_text() {
	grep -ve '^\s*$' "${TXT_ORIG}" > ${TXT_TMP}
	echo "char* str[] = {" > "${TXT_CONV}"

	DEFINE=$(cat ${TXT_TMP} | wc -l)
	LINES=$(expr `cat ${TXT_TMP} | wc -l` - 1)

	for ((i = 0; i <= $LINES; i++)); do
		if [ $i -eq $LINES ]; then
			cat "${TXT_TMP}" |\
			awk "NR==(($i + 1)) {print}" |\
			awk '{$0="\t\"" $0 "\""; print}' |\
			awk -F\n -v ORS="\n"  '{print}' >> "${TXT_CONV}"
		else
			cat ${TXT_TMP} |\
			awk "NR==(($i + 1)) {print}" |\
			awk '{$0="\t\"" $0 "\""; print}' |\
			awk -F\n -v ORS=",\n"  '{print}' >> "${TXT_CONV}"
		fi
	done

	echo -e "};" >> ${TXT_CONV}

	sed -i -e "1i \
/*\n\
 * Auto created bootstrap.sh\n\
 * #define RANDOM is $DEFINE\n\
 */" ${TXT_CONV}

	return;
}

function make_source() {
	local HEAD=43
	local TAIL=44
	head -n +$HEAD "${SRC_ORIG}" | sed -e "s/RANDARG/$DEFINE/g" > "${SRC_CONV}"
	cat "${TXT_CONV}" >> "${SRC_CONV}"
	tail -n +$TAIL "${SRC_ORIG}" >> "${SRC_CONV}"

	return;
}

convert_text
make_source
