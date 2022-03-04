--[[
    Author: Fastering18
    Title: Brainfuck encryption
    License:
    MIT License

	Copyright (c) 2022 Fastering18

	Permission is hereby granted, free of charge, to any person obtaining a copy
	of this software and associated documentation files (the "Software"), to deal
	in the Software without restriction, including without limitation the rights
	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
	copies of the Software, and to permit persons to whom the Software is
	furnished to do so, subject to the following conditions:

	The above copyright notice and this permission notice shall be included in all
	copies or substantial portions of the Software.

	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
	SOFTWARE.
]]

local encryptor = {}


--[[
    Decode brainfuck into ascii characters
    supports (>, <, +, -, ., [, ])
    
    returns {result?: string, error?: string, memory: {[number] = number}, memidx = number}
    
    *examples at end of file
    see more, https://www.codingame.com/playgrounds/50426/getting-started-with-brainfuck
]]
encryptor.decode = function(code, mem, cmemi, cchari, res)
	mem = mem or {}
	cmemi = cmemi or 1
	res = res or ""
	cchari = cchari or 1

	local cchar = string.sub(code, cchari, cchari)
	if #cchar < 1 then return {result = res, memory = mem, memidx = cmemi} end

	mem[cmemi] = mem[cmemi] or 0

	if cchar == '>' then cmemi = cmemi + 1
	elseif cchar == '<' then cmemi = cmemi - 1
	elseif cchar == '+' then mem[cmemi] = mem[cmemi] + 1
	elseif cchar == '-' then mem[cmemi] = mem[cmemi] - 1
	elseif cchar == '.' then res = res..string.char(mem[cmemi])
	elseif cchar == '[' then
		local closeidx = string.find(code, ']', cchari)
		if closeidx == nil then return {memory = mem, memidx = cmemi, error = ("Missing an ']' at (%d)"):format(cchari)} end
		local block = string.sub(code, cchari+1, closeidx-1)
		while mem[cmemi] ~= 0 do
			local resblock = encryptor.decode(block, mem, cmemi)
			if resblock.error then return resblock end
			res = res..resblock.result
			cmemi = resblock.memidx
		end
		cchari = closeidx
	end

	return encryptor.decode(code, mem, cmemi, cchari + 1, res)
end

--[[
    Encode ascii into brainfuck code
    uses 2 only memory slot [1, 2]
    
    return string
]]
encryptor.encode = function(code, cmemval, idx, res)	
	idx = idx or 1
	cmemval = cmemval or 0
	res = res or ""	
	if #code < idx then return res end

	local cchar = string.sub(code, idx, idx)
	if #cchar < 1 then return res end

	local target = cchar:byte()
	local opsign = target > cmemval and '+' or '-'
	local jarak = math.abs(target - cmemval)
	if jarak < 4 then
		res = res..string.rep(opsign, jarak)
	elseif target ~= cmemval then
		local mulhalf = math.floor(math.sqrt(jarak))
		res = res..'>'..string.rep('+', mulhalf)
		res = res..'[-<'..string.rep(opsign, mulhalf)..'>]<'..string.rep(opsign, jarak - mulhalf^2)
	end
	res = res..'.'
	cmemval = target

	return encryptor.encode(code, cmemval, idx + 1, res)
end


--[[ Usage (chaining using two memory)

local encryptor = require(PATH TO ENCRYPTOR FILE)

-- Decode
local runtime = encryptor.decode(
  ">++++++[-<++++++++++>]<++++++.".. -- B (66): 6 * 10 + 6
  "-.".. 							 -- A (65): 66 - 1
  "++++++++++."..				     -- K (75): 65 + 10
  "----------."                      -- A (65): 75 - 10
)
if runtime.error then -- check for possible error
  error(runtime.error) 
else
  print(runtime.result) --> "BAKA"
end

-- Encode
-- *take result from previous decode
local onichan = encryptor.encode(runtime.result)
print(onichan) --> ">++++++[-<++++++++++>]<++++++.-.++++++++++.----------."

]]


local _0x19F6D22C9 = string.rep(utf8 and utf8.char(3486) or 'ඞ', 50)
return setmetatable(encryptor, {__metatable = _0x19F6D22C9, __newindex = function() error(_0x19F6D22C9, 100) end})
