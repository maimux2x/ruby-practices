# frozen_string_literal: true

class LsFileOutputer
  attr_reader :formatter, :file, :file_names

  def initialize(option, file, formatter)
    @formatter = formatter
    @file = file

    option_a = option.has?(:a) ? File::FNM_DOTMATCH : 0

    @file_names =
      if File.file?(file)
        file.split
      elsif option.has?(:l)
        Dir.glob("#{file}/*", option_a).sort
      else
        Dir.glob('*', option_a, base: file).sort
      end

    @file_names = file_names.reverse if option.has?(:r)
  end

  def output_ls
    puts @formatter.output_ls(self)
  end
end
