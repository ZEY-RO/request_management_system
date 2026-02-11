class RequestsController < ApplicationController
  before_action :authenticate_user!, only: %i[create update destroy]
  before_action :set_request, only: %i[show update destroy]
  before_action :authorize_user!, only: %i[update destroy]

  def index
    scope = Request.all.order(created_at: :desc)
    scope = scope.where(status: Request.statuses[params[:status]]) if params[:status].present?

    scope = scope.where('lower(title) LIKE ?', "%#{params[:title].downcase}%") if params[:title].present?
    page = params.fetch(:page, 1).to_i
    per_page = [params.fetch(:per_page, 25).to_i, 100].min
    requests_count = scope.size
    requests = scope.offset((page - 1) * per_page).limit(per_page)

    render json: { requests: requests.as_json(only: [:id, :title, :status, :created_at, :updated_at]), total_count: requests_count }
  end

  def show
    render json: { request: @request.as_json(only: [:id, :title, :description, :status, :created_at, :updated_at]) }
  end

  def create
    @request = current_user.requests.build(request_params)
    if @request.save
      render json: { request: @request }, status: :created
    else
      render json: { errors: @request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @request.update(request_params)
      render json: { request: @request.as_json(only: [:id, :title, :description, :status, :created_at, :updated_at]) }
    else
      render json: { errors: @request.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @request.destroy
    head :no_content
  end

  private

  def set_request
    @request = Request.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Request not found' }, status: :not_found
  end

  def authorize_user!
    render json: { error: 'Forbidden' }, status: :forbidden unless @request.user == current_user
  end

  def request_params
    params.require(:request).permit(:title, :description, :status)
  end
end
