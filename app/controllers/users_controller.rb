class UsersController < ApplicationController

    before_action :set_user, only: [:edit,:update,:show,:destroy]
    before_action  :require_user, only: [:edit,:update ,:destroy]
    before_action :require_same_user, only: [:edit,:update,:destroy]
    
    def show
        @articles = @user.articles.paginate(page: params[:page], per_page: 3)
    end
    def new
        @user= User.new
    end

    def index
        @users=User.paginate(page: params[:page], per_page: 3)
    end
    
    def edit
    end

    def update

        if @user.update(user_params)

            flash[:notice]="User profile Updates successfully"
            redirect_to @user
        else
            render 'edit',status:422
        end
    end

    def create
      @user= User.new(user_params)

      if @user.save
        session[:user_id] = @user.id
        flash[:notice]="welcome to alphaBlog #{@user.username}. You are successfully signed up"
        redirect_to users_path

      else
        render 'new', status:422
      end

    end

    def destroy
       @user.destroy
       session[:user_id] = nil if @user == current_user
       flash[:notice]= "account and associations successfully deleted"
       redirect_to root_path
       
    end

    private
    def set_user
         @user=User.find(params[:id])
    end
    def user_params
        params.require(:user).permit(:username,:email, :password)
    end

    def require_same_user
        if current_user != @user && !current_user.admin?
            flash[:alert]="you can only edit or delete  your own profile"
            redirect_to users_path
        end
    end
end