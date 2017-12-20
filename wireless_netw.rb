require 'green_shoes'

Shoes.app title: 'Wi-Fi', width:680, height: 640 do
  para 'Input device', margin: 10
  @line = edit_line width: 400, margin: 10
  @item = button 'Connect', margin: 10
  @buttom = button 'Get list', margin: 10
  @buttom.click do
    Thread.new do

          @edit_box = edit_box width: 680, height: 500
          loop do
            @name = Array.new()
            information = ` iwlist scan`
            i = 0
            j = 0
            information.split("\n").each do |line|
              if line.include?'ESSID'
                @name[i] = line.split(':')[1].delete('"\\"','\\""')
                @name[i] += '&'
              end
              if line.include?'Address'
                if j == 0
                  j += 1
                  next
                end
                @name[i] += line.split(' ').last
                i += 1
              end
            end
            information = `nmcli device wifi list`
            j = 0
            information.split("\n").each do |line|
              if j == 0
                j += 1
                @edit_box.text = "#{line.delete('*')}\n"
                next
              end
              @name.each do |item|
                @name_1 = if line.split(' ')[0] == '*'
                            line.split(' ')[1]
                          else
                            line.split(' ')[0]
                          end
                if item.split('&')[0].include?@name_1
                  @edit_box.text += "#{line}\n  MAC: #{item.split('&')[1]}\n"
                  break
                end
              end
            end
            sleep 1
          end
    end
  end
  @item.click do
    `nmcli dev wifi connect #{@line.text}`
  end
end