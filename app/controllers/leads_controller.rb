class LeadsController < ApplicationController
  def index
    @leads = Lead.all
  end

  def show
    @lead = Lead.find params[:id]
  end

  def edit
    @lead = Lead.find params[:id]
  end

  def new
    @lead = Lead.new
  end

  def create
    @lead = Lead.new lead_params

    @lead.save
    redirect_to @lead
  end

  def update
    @lead = Lead.find params[:id]

    if @lead.update(lead_params)
      redirect_to @lead
    else
      render 'edit'
    end
  end

  private

  def lead_params
    params.require(:lead).permit(:first_name, :last_name, :email)
  end
end
