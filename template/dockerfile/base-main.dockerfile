FROM {{_input_:FROM_image}}
LABEL maintainer "{{_input_:author}} <{{_input_:email}}>"

RUN {{_cursor_}}
