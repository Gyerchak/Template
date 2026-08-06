CXX      := g++
CXXFLAGS := -std=c++20 -O3 -I/usr/include/vulkan -I/usr/include/glm
LDFLAGS  := -lgdal -lvulkan -lglfw

TARGET ?= $(notdir $(CURDIR))
SRCDIR   := src
OBJDIR   := obj

# Collect all .cpp sources
SRCS     := $(wildcard $(SRCDIR)/*.cpp)
OBJS     := $(SRCS:$(SRCDIR)/%.cpp=$(OBJDIR)/%.o)

# Shader files
VERT_SRC := $(wildcard shaders/*.vert)
FRAG_SRC := $(wildcard shaders/*.frag)
SHADER_OUT := $(VERT_SRC:%.vert=%.spv) $(FRAG_SRC:%.frag=%.spv)

all: shaders $(TARGET)

$(TARGET): $(OBJS)
	$(CXX) $(CXXFLAGS) $^ -o $@ $(LDFLAGS)

$(OBJDIR)/%.o: $(SRCDIR)/%.cpp $(SRCDIR)/App.h | $(OBJDIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

$(OBJDIR):
	mkdir -p $(OBJDIR)

shaders: $(SHADER_OUT)

%.spv: %.vert
	glslc $< -o $@

%.spv: %.frag
	glslc $< -o $@

.PHONY: clean
clean:
	rm -rf $(OBJDIR) $(TARGET) shaders/*.spv

.DEFAULT_GOAL := all