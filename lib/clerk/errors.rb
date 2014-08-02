module Clerk
  class NoAccount           < StandardError; end
  class InvalidToken        < StandardError; end
  class InvalidRequest      < StandardError; end
  class RecordNotFound      < StandardError; end
  class RequestTimeout      < StandardError; end
  class CrossedLimit        < StandardError; end
  class InternalServerError < StandardError; end
  class MaintenanceMode     < StandardError; end
end