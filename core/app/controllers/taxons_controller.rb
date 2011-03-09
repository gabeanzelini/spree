class TaxonsController < Spree::BaseController
  #prepend_before_filter :reject_unknown_object, :only => [:show]
  before_filter :load_data, :only => :show
  resource_controller
  actions :show
  helper :products
  rescue_from ActiveRecord::RecordNotFound, :with => :render_404

  private
  def load_data
    @taxon ||= object
    params[:taxon] = @taxon
    @searcher = Spree::Config.searcher_class.new(params)
    @products = @searcher.retrieve_products
  end

  def object
    @object ||= end_of_association_chain.find_by_permalink(get_permalink_from_id)
  end
  
  def get_permalink_from_id
    params[:id][-1] == "/" ? params[:id] : "#{params[:id]}/"
  end

  def accurate_title
    @taxon ? @taxon.name : nil
  end
end
