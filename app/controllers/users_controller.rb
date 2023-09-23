class UsersController < ApplicationController
    
    def show
        @user=User.find(params[:id])
        @articles = @user.articles
    end
    def new
        @user= User.new
    end

    def index
        @users=User.all
    end
    
    def edit
        @user=User.find(params[:id])
    end

    def update
        @user=User.find(params[:id])

        if @user.update(user_params)

            flash[:notice]="User profile Updates successfully"
            redirect_to articles_path
        else
            render 'edit',status:422
        end
    end

    def create
      @user= User.new(user_params)

      if @user.save

        flash[:notice]="welcome to alphaBlog #{@user.username}. You are successfully signed up"
        redirect_to articles_path

      else
        render 'new', status:422
      end

    end

    private

    def user_params
        params.require(:user).permit(:username,:email, :password)
    end
end