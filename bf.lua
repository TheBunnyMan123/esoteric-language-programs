math.randomseed(os.time())
local file = assert(io.open(arg[1], "r"))
local inputFile = io.open(arg[2] or "", "r")
local input = inputFile and inputFile:read("*a") or ""
input = input:gsub("\n$", "")
input = {string.byte(input, 1, #input)}

local codeStr = file:read("*a")

file:close()
if inputFile then inputFile:close() end

local tape = {0}
local loopPointers = {}

local code = {}
codeStr:gsub("//.-\n", "\n")
codeStr:gsub("//.-$", "")
codeStr:gsub(".", function(s)
  table.insert(code, s)
end)

local codePointer = 1
local tapePointer = 1

local haltUntilEndLoop = false
while codePointer <= #code do
  local codePointerChanged = false
  local char = code[codePointer]

  if char == "+" then
    tape[tapePointer] = (tape[tapePointer] + 1) % 256
  elseif char == "-" then
    tape[tapePointer] = (tape[tapePointer] - 1) % 256
  elseif char == ">" then
    tapePointer = tapePointer + 1
    tape[tapePointer] = tape[tapePointer] or 0
  elseif char == "<" then
    tapePointer = tapePointer - 1
    if tapePointer < 1 then
      error("Cannot go past the beginning of the tape")
    end
    tape[tapePointer] = tape[tapePointer] or 0
  elseif char == "." then
    io.write(string.char(tape[tapePointer]))
    io.flush()
  elseif char == "," then
    tape[tapePointer] = input[1] or 0
    table.remove(input, 1)
  elseif char == "[" then
    if tape[tapePointer] == 0 then
      local nestedLoop = 1
      while nestedLoop > 0 do
        codePointer = codePointer + 1
        if code[codePointer] == "[" then
          nestedLoop = nestedLoop + 1
        elseif code[codePointer] == "]" then
          nestedLoop = nestedLoop - 1
        end
      end
    else
      table.insert(loopPointers, codePointer)
    end
  elseif char == "]" then
    local loopPointer = loopPointers[#loopPointers]
    if tape[tapePointer] > 0 then
      codePointer = loopPointer
      codePointerChanged = true
    end
    loopPointers[#loopPointers] = nil
  end

  if not codePointerChanged then
    codePointer = codePointer + 1
  end
end
::terminated::

