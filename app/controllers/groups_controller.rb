class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  before_action :minimum, only: [:random_people]

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all
    @people = Person.all
  end

  # GET /groups/1
  # GET /groups/1.json
  # def show
  # end

  # GET /groups/new
  def new
    @group = Group.new
  end

  # GET /groups/1/edit
  def edit
  end

  # POST /groups
  # POST /groups.json
  def create
    @group = Group.new(group_params)

    respond_to do |format|
      if @group.save
        format.html { redirect_to root_path, notice: 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: root_path.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to root_path, notice: 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_url, notice: 'Group was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def random_people
      @people = Person.all
      @groups = Group.all

        maxByGroup = (@people.size/@groups.size).ceil+1
  # on vide les groupes_id des personnes
  @people.each do |person|
      person.group_id = nil
      person.save
  end

  id_group = []
  @groups.each do |group|
      id_group << group.id
  end

  @people.each do |i|
      random_group = id_group.sample
      i.group_id = random_group
  i.save
      if @people.where(group_id: random_group).size == maxByGroup
          id_group.delete(random_group)
      end

  end
redirect_to root_path
  end




  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :salle, :tache)
    end

    def minimum
        if Group.all.size < 2
            redirect_to root_path, notice: 'you must create two groups minimum'
    end
end

end
