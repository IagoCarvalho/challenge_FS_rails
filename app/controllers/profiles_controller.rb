require 'github_scrapper'

class ProfilesController < ApplicationController
  include GithubScrapper

  def index
    @profiles = Profile.all
  end

  def new
    @profile = Profile.new
  end

  def create

    @profile = Profile.new(profile_params)

    github_data = web_scrap_user_profile(@profile.git_url)

    puts "\n\n------------------------"
    puts github_data
    puts "\n\n------------------------"
    @profile.attributes = {
      git_username: github_data[:git_username],
      followers: github_data[:followers],
      following: github_data[:following],
      stars_given: github_data[:stars_given],
      profile_pic_url: github_data[:profile_pic_url],
      last_years_contributions: github_data[:last_years_contributions],
    }

    # Optional parameters
    if github_data.has_key? :localization
      @profile.localization = github_data[:localization]
    end

    if github_data.has_key? :organizations
      @profile.organizations = github_data[:organizations]
    end

    if @profile.save and @profile.valid?
      redirect_to profiles_path
    else
      flash[:errors] = @profile.errors.full_messages
      redirect_to new_profile_path
    end
  end

  def show
    @profile = Profile.find(params[:id])
    puts @profile
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile = Profile.find(params[:id])
    
    redirect_to profile_path(@profile)
  end

  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy

    redirect_to profiles_path
  end

  private

  def profile_params
    params.require(:profile).permit(
      :name, 
      :git_url, 
      :git_username, 
      :followers, 
      :following, 
      :stars_given, 
      :profile_pic_url, 
      :last_years_contributions,
      :organizations,
      :localization
    )
  end

end
