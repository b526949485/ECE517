class ToursController < ApplicationController
  before_action :set_tour, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :index]

  # GET /tours
  # GET /tours.json
  def index
    @tours = Tour.all
    if params[:search]
      @tours = Tour.search(params[:search]).order("created_at DESC")
    else
      @tours = Tour.all.order('created_at DESC')
    end
    # @filterrific = initialize_filterrific(
    #     Tour,
    #     params[:filterrific]
    # ) or return
    # @tours = @filterrific.find.page(params[:page])
    #
    # respond_to do |format|
    #   format.html
    #   format.js
    # end
  end

  # GET /tours/1
  # GET /tours/1.json
  def show

    @tour = Tour.find(params[:id])
    authorize @tour


    @country = @tour.country.split(';')
    @state = @tour.state.split(';')



    @review = Review.new
    @reviews = @tour.reviews

    @book = Book.new
    @books = @tour.books

    @waitlist = Waitlist.new
    @waitlists = @tour.waitlists

    @bookmark = Bookmark.new
    @bookmarks = @tour.bookmarks


    @flag = Bookmark.where(tour_id: @tour.id, user_id: current_user.id).any?



  end

  # GET /tours/new
  def new
    @tour = Tour.new
    authorize @tour

  end

  # GET /tours/1/edit
  def edit


    authorize @tour
  end

  # POST /tours
  # POST /tours.json
  def create


    @tour = Tour.new(tour_params)
    authorize @tour

    @tour.user = current_user
    @tour.aval_seat = @tour.total_seat
    # @tour.status = 'future'


    # country_list = @tour.country.split(';')
    # state_list = @tour.state.split(';')
    #
    # if (country_list.length != state_list.length)
    #
    #   respond_to do |format|
    #     format.html {render :new}
    #     format.json {render json: @tour.errors, status: :unprocessable_entity}
    #
    #   end
    #
    # else

    respond_to do |format|
      if @tour.save
        format.html {redirect_to @tour, notice: 'Tour was successfully created.'}
        format.json {render :show, status: :created, location: @tour}
      else
        format.html {render :new}
        format.json {render json: @tour.errors, status: :unprocessable_entity}
      end
    end

    # end
  end

  # PATCH/PUT /tours/1
  # PATCH/PUT /tours/1.json
  def update
    authorize @tour

    old_total_seat = @tour.total_seat
    old_aval_seat = @tour.aval_seat
    old_status = @tour.status

    if (old_status == 'completed')
      respond_to do |format|
        format.html {redirect_to tour_path(@tour), notice: 'Completed tour can not be cancelled or re-opened.'}
      end
    else

      @tour.update(tour_params)


      if (@tour.total_seat >= old_total_seat)
        respond_to do |format|
          if Tour.update(@tour.id, :aval_seat => old_aval_seat + (@tour.total_seat - old_total_seat))
            format.html {redirect_to tour_path(@tour), notice: 'Tour updated 1. '}
            # format.json { render :show, status: :ok, location: @tour }
          else
            # format.html {render :edit}
            # format.json { render json: @tour.errors, status: :unprocessable_entity }
          end
        end

      else

        if (old_aval_seat - (old_total_seat - @tour.total_seat) >= 0)
          respond_to do |format|
            if Tour.update(@tour.id, :aval_seat => old_aval_seat - (old_total_seat - @tour.total_seat))
              format.html {redirect_to tour_path(@tour), notice: 'Tour updated 2.'}
              # format.json { render :show, status: :ok, location: @tour }
            else
              # format.html {render :edit}
              # format.json { render json: @tour.errors, status: :unprocessable_entity }
            end
          end

        else
          Tour.update(@tour.id, :total_seat => old_total_seat)


          respond_to do |format|
            format.html {redirect_to edit_tour_path(@tour), notice: 'Entered total seats can not less the current available seats.'}
          end


        end

      end

    end

  end

  # DELETE /tours/1
  # DELETE /tours/1.json
  def destroy
    authorize @tour
    @tour.destroy
    respond_to do |format|
      format.html {redirect_to tours_url, notice: 'Tour was successfully destroyed.'}
      format.json {head :no_content}
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tour
    @tour = Tour.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def tour_params
    params.require(:tour).permit(:name, :description, :total_seat, :aval_seat, :user_id, :price, :booking_deadline,
                                 :start_date, :end_date, :start_location, :contact_info, :status,
                                 :country, :state)
  end
end

