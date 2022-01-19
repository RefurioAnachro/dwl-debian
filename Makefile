
.PHONY: all
all:
	docker build -t dwl .

.PHONY: run
run:
	docker run --rm --name dwl -it -e XDG_RUNTIME_DIR=/tmp -v /dev:/dev dwl /src/dwl/dwl
