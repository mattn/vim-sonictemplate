ifeq ($(OS),Windows_NT)
    ifeq ($(PROCESSOR_ARCHITECTURE),AMD64)
    endif
    ifeq ($(PROCESSOR_ARCHITECTURE),x86)
    endif
else
    OS := $(shell uname -s)
    ifeq ($(OS),Linux)
    endif
    ifeq ($(OS),Darwin)
    endif
    CPU := $(shell uname -p)
    ifeq ($(CPU),x86_64)
    endif
    ifneq ($(filter %86,$(CPU)),)
    endif
    ifneq ($(filter arm%,$(CPU)),)
    endif
endif
