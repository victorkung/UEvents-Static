require 'open-uri'

class FacebookController < ApplicationController

  def callback
    user = User.find_by_facebook_id(params[:id])
    if user.nil?
      user = FacebookUser.create(params)
    else
      FacebookUser.update(user, params)
      Resque.enqueue(Jobs::SyncFacebookEventsJob, user.id)
    end
    session[:authentication_token] = user.authentication_token

    if params[:redirect_to].to_s.empty?
      redirect_to events_path
    else
      redirect_to params[:redirect_to]
    end
  end

  def login
    if params[:code]
      url ="https://graph.facebook.com/oauth/access_token?client_id=#{ENV['FACEBOOK_APP_ID']}&redirect_uri=#{root_url}login&client_secret=#{ENV['FACEBOOK_APP_SECRET']}&code=#{params[:code]}"
      response = open(url).read
      access_token = response.split('&').first.split('=').last
      params[:access_token] = access_token
      uri = "https://graph.facebook.com/me?fields=id,first_name,last_name,email&access_token=#{params[:access_token]}"
      results = JSON.parse(open(uri).read).with_indifferent_access
      params[:id] = results[:id] if results
      callback
    else
      redirect_to root_url
    end
  end

end
