FROM {{_input_:FROM_image}}
MAINTAINER {{_input_:author}} <{{_input_:email}}>

RUN {{_cursor_}}
