module Admin
  class BooksController < Admin::ApplicationController
    # To customize the behavior of this controller,
    # you can overwrite any of the RESTful actions. For example:
    #
    # def index
    #   super
    #   @resources = Book.
    #     page(params[:page]).
    #     per(10)
    # end

    # Define a custom finder by overriding the `find_resource` method:
    # def find_resource(param)
    #   Book.find_by!(slug: param)
    # end

    def valid_action?(name, resource = resource_class)
      %w[new edit destroy].exclude?(name.to_s) && super
    end
    # See https://administrate-prototype.herokuapp.com/customizing_controller_actions
    # for more information
  end
end
