class Fileless < StringIO
  def initialize(data, filename, content_type)
    super(data)
    @filename = filename
    @content_type = content_type
  end

  def content_type
    @content_type
  end

  def original_filename
    @filename
  end
end