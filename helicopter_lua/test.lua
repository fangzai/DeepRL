--#!/usr/bin/env lua

vector = {}

--
function vector:new()
  local v = {size = 0, idx = 1}

  --
  function v.push_back(a)
    v.size = v.size + 1
    v[v.idx] = a
    v.idx = v.idx + 1
  end

--
  function v.at(i)
    return v[i]
  end

  return v
end

aaa = vector:new()
bbb = vector:new()

for i = 1, 3 do
  aaa.push_back(i)
end

for i = 20, 23 do
  bbb.push_back(i)
end

for i = 1, 3 do
  print("a = ", aaa.at(i))
end

for i = 1, 3 do
  print("b = ", bbb.at(i))
end
