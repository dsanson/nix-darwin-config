-- label-bullets.lua
-- In-place transform of BulletList items with leading "(...)" labels.
local pandoc = require("pandoc")
local utils = pandoc.utils
local FORMAT = FORMAT or ""

local function strip_trailing_paren_from_inlines(inlines)
  if #inlines == 0 then return inlines end
  local last = inlines[#inlines]
  if last.t == "Str" then
    if last.text:match("%)$") then
      last.text = last.text:gsub("%)$", "")
      if last.text == "" then table.remove(inlines, #inlines) end
    end
  end
  return inlines
end

local function ends_with_punct_text(s)
  return s:match("[%.%!%?%:%;:%⋮]$") ~= nil
end

local function ensure_trailing_period_on_inlines(inlines)
  local text = utils.stringify(inlines):gsub("%s+$", "")
  if text == "" then return inlines end
  if ends_with_punct_text(text) then return inlines end
  table.insert(inlines, pandoc.Str("."))
  return inlines
end

local function extract_parenthesized_label(inlines)
  if not inlines or #inlines == 0 then return nil end
  local sidx = 1
  while inlines[sidx] and inlines[sidx].t == "Space" do sidx = sidx + 1 end
  if sidx > #inlines then return nil end

  local acc = {}
  local found_close = false
  local end_idx = sidx
  for i = sidx, #inlines do
    table.insert(acc, inlines[i])
    if utils.stringify(inlines[i]):find("%)") then
      found_close = true
      end_idx = i
      break
    end
  end
  if not found_close then return nil end

  local combined = ""
  for _,n in ipairs(acc) do combined = combined .. utils.stringify(n) end
  local open_pos = combined:find("%(")
  local close_pos = combined:find("%)")
  if not open_pos or not close_pos or open_pos > close_pos then return nil end

  local label = {}
  local removed_open = false
  local removed_close = false
  for _, node in ipairs(acc) do
    local txt = utils.stringify(node)
    if not removed_open and txt:find("%(") then
      local after = txt:match("%((.*)$") or ""
      if after ~= "" then table.insert(label, pandoc.Str(after)) end
      removed_open = true
    elseif not removed_close and txt:find("%)") then
      local before = txt:match("^(.-)%)") or ""
      if before ~= "" then table.insert(label, pandoc.Str(before)) end
      removed_close = true
    else
      table.insert(label, node)
    end
  end
  label = strip_trailing_paren_from_inlines(label)
  label = ensure_trailing_period_on_inlines(label)

  local remaining = {}
  local end_txt = utils.stringify(acc[#acc])
  local p = end_txt:find("%)")
  if p and p < #end_txt then
    local after = end_txt:sub(p+1)
    if after ~= "" then table.insert(remaining, pandoc.Str(after)) end
  end
  for i = end_idx+1, #inlines do table.insert(remaining, inlines[i]) end
  while remaining[1] and remaining[1].t == "Space" do table.remove(remaining,1) end

  if #label == 0 then return nil end
  return label, remaining
end

local function render_inlines(fmt, inlines)
  local ok, out = pcall(pandoc.write, pandoc.Pandoc(pandoc.Blocks(pandoc.Plain(inlines))), fmt)
  if not ok then return utils.stringify(inlines) end
  if fmt:match("^html") or fmt == "revealjs" then
    out = out:gsub("^%s*<p>", ""):gsub("</p>%s*$", "")
  end
  return out
end

local function inject_html_spans_into_block(block, sr_html, vis_html)
  local cur = block.content or block.c or {}
  -- prepend visible then sr (so sr becomes first for screen readers if desired)
  table.insert(cur, 1, pandoc.RawInline("html", vis_html))
  table.insert(cur, 1, pandoc.RawInline("html", sr_html))
  if block.content ~= nil then
    block.content = cur
  elseif block.c ~= nil then
    block.c = cur
  else
    return pandoc.Plain(cur)
  end
  return nil
end

function BulletList(bl)
  local fmt = FORMAT or ""
  local changed = false
  if not (fmt:match("^html") or 
          fmt == "revealjs" or 
          fmt:match("^epub") or 
          fmt == "typst" or 
          fmt == "latex" or 
          fmt == "docx" or 
          fmt == "odt") then
    return bl
  end

  for idx, item in ipairs(bl.content) do
    if #item >= 1 and (item[1].t == "Plain" or item[1].t == "Para") then
      local block = item[1]
      local inlines = block.content or block.c or {}
      if block.t == "Plain" or block.t == "Para" then inlines = block.content end

      local label, rem = extract_parenthesized_label(inlines)
      if label then
        changed = true

        -- update first block to remaining text, preserving original block type
        if block.t == "Plain" then
          if #rem == 0 then
            if #item > 1 then table.remove(item,1) else item[1] = pandoc.Plain({}) end
          else
            item[1] = pandoc.Plain(rem)
          end
        elseif block.t == "Para" then
          if #rem == 0 then
            if #item > 1 then table.remove(item,1) else item[1] = pandoc.Para({}) end
          else
            item[1] = pandoc.Para(rem)
          end
        else
          if #rem == 0 then
            if #item > 1 then table.remove(item,1) else item[1] = pandoc.Plain({}) end
          else
            item[1] = pandoc.Plain(rem)
          end
        end

        -- Format-specific handling
        if fmt:match("^html") or fmt == "revealjs" or fmt:match("^epub") then
          -- html-like outputs: inject raw HTML spans (epub allows raw HTML)
          local vis = render_inlines("html", label)
          local labtext = utils.stringify(label):gsub('"','&quot;')
          local span_html = '<span class="li-label">' .. vis .. '</span> '
          local sr = ''
          local firstblock = item[1]
          if firstblock then
            local fallback = inject_html_spans_into_block(firstblock, sr, span_html)
            if fallback then item[1] = fallback end
          else
            item[1] = pandoc.Plain({pandoc.RawInline("html", sr), pandoc.RawInline("html", span_html)})
          end

        elseif fmt:match("^latex") or fmt:match("^typst") then
          -- handled below by reconstructing list as RawBlock
          item._label = label

        elseif fmt == "docx" or fmt == "odt" then
          -- docx/odt writers don't honor Plain vs Para reliably; reconstruct list as RawBlock for these formats
          item._label = label

        else
          -- default: attach label for later handling (fallback)
          item._label = label
        end
      end
    end
  end

  if not changed then return nil end

  -- For HTML-like writers return the modified list
  if FORMAT:match("^html") or FORMAT == "revealjs" or FORMAT:match("^epub") then
    return bl
  end

  -- For docx/odt/latex/typst/other formats: reconstruct list as RawBlock using the writer
  if FORMAT:match("^latex") then
    local parts = {"\\begin{itemize}\n"}
    for i,item in ipairs(bl.content) do
      if item._label then
        parts[#parts+1] = "\\item[" .. render_inlines("latex", item._label) .. "] "
      else
        parts[#parts+1] = "\\item "
      end
      local ok, out = pcall(pandoc.write, pandoc.Pandoc(pandoc.Blocks(item)), "latex")
      parts[#parts+1] = (ok and out or utils.stringify(item)) .. "\n"
    end
    parts[#parts+1] = "\\end{itemize}\n"
    return pandoc.RawBlock("latex", table.concat(parts))
  end


  if FORMAT:match("^typst") then
    local parts = {"#import \"@preview/itemize:0.2.0\" as el\n#show: el.default-enum-list\n"}

    for i,item in ipairs(bl.content) do
      local labpart = ""
      if item._label then labpart = " #el.item["..render_inlines("typst", item._label).."]" end

      -- render first block (if any) and subsequent blocks separately
      local first = item[1]
      local first_out = ""
      if first then
        local ok, out = pcall(pandoc.write, pandoc.Pandoc(pandoc.Blocks(first)), "typst")
        first_out = ok and out or utils.stringify(first)
        -- indent wrapped lines in the first block so continuations align under content
        first_out = first_out:gsub("\r\n", "\n"):gsub("\n%s*", "\n  ")
        -- Trim trailing newline (we'll add one when assembling)
        first_out = first_out:gsub("\n$", "")
      end

      local rest_outs = {}
      for j = 2, #item do
        local ok, out = pcall(pandoc.write, pandoc.Pandoc(pandoc.Blocks(item[j])), "typst")
        local outtxt = ok and out or utils.stringify(item[j])
        -- ensure each additional block starts on its own indented line
        outtxt = outtxt:gsub("\r\n", "\n"):gsub("\n%s*", "\n  ")
        outtxt = outtxt:gsub("\n$", "")
        if outtxt ~= "" then table.insert(rest_outs, outtxt) end
      end

      local body = first_out
      if #rest_outs > 0 then body = body .. "\n  " .. table.concat(rest_outs, "\n\n  ") end
      parts[#parts+1] = "-"..labpart.." "..(body ~= "" and body or "").."\n"
    end
    parts[#parts+1] = "\n"
    return pandoc.RawBlock("typst", table.concat(parts))
  end


  if FORMAT == "docx" or FORMAT == "odt" or FORMAT == "opendocument" then
    local outblocks = {}
    for _, item in ipairs(bl.content) do
      if item._label then
        -- prepare label inlines
        local lab = item._label
        table.insert(lab, pandoc.Space())

        -- gather description inlines from the first block (if any)
        local desc_inlines = {}
        local first = item[1]
        if first and (first.t == "Para" or first.t == "Plain") then
          desc_inlines = first.content or first.c or {}
        end

        -- assemble paragraph inlines: label + tab + description
        local para_inlines = {}
        for _, x in ipairs(lab) do table.insert(para_inlines, x) end
        --table.insert(para_inlines, pandoc.RawInline("openxml", "<w:tab/>"))
        table.insert(para_inlines, pandoc.Str("\t"))
        for _, x in ipairs(desc_inlines) do table.insert(para_inlines, x) end

        -- create Para (no direct custom-style here) and wrap in Div with custom-style
        local p = pandoc.Para(para_inlines)
        local div_attr = pandoc.Attr("", {}, { ["custom-style"] = "HangingTerm" })
        table.insert(outblocks, pandoc.Div({ p }, div_attr))

        -- append any remaining blocks of the item after the first
        for j = 2, #item do
          table.insert(outblocks, item[j])
        end
      else
        -- no label: emit item's blocks unchanged
        for j = 1, #item do table.insert(outblocks, item[j]) end
      end
    end
    return outblocks
  end

  -- fallback: return modified list
  return bl
end
