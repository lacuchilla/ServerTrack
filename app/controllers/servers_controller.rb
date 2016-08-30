class ServersController < ApplicationController
  def index
    @servers = Server.all
    render json: @servers.as_json
  end

  def show
    @server = Server.find_by(id: params[:id])
    if @server
      render json: @server.as_json
    else
      render json: {}, status: 204
    end
  end

  def create
    @server = Server.create(server_params)
    render json: @server.as_json
  end
end

private
  def server_params
    params.permit(server: [:id. :name])
  end
