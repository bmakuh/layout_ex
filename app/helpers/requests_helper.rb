module RequestsHelper
  
  def pending(request)
    @same = false
    for pending_request in @pending_requests
      if pending_request.request_id == request.id
        @same = true
      end
    end
    return @same
  end
end
