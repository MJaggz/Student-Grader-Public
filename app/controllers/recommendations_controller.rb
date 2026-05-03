class RecommendationsController < ApplicationController
  def index
    @recommendations = Recommendation.all
  end

  def by_last_name_id
    @user_email = current_user.email
    @last_name_id = @user_email.delete_suffix("@osu.edu")

    @recommendations = if @last_name_id.present?
                        Recommendation.where(last_name_id: @last_name_id)
                      else
                        Recommendation.none
                      end
  end
  
  def show
    @recommendation = Recommendation.find(params[:id])
    redirect_to root_path, notice: "Recommendation was submitted successfully."
  end

  def new
    @recommendation = Recommendation.new
  end

  def create
    @recommendation = Recommendation.new(recommendation_params)

    existing_recommendation = Recommendation.find_by(recommendation_params)

    if existing_recommendation
      @recommendation.errors.add(:base, "This recommendation already exists.")
      render :new, status: :unprocessable_entity
    elsif @recommendation.save
      redirect_to @recommendation, notice: "Recommendation was created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def change_status
    @recommendation = Recommendation.find(params[:id])

    if @recommendation.update(status: true)
      redirect_to recommendations_path, notice: "Recommendation status was updated successfully."
    else
      redirect_to recommendations_path, alert: "Could not update recommendation status."
    end
  end

  private

  def recommendation_params
    params.require(:recommendation).permit(
      :recommended_by,
      :first_name,
      :last_name,
      :last_name_id,
      :course,
      :section
    )
  end
end
