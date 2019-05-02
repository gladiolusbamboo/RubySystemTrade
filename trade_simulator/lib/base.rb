# indicatorフォルダとrurleフォルダ、そのサブフォルダ内にある全てのファイル名からなる配列を作る
Dir["./lib/{indicator,rule}/**/*.rb"].each do |file|
    # basename : ディレクトリ名と拡張子を覗いたファイル名を得る
    class_name = File.basename(file, ".rb") 
                     .split("_")            # _で区切られている単語ごとに分割し
                     .map{|s| s.capitalize} # 単語の先頭を大文字にして
                     .join("")              # つなぎあわせる
                     # Ex. path/moving_average.rb → MovingAverage
    autoload class_name, file
end
