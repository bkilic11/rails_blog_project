class ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :destroy, :show]
  
  def index
    @article = Article.all
    @q = Article.ransack(params[:q])

     if params[:q].present? && params[:q][:title_or_content_cont].length > 0 && params[:q][:title_or_content_cont].length < 5
        flash.now[:alert] = "5 karakterden az yazamazsın!"
     elsif params[:q].present? && params[:q][:title_or_content_cont].length == 0
        flash.now[:alert] = "Hiç karakter girmediniz!"
     else
        @article = @q.result(distinct: true).order(:title).to_a
     end    
  end

  def show
  end

  def edit
  end

  def update

    if @article.update(article_params)
      redirect_to articles_path(@article)
    else
      render :edit
    end
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render :new
    end
  end

  def destroy
    @article.destroy
    redirect_to articles_path
  end

  private

  def article_params
    params.require(:article).permit(:title, :content, :avatar)
  end

  def set_article
    @article = Article.find(params[:id])
  end
end
