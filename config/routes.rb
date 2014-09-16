Uevents::Application.routes.draw do
	root 'pages#home'
	get '/about'            					=> 'pages#about', 						as: :about
	get '/terms_of_service'   			=> 'pages#tos', 							as: :tos
	get '/privacy'            					=> 'pages#privacy', 					as: :privacy
	get '/contact'         						=> 'pages#contact', 					as: :contact
	get '/faq'                						=> 'pages#faq', 							as: :faq
	get '/schools'								=> 'pages#schools',						as: :schools
	get '/register'								=> 'pages#facebook',					as: :register
	get '/preview_event'				=> 'pages#preview_event'

	get '/logout' 								=> 'sessions#destroy', 				as: :logout

	# Error Pages
	%w(404 422 500).each do |code|
		get code, :to => 'errors#show', :code => code
	end

	scope '/jobs' do
		root 'jobs#main', as: :jobs
		get '/business-dev'           => 'jobs#business-dev', 			as: :business_dev
		get '/backend-engineer'       => 'jobs#backend-engineer', 	as: :backend_engineer
		get '/frontend'           		=> 'jobs#frontend', 					as: :frontend
		get '/marketing'           		=> 'jobs#marketing', 					as: :marketing
		get '/designer'           		=> 'jobs#designer', 					as: :designer
		get '/mobile'           			=> 'jobs#mobile', 						as: :mobile
	end
end
