class Ability
  include CanCan::Ability

  def initialize(researcher)
    guest = Researcher.new
    guest.add_role "guest"
    researcher ||= guest # Guest user if there's no user
    # Define abilities for the passed in user here. For example:
    #
    
      if researcher.has_role? :admin
        can :manage, :all
      else
        unless researcher.has_role? :blocked
          can [:index, :show, :download, :find_by_tag], Paper
          if researcher.has_role? :researcher
            can [:create, :new], Paper 
            can [:edit, :update, :destroy], Paper do |paper| 
              paper.researcher_ids.include? researcher.id 
            end
          end
        end
      #else
      #  can :read, Paper unless researcher.has_role? :block
      #  #can :create, Paper if researcher.has_role? :researcher
      #  can [:update, :destroy], Paper, :researcher_id => researcher._id  if researcher.has_role? :researcher
      end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
