# frozen_string_literal: true

class Ui::SearchController < Ui::ApplicationController
  def search
    respond_to do |format|
      format.html do
        # Paginated results have search[query], nested
        search_query = params[:query] || (params[:search] && params[:search][:query])

        # This checks if the query exists/is not nil and whether or not it is a
        # string. Code injection will usually cause the query to be something
        # else, i.e. {"injected_param"=>"injected_val"} permitted: false>]
        # This way, the injected code doesn't make it past this point.

        if search_query.is_a?(String)
          search = build_search
          render locals: { search: search, results: search.results }
        else
          redirect_to "/ui/search?query="
        end
      end
    end
  end

  private

  def build_search
    if params.key?(:query)
      Search.new(api: api, query: params[:query], page: params[:page])
    else
      Search.new(search_params.merge(api: api))
    end
  end

  def search_params
    params
      .require(:search)
      .permit(:query, :policy, :layer, :group, :host, :user, :variable, :webservice,
              :aws, :cyberark, :jenkins, :puppet, :saltstack, :ansible, :chef, :page,
              :cloudfoundry, :pivotalcloudfoundry, :kubernetes, :openshift, :terraform, :vault)
  end
end
