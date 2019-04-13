CXX = g++
AS = as

CXXFLAGS = -std=c++17 -lstdc++ -g -m32
ASFLAGS = --32 -g
LDFLAGS = 

BUILD = ./build

# Assembly source
$(BUILD)/%.s.o: %.s
	$(MKDIR_P) $(dir $@)
	$(AS) $(ASFLAGS) $< -o $@ 

SRCS := $(wildcard src/*.s src/*/*.s src/*/*/*.s src/*/*/*/*.s src/*/*/*/*/*.s src/*.cpp src/*/*.cpp src/*/*/*.cpp src/*/*/*/*.cpp src/*/*/*/*/*.cpp)
OBJS := $(SRCS:%=$(BUILD)/%.o )


# C++ source
$(BUILD)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CXXFLAGS)  -c $< $(LDFLAGS) -o $@ 


# TESTS
TEST_DIR= ./tests/compiled
TEST_SRCS_SINGLE := $(wildcard tests/float/single/*.cpp)
TEST_OBJS_SINGLE := $(TEST_SRCS_SINGLE:%=$(BUILD)/%.o )

testSingle: $(OBJS) $(TEST_OBJS_SINGLE)
	$(MKDIR_P) $(TEST_DIR)
	$(MKDIR_P) $(BUILD)
	$(CXX) $(OBJS) $(TEST_OBJS_SINGLE) $(CXXFLAGS) -o $(TEST_DIR)/$@


all: testSingle

clean:
	rm -rf $(OBJS) $(EXEC)

MKDIR_P ?= mkdir -p
