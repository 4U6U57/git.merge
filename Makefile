SOURCE=gitmerge.sh
INCLUDE=Echo.sh
INSTALLDIR=~/bin

install: remove ${SOURCE}
	IFS=""; while read LINE; do if [[ $$LINE == 'source $$ExeDir/${INCLUDE}' ]]; then cat ${INCLUDE} >> ${INSTALLDIR}/${SOURCE}; else echo "$$LINE" >> ${INSTALLDIR}/${SOURCE}; fi; done < ${SOURCE}
	chmod +x ${INSTALLDIR}/${SOURCE}

remove:
	rm -f ${INSTALLDIR}/${SOURCE}

submit: push

.PHONY: install remove submit

include git.mk
