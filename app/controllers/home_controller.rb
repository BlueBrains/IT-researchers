require 'pusher'

Pusher.app_id = '129623' #I've provided the correct app_id
Pusher.key =  '80b5913c49bad64d4921'
Pusher.secret = '2f89c7340e377d19b4b2' #I've provided the correct app_secret
Pusher.url = "https://80b5913c49bad64d4921:2f89c7340e377d19b4b2@api.pusherapp.com/apps/129623"
Pusher.logger = Rails.logger

class HomeController < ApplicationController
 before_action :set_paper, only: [:show]
  
  def feed
    @papers = Paper.published
    respond_to do |format|
      format.rss { render :layout => false }
    end
  end
  
  def index  	  	
    @researcher = current_researcher
    @papers=Paper.published.order_by(:times_seen => 'desc').limit(8)
    @index=false

    #render :file=>'home/index' , :layout=>false     
    # @researchers = Researcher.collection.aggregate([
    #   {"$unwind" => "$paper_ids"},
    #   {"$group" => {_id: "$_id", paper_ids: {"$push"=>"$paper_ids"}, size: {"$sum" => 1}}}, 
    #   {"$sort" => {size: 1}}]);
  end
    
  def show
    @paper.inc(times_seen: 1)
    document = Nokogiri::XML(File.read(Rails.root.to_s+'/public/'+@paper.id.to_s+'.xml'))
    template = Nokogiri::XSLT(File.open(Rails.root.to_s+'/public/xopus/examples/simple/xsl/stylesheet.xsl','rb'))
    @html_document = template.transform(document)     
    @related_papers = @paper.similar.limit(3)
  end

  def like_it
  	@paper = Paper.find(params[:id])
  	if(current_researcher.likes.nil? || (!current_researcher.likes.include? @paper.id))
  		@paper.push(likers: current_researcher.id)
  		current_researcher.push(likes: @paper.id)
  		@paper.inc(likes: 1)
          Pusher.trigger(@paper.id, 'like', {
        message: "likes  &nbsp; " + @paper.likes.to_s() ,
        types: "like",
        id:@paper.id.to_s()
      }) 
  	else
		@paper.pull(likers: current_researcher.id)
		current_researcher.pull(likes: @paper.id)
  		@paper.inc(likes: -1)

          Pusher.trigger(@paper.id, 'like', {
        message: "likes  &nbsp; " + @paper.likes.to_s() ,
        types: "dislike" ,
        id:@paper.id.to_s()
      }) 
  	end 
    render :nothing => true
    #redirect_to paper_path(@paper)
  end

  def about
  end  

  def contact_us
  end  

  def set_paper
    @paper = Paper.find(params[:id])
  end

  def get_xopus
    @filename=params[:id]
    render :file=>'shared/x' , :layout=>false   
  end  

    def create_xml_temp
    #params[:uri]
    #current_researcher.to_s+
    save_path = Rails.root.join('public','amer2.xml')
    File.open(save_path, 'wb') do |file|
       file << params[:doc]
    end
    #TODO: Add your tags
    render :nothing=>true
  end
end
