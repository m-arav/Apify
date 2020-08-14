class Document < ApplicationRecord
  has_one_attached :spreadsheet

  def spreadsheet_json
    SpreadsheetProcessor.new(self).process
  end
end
