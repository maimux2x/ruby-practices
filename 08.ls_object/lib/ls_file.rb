# frozen_string_literal: true

class LsFile
  attr_accessor :formatter, :params, :file, :file_names

  def initialize(option, params, formatter)
    @formatter = formatter
    @params = params

    option_a = option.has?(:a) ? File::FNM_DOTMATCH : 0

    @file_names =
      if File.ftype(params) == 'file'
        params.split
      elsif option.has?(:l)
        Dir.glob("#{params}/*", option_a).sort
      else
        Dir.glob('*', option_a, base: params).sort
      end

    @file_names = file_names.reverse if option.has?(:r)
  end

  def output_ls
    @formatter.output_ls(self)
  end
end
