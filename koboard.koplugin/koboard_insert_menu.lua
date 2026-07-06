local function insertAfter(order, anchor, item)
    for _, value in ipairs(order.tools) do
        if value == item then return end
    end

    local pos = #order.tools + 1
    for index, value in ipairs(order.tools) do
        if value == anchor then
            pos = index + 1
            break
        end
    end
    table.insert(order.tools, pos, item)
end

local ok_reader, reader_order = pcall(require, "ui/elements/reader_menu_order")
if ok_reader and reader_order then
    insertAfter(reader_order, "statistics", "koboard")
end

local ok_filemanager, filemanager_order = pcall(require, "ui/elements/filemanager_menu_order")
if ok_filemanager and filemanager_order then
    insertAfter(filemanager_order, "statistics", "koboard")
end
