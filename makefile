SHELL = /usr/bin/fish

CONTAINER_USER = nemo

print-fish-version:
	printf "\nUsing \e[38;5;27mFish %s\e[m\n\n" "(fish --version | awk '{print $$NF}')"

add-nemo-user:
	addgroup \
		--gid 1000 \
		${CONTAINER_USER}
	adduser \
		--shell /usr/bin/fish \
		--ingroup ${CONTAINER_USER} \
		--disabled-password \
		--uid 1000 \
		${CONTAINER_USER} ${CONTAINER_USER}

move-to-container-user-home:
	mv makefile /home/${CONTAINER_USER}/ \
	&& chown ${CONTAINER_USER}:${CONTAINER_USER} /home/${CONTAINER_USER}/makefile \
	&& printf "✅ makefile moved\n"

install-fisher:
	curl -sL git.io/fisher \
    | source \
	&& fisher install jorgebucaran/fisher \
	&& printf "\nUsing \e[38;5;27mFisher %s\e[m\n\n" "(fisher --version | awk '{print $$NF}')"

install-fishtape:
	fisher install jorgebucaran/fishtape \
	&& printf "\nUsing \e[38;5;27mFishtape %s\e[m\n\n" "(fishtape --version | awk '{print $$NF}')"