require 'github_scrapper'

class ProfilesController < ApplicationController
  include GithubScrapper

  def index
    @profiles = Profile.search(params[:search])
  end

  def new
    @profile = Profile.new
  end

  def create
    @profile = Profile.new(create_profile_params)

    begin
      github_data = web_scrap_user_profile(@profile.git_url)
    rescue
      flash[:errors] = Array("Não foi possível recuperar os dados da url especificada.")
      redirect_to new_profile_path
      return
    end

    unless github_data.nil?
      @profile.attributes = {
        git_url: github_data[:shortened_url],
        git_username: github_data[:git_username],
        followers: github_data[:followers],
        following: github_data[:following],
        stars_given: github_data[:stars_given],
        profile_pic_url: github_data[:profile_pic_url],
        last_years_contributions: github_data[:last_years_contributions]
      }
      
      # Optional attributes
      unless not github_data.has_key? :localization
        @profile.localization = github_data[:localization]
      end
  
      unless not github_data.has_key? :organizations
        @profile.organizations = github_data[:organizations]
      end

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
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile = Profile.find(params[:id])

    if @profile.update_attributes(update_profile_params)

      unless not @profile.valid? and @profile.save
        flash[:errors] = @profile.errors.full_messages
      end

      if @profile.save
        @profile.git_url = shorten_url(update_profile_params[:git_url])
        @profile.save
      end

      redirect_to profile_path(@profile)
    else
      flash[:errors] = @profile.errors.full_messages
      render :edit
    end

  end

  def destroy
    @profile = Profile.find(params[:id])
    @profile.destroy

    redirect_to profiles_path
  end

  def refresh
    @profile = Profile.find(params[:id])

    begin
      github_data = web_scrap_user_profile(@profile.git_url)
    rescue
      flash[:errors] = Array("Não foi possível recuperar os dados da url especificada.")
      redirect_to profile_path(@profile)
      return
    end

    @profile.attributes = {
      name: @profile.name,
      git_url: @profile.git_url,
      git_username: github_data[:git_username],
      followers: github_data[:followers],
      following: github_data[:following],
      stars_given: github_data[:stars_given],
      profile_pic_url: github_data[:profile_pic_url],
      last_years_contributions: github_data[:last_years_contributions]
    }

    # Optional attributes
    unless not github_data.has_key? :localization
      @profile.localization = github_data[:localization]
    end

    unless not github_data.has_key? :organizations
      @profile.organizations = github_data[:organizations]
    end

    if @profile.valid?
      @profile.save
    else
      redirect_to profile_path(@profile), flash: { error: "Ocorreu um erro ao recuperar as informações do github."}
    end

    redirect_to profile_path(@profile)
  end


  private

  def create_profile_params
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

  def update_profile_params
    params.require(:profile).permit(
      :name,
      :git_url
    )
  end

  def profile_search_params
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
      :localization,
      :search
    )
  end

end
