class ResearchersController < Devise::RegistrationsController
	before_filter :authenticate_researcher!
	before_action :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

	# GET /resource/sign_up
	def new
		super
	end

	# POST /resource
	def create
		super
	end
	
	def show
		@researcher=Researcher.find params[:id]
		unless @researcher == current_researcher
			redirect_to :back, :alert => "تم رفض الوصول."
		end
	end
	
	def edit
		super
	end

	# PUT /resource
	def update
		update_resource(resource, researcher_params)
		render :file=>'researchers/show'
	end

	# DELETE /resource
	# def destroy
	#   super
	# end

	def note
		@note_paper = current_researcher.papers
		render :layout=>false     
	end

	# GET /resource/cancel
	# Forces the session data which is usually expired after sign
	# in to be expired now. This is useful if the user wants to
	# cancel oauth signing in/up in the middle of the process,
	# removing all OAuth session data.
	# def cancel
	#   super
	# end

	protected

	# If you have extra params to permit, append them to the sanitizer.
	def configure_sign_up_params
		devise_parameter_sanitizer.for(:sign_up) {|u| u.permit(:email,:username,:password,:password_confirmation)}
	end

	def update_resource(resource, params)
		resource.update_without_password(params)
	end
	
	private
	def researcher_params
		params.require(:researcher).permit(:general_info, :phone, :address, :birthdate, :avatar, :websiteurl)
	end
	# If you have extra params to permit, append them to the sanitizer.
	# def configure_account_update_params
	#   devise_parameter_sanitizer.for(:account_update) {|u| u.permit(:general_info, :phone, :address, :birthdate, :avatar, :websiteurl)}
	# end

	# The path used after sign up.
	# def after_sign_up_path_for(resource)
	#   super(resource)
	# end

	# The path used after sign up for inactive accounts.
	# def after_inactive_sign_up_path_for(resource)
	#   super(resource)
	# end
end
