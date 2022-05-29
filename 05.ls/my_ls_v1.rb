# frozen_string_literal: true

def current_empty?
  # カレントディレクトリが空かをチェック
  Dir.empty?(Dir.getwd)
end

def output_current
  # カレントディレクトリが空だったら処理を抜ける
  return true if current_empty?

  # 隠しファイルなど表示不要な対象を除いて、文字列の昇順で配列を作成
  first_ary = Dir.glob('*').sort

  # 配列を３等分して二次元配列を作る準備
  n = 3
  splite_ary = Rational(first_ary.size, n).ceil

  # 配列の中にさらに3つの配列を持つ二次元配列の作成
  second_ary = first_ary.each_slice(splite_ary).to_a

  # 配列を並び替えるために要素の最大値を求め、要素が足りない配列はnilで埋める
  max_size = second_ary.map(&:size).max
  third_ary = second_ary.map { |ary| ary.values_at(0...max_size) }

  # 必須要件の並びを満たすように配列の並び替え
  result = third_ary.transpose

  # 並び替えた配列の要素を左詰で出力
  num = first_ary.map(&:size).max
  result.each do |ary|
    ary.each do |str|
      print str&.ljust(num + 5)
    end
    puts "\n"
  end
end

output_current
