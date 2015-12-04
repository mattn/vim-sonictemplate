SRCS = \
{{_expr_:join(map(split(glob('*.cpp'),"\n")+split(glob('*.cxx'),"\n"),'"\t".substitute(v:val,"\\","/","g")')," \\\n")}}

OBJS = $(subst .cxx,.o,$(subst .cpp,.o,$(SRCS))) 

CFLAGS = 
LIBS = 
TARGET = {{_expr_:expand('%:p:h:t')}}
ifeq ($(OS),Windows_NT)
TARGET := $(TARGET).exe
endif

.SUFFIXES: .cpp .cxx .o

all : $(TARGET)

$(TARGET) : $(OBJS)
	g++ -std=c++14 -o $@ $(OBJS) $(LIBS)

.cxx.o :
	g++ -std=c++14 -c $(CFLAGS) -I. $< -o $@

.cpp.o :
	g++ -std=c++14 -c $(CFLAGS) -I. $< -o $@

clean :
	rm -f *.o $(TARGET)
