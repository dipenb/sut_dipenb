class PagesController < ApplicationController
  before_filter :facebook_login, :only => :home

  def home
    if params[:request_ids]
    @request_ids = params[:request_ids]
    request_id = @request_ids.split(',').last
    @sid = RequestInformation.getsid request_id
    else
    @sid = params[:sid]
    end    
    room = Room.getRoom request.remote_ip, @sid
    @opentok_session = room
  end
  
  def newfriends      
    # @user = getUser fb

    # p "session[:facebook_id]"
    # p session[:facebook_id].inspect
 
    room = Room.getRoomNewFriends( request.remote_ip, params[:sid],     
                                   session[:facebook_id] )
    @opentok_session = room
      
    if request.xhr?
      render 'newfriends.js.erb', :layout => false
    end
  end
  
  def addrequestsinfo
    @request_ids = params[:request_ids]
    @sid = params[:sid]
    @request_ids.split(',').each do |request_id|
      RequestInformation.addRequestInfo(request_id, @sid)
    end
    
    render :nothing=>true
  end
end

