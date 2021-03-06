class CoursesController < ApplicationController

  def index
    # session[:test_message] = "Please tell me this works"
    @courses = Course.all.order('sort_order')
  end

  def new
    @course = Course.new
    unless can? :create, @course
      flash[:notice] = 'Only admins can access this page'
      redirect_to "/courses"
    end
  end

  def create
    @course = Course.create(course_params)
    redirect_to '/courses'
  end

  def show
    @course = Course.find(params[:id])
  end

  def edit
    @course = Course.find(params[:id])
    unless can? :edit, @course
      flash[:notice] = 'You can only edit your own courses'
      redirect_to "/courses"
    end
  end

  def update
    @course = Course.find(params[:id])
    @course.update(course_params)
    redirect_to '/courses'
  end

  def destroy
    @course = Course.find(params[:id])
    if can? :delete, @course
      @course.destroy
      flash[:notice] = 'Course deleted successfully'
    else
      flash[:notice] = 'Only admin can delete courses'
    end
      redirect_to '/courses'
  end

  def course_params
    params.require(:course).permit!
  end
end
