# lua-brainfuck
Translate brainf code into human-readable string for you!  

> **DON'T store secret data using this module.  
> Use hash encryption for better security.**

## Usage
```lua
-- Usage (chaining using two memory)
local encryptor = require(PATH TO BRAINFUCK FILE)

-- Decode
local runtime = encryptor.decode(
  ">++++++[-<++++++++++>]<++++++."..  -- B (66): 6 * 10 + 6
  "-."..                              -- A (65): 66 - 1
  "++++++++++."..                     -- K (75): 65 + 10
  "----------."                       -- A (65): 75 - 10
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
```  

### Links  
[Discord server](https://discord.gg/FHVjsSg7jU)  
[Roblox](https://www.roblox.com/users/467971019/profile)  
<br>
Issue and contributing are welcomed!
