module RspecHelpers
  def json(body)
    JSON.parse(body, symbolize_names: true)
  end

  def uploaded_file(path, content_type='image/png')
    path = Rails.root.join('spec/fixtures/files', path)
    Rack::Test::UploadedFile.new(path, content_type, true)
  end
end
