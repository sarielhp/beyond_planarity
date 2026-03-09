-- inc_svg.lua

io.stderr:write("\n\n>>> LUA FILTER LOADING SUCCESSFUL <<<\n\n")

-- inc_svg.lua

function Image(el)
  if el.classes:includes("inc-svg") then
    
    -- 1. Path Logic (Standard)
    local raw_src = el.src
    local base = raw_src:gsub("%.%w+$", "")
    local num = el.attributes['num'] or "001"
    local width = el.attributes['w'] or "75%"
    local sstyle = el.attributes['style'] or ""
    el.src = "figs/" .. base .. "_svg/" .. num .. ".svg"
    
    -- 2. Style Logic
    el.attributes['style'] = "background-color: white;"
    
    -- 3. Clean up classes
    local new_classes = pandoc.List()
    for _, class in ipairs(el.classes) do
      if class ~= "inc-svg" then new_classes:insert(class) end
    end
    el.classes = new_classes

    -- 4. Formatting Logic
    if quarto.doc.is_format("revealjs") then
      el.classes:insert("nostretch")
      
      -- To avoid the '__toinline' error, we use a Span (Inline)
      -- instead of a Div (Block). Spans can have widths in HTML/Reveal.
      el.attributes['width'] = "100%"
      str = "display: inline-block; width: " .. width .. ";" .. sstyle
      return pandoc.Span({el}, {style = str})
      
    elseif quarto.doc.is_format("pdf") then
      el.attributes['width'] = "45%"
      return el
    end

    return el
  end
end
