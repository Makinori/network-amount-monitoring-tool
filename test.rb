
require("tk")

ammount_mat = [1, 2, 3, 4, 1, 5 ,2,
               4, 5, 0, 0, 0, 1, 2,
               5, 9, 3, 3, 9, 1, 4,
               1, 2, 3, 4, 1, 5 ,2,
               4, 5, 0, 0, 0, 1, 2,
               5, 9, 3, 3, 9, 1, 4,
               1, 2, 3, 4, 1, 5 ,2,
               4, 5, 0, 0, 0, 1, 2,
               5, 9, 3, 3, 9, 1, 4,
               1, 2, 3, 4, 1, 5 ,2,
               4, 5, 0, 0, 0, 1, 2,
               5, 9, 3, 3, 9, 1, 4,
               1, 2, 3, 4, 1, 5 ,2,
               4, 5, 0, 0, 0, 1, 2,
               5, 9, 3, 3, 9, 1, 4,
               1, 2, 3, 4, 1, 5 ,2,
               4, 5, 0, 0, 0, 1, 2,
               5, 9, 3, 3, 9, 1, 4,
               1, 2, 3, 4, 1, 5 ,2,
               4, 5, 0, 0, 0, 1, 2,
               5, 9, 3, 3, 9, 1, 4 ]

canvas = TkCanvas.new do
  width 600; height 200;
  pack
end

def ammount_color (ammount)
  c = 0xcc  - ammount * 30
  if c < 0x16 or c > 0xff then
    c = 0xcc
  end

  "##{c.to_s(16)}#{c.to_s(16)}#{c.to_s(16)}"
end

def draw_used_ammount (canvas, array)
  row_length = 7
  rect_width = 16
  margin_width = 8

  harf_rect =  rect_width / 2
  line_space = (rect_width+margin_width) 
  
  0.upto(array.length-1) {|x|
    center_x = (x / 7) * line_space + rect_width
    center_y = (x % 7) * line_space + rect_width
    TkcRectangle.new(canvas,
                     center_x - harf_rect,
                     center_y - harf_rect,
                     center_x + harf_rect,
                     center_y + harf_rect) do
      fill (ammount_color array[x])  
    end
  }
end


draw_used_ammount(canvas, ammount_mat)

Tk.mainloop





