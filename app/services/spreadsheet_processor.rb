require 'roo'
require 'json'


class SpreadsheetProcessor
  def initialize document
    @document = document
    @spreadsheet = document.spreadsheet
  end

  
  def process
    file_path = get_file_path
    xlsx = Roo::Spreadsheet.open(file_path, extension: :xlsx)
    json = generate_json xlsx.sheet(0), process_sheet(xlsx.sheet(0))
    json
  end
  
  def get_file_path
    return ActiveStorage::Blob.service.path_for(@spreadsheet.key)
  end
  
  def process_sheet sheet
    headers = sheet.row(1)
    header_hash = {}
    headers.each do |header|
      header_hash[header.parameterize.underscore.to_sym] = header
    end 
    sheet.parse(header_hash)
  end
  
  def generate_json sheet, array
    hash = {
      headers: sheet.row(1),
      rows: array,
    }.to_json
  end
end

