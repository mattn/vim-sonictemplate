SRCS = \
{{_expr_:join(map(split(glob('*.c'),"\n"),'"\t".substitute(v:val,"\\","/","g")')," \\\n")}}

OBJS = $(subst .c,.o,$(SRCS))

CFLAGS = 
LIBS = 
TARGET = {{_expr_:expand('%:p:h:t') . (has('win32')||has('win64')?'.exe':'')}}

all : $(TARGET)

$(TARGET) : $(OBJS)
	gcc -o $@ $(OBJS) $(LIBS)

.c.o :
	gcc -c $(CFLAGS) -I. $< -o $@

clean :
	rm -f *.o $(TARGET)
