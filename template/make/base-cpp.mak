SRCS = \
{{_expr_:join(map(split(glob('*.cpp'),"\n")+split(glob('*.cxx'),"\n")+split(glob('*.cc'),"\n"),'"\t".substitute(v:val,"\\","/","g")')," \\\n")}}

OBJS = $(subst .cc,.o,$(subst .cxx,.o,$(subst .cpp,.o,$(SRCS))))

CXXFLAGS = -std=c++14
LIBS = 
TARGET = {{_expr_:expand('%:p:h:t')}}
ifeq ($(OS),Windows_NT)
TARGET := $(TARGET).exe
endif

.SUFFIXES: .cpp .cc .cxx .o

all : $(TARGET)

$(TARGET) : $(OBJS)
	g++ -o $@ $(OBJS) $(LIBS)

.cxx.o :
	g++ -c $(CXXFLAGS) -I. $< -o $@

.cpp.o :
	g++ -c $(CXXFLAGS) -I. $< -o $@

.cc.o :
	g++ -c $(CXXFLAGS) -I. $< -o $@

clean :
	rm -f *.o $(TARGET)
{{_filter_:make}}
