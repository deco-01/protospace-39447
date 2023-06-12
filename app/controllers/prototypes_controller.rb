class PrototypesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :user_show]
  before_action :set_prototype, only: [:show, :edit, :update, :destroy]
  before_action :authorize_user!, only: [:edit, :update, :destroy]
  before_action :redirect_unauthenticated_user, only: [:new, :create, :edit, :update]


  def index
    @prototypes = Prototype.all
  end

  def show
    @prototype = Prototype.find(params[:id])
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)

    if !user_signed_in? && @prototype.user == current_user
      @user = @prototype.user
      render "user_show"
    end
  end

  def new
    @prototype = Prototype.new
  end

  def edit
    @prototype = Prototype.find(params[:id])
    unless current_user == @prototype.user
      redirect_to root_path
    end
  end

  def update
    @prototype = Prototype.find(params[:id])
    if @prototype.update(prototype_params)
      redirect_to prototype_path(@prototype)
    else
      render :edit
    end
  end

  def create
    @prototype = Prototype.new(prototype_params)
  
    if @prototype.save
      redirect_to root_path, notice: "投稿が保存されました"
    else
      # @prototype = Prototype.new(prototype_params)
      render :new
    end
  end

  def destroy
    @prototype = Prototype.find(params[:id])
    @prototype.destroy
    redirect_to root_path, notice: "投稿が削除されました"
  end

  def user_show
    @user = User.find(params[:id])
  end

  private

  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def redirect_unauthenticated_user
    unless user_signed_in?
      redirect_to new_user_session_path
    end
  end

  def authorize_user!
    unless current_user == @prototype.user
      redirect_to root_path, alert: "権限がありません"
    end
  end
end