# frozen_string_literal: true

require "csv"

module Utils
  class CsvGenerator
    class FileIO < StringIO
      attr_accessor :original_filename
    end

    attr_reader :data, :headers, :options

    def initialize(data, headers, options = {})
      @data = data
      @headers = headers
      @options = options
    end

    def call
      csv = CSV.generate(headers: true) do |csv|
        csv << headers

        data.each do |row|
          csv << row
        end
      end

      file = FileIO.new(csv)
      file.original_filename = "#{options[:filename]}.csv"

      file
    end
  end
end
