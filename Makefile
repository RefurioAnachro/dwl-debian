
.PHONY: all
all:
	docker build -t dwl .

RUN_ARGS = \
  -e XDG_RUNTIME_DIR=/tmp \
  -v /dev:/dev \
  -v /dev/pts:/dev/pts \
  -v /sys:/sys \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -e DISPLAY="$$DISPLAY" \
  --device=/dev/dri \

.PHONY: run
run:
	# xhost +si:localuser:root
	docker run --rm --name dwl -it $(RUN_ARGS) dwl /run.sh
