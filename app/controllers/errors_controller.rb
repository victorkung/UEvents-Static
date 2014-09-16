class ErrorsController < ApplicationController

	def show
		code = status_code
		respond_to do |format|
			format.html { render status_code.to_s, :status => code }
			format.json { render :json => { :status => code }}
		end
	end

	protected

	def status_code
		params[:code] || 500
	end

end
