class MessagesController < ApplicationController
  def index
    @messages = Message.all
  end

  def show
    @message = Message.find params[:id]
    @send_results = Ahoy::Message.where message_id: params[:id]
  end

  def edit
    @message = Message.find params[:id]
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new message_params

    @message.save
    redirect_to @message
  end

  def update
    @message = Message.find params[:id]

    if @message.update(message_params)
      redirect_to @message
    else
      render 'edit'
    end
  end

  private

  def message_params
    params.require(:message).permit(:from_name, :from_email, :subject, :content)
  end
end
