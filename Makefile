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

SRCS_SINGLE := $(wildcard src/float/single/*.s src/float/single/*/*.s src/float/single/*/*/*.s src/float/single/*.cpp src/float/single/*/*.cpp src/float/single/*/*/*.cpp)
OBJS_SINGLE := $(SRCS_SINGLE:%=$(BUILD)/%.o )

SRCS_HALF := $(wildcard src/float/half/*.s src/float/half/*/*.s src/float/half/*/*/*.s src/half/*.cpp src/float/half/*/*.cpp src/float/half/*/*/*.cpp)
OBJS_HALF := $(SRCS_HALF:%=$(BUILD)/%.o )

# C++ source
$(BUILD)/%.cpp.o: %.cpp
	$(MKDIR_P) $(dir $@)
	$(CXX) $(CXXFLAGS)  -c $< $(LDFLAGS) -o $@ 


# TESTS
TEST_DIR= ./tests/compiled
TEST_SRCS_SINGLE := $(wildcard tests/float/single/*.cpp)
TEST_OBJS_SINGLE := $(TEST_SRCS_SINGLE:%=$(BUILD)/%.o )

TEST_SRCS_HALF := $(wildcard tests/float/half/*.cpp)
TEST_OBJS_HALF := $(TEST_SRCS_HALF:%=$(BUILD)/%.o )

${info ${OBJS_HALF}}
${info ${TEST_OBJS_HALF}}

testSingle: $(OBJS_SINGLE) $(TEST_OBJS_SINGLE)
	$(MKDIR_P) $(TEST_DIR)
	$(MKDIR_P) $(BUILD)
	$(CXX) $(OBJS_SINGLE) $(TEST_OBJS_SINGLE) $(CXXFLAGS) -o $(TEST_DIR)/$@


testHalf: $(OBJS_HALF) $(TEST_OBJS_HALF)
	$(MKDIR_P) $(TEST_DIR)
	$(MKDIR_P) $(BUILD)
	$(CXX) $(OBJS_HALF) $(TEST_OBJS_HALF) $(CXXFLAGS) -o $(TEST_DIR)/$@

all: testSingle testHalf

clean:
	rm -rf $(OBJS) $(EXEC)

MKDIR_P ?= mkdir -p
